#!/usr/bin/env bash
set -euo pipefail

# Project root (directory containing this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Defaults for Homebrew on Apple Silicon; override with env vars if needed.
JAVA_HOME_DEFAULT="/opt/homebrew/opt/openjdk@21"
TOMCAT_BASE_DEFAULT="/opt/homebrew/opt/tomcat"
TOMCAT_HOME_DEFAULT="/opt/homebrew/opt/tomcat/libexec"

export JAVA_HOME="${JAVA_HOME:-$JAVA_HOME_DEFAULT}"
export PATH="$JAVA_HOME/bin:/opt/homebrew/bin:$PATH"

TOMCAT_BASE="${TOMCAT_BASE:-$TOMCAT_BASE_DEFAULT}"
TOMCAT_HOME="${TOMCAT_HOME:-$TOMCAT_HOME_DEFAULT}"
CATALINA_CMD=""
APP_NAME="form-demo"
APP_URL="http://localhost:8080/${APP_NAME}/"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[ERROR] Missing command: $1"
    exit 1
  fi
}

java_major_version() {
  "$JAVA_HOME/bin/java" -version 2>&1 | awk -F '[".]' '/version/ {print $2; exit}'
}

ensure_java_21() {
  local required=21
  local current=0

  if [[ -x "$JAVA_HOME/bin/java" ]]; then
    current="$(java_major_version || echo 0)"
  fi

  if [[ "$current" -lt "$required" ]]; then
    if [[ -x "$JAVA_HOME_DEFAULT/bin/java" ]]; then
      echo "[WARN] Current JAVA_HOME is Java $current. Switching to Java 21 for this project."
      export JAVA_HOME="$JAVA_HOME_DEFAULT"
      export PATH="$JAVA_HOME/bin:/opt/homebrew/bin:$PATH"
    else
      echo "[ERROR] Java 21 is required, but not found at: $JAVA_HOME_DEFAULT"
      echo "        Install with: brew install openjdk@21"
      exit 1
    fi
  fi
}

check_prerequisites() {
  ensure_java_21
  require_cmd ant
  require_cmd java
  # Homebrew provides /opt/homebrew/opt/tomcat/bin/catalina wrapper.
  # Fallback to catalina.sh under TOMCAT_HOME if needed.
  if [[ -x "$TOMCAT_BASE/bin/catalina" ]]; then
    CATALINA_CMD="$TOMCAT_BASE/bin/catalina"
  elif [[ -x "$TOMCAT_HOME/bin/catalina.sh" ]]; then
    CATALINA_CMD="$TOMCAT_HOME/bin/catalina.sh"
  else
    echo "[ERROR] catalina executable not found."
    echo "        Checked: $TOMCAT_BASE/bin/catalina"
    echo "                 $TOMCAT_HOME/bin/catalina.sh"
    echo "        Install Tomcat or set TOMCAT_BASE/TOMCAT_HOME env vars."
    exit 1
  fi

  if [[ ! -d "$TOMCAT_HOME/lib" ]]; then
    echo "[ERROR] Tomcat libs not found: $TOMCAT_HOME/lib"
    echo "        Set TOMCAT_HOME to a path that contains lib/servlet-api.jar"
    exit 1
  fi
}

build_war() {
  echo "[INFO] Building WAR with Ant..."
  ant -Dtomcat.home="$TOMCAT_HOME" war
}

deploy_war() {
  echo "[INFO] Deploying WAR to Tomcat webapps..."
  ant -Dtomcat.home="$TOMCAT_HOME" deploy
}

start_tomcat() {
  echo "[INFO] Starting Tomcat..."
  "$CATALINA_CMD" start
  echo "[INFO] App URL: $APP_URL"
}

stop_tomcat() {
  echo "[INFO] Stopping Tomcat..."
  "$CATALINA_CMD" stop
}

status_tomcat() {
  if pgrep -f "org.apache.catalina.startup.Bootstrap" >/dev/null 2>&1; then
    echo "[INFO] Tomcat appears to be running."
  else
    echo "[INFO] Tomcat is not running."
  fi
}

usage() {
  cat <<'EOF'
Usage: ./run.sh <command>

Commands:
  up       Build + deploy + start Tomcat
  build    Build WAR only
  deploy   Build + deploy WAR
  start    Start Tomcat only
  stop     Stop Tomcat
  restart  Stop then start Tomcat
  status   Show Tomcat process status

Examples:
  ./run.sh up
  ./run.sh status
EOF
}

main() {
  check_prerequisites

  local cmd="${1:-up}"
  case "$cmd" in
    up)
      build_war
      deploy_war
      start_tomcat
      ;;
    build)
      build_war
      ;;
    deploy)
      build_war
      deploy_war
      ;;
    start)
      start_tomcat
      ;;
    stop)
      stop_tomcat
      ;;
    restart)
      stop_tomcat || true
      start_tomcat
      ;;
    status)
      status_tomcat
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
