# Jakarta Servlet Web Demo

Simple contact form web app built with Java Servlet + JSP, packaged as a WAR via Apache Ant, and deployed to Tomcat.

## Tech Stack

- Java 21
- Jakarta EE Servlet API (Servlet 6.0)
- JSP
- Apache Tomcat
- Apache Ant (`build.xml`)

## Project Structure

```text
fl_dev/
  src/com/example/FormServlet.java
  WebContent/index.jsp
  WebContent/WEB-INF/web.xml
  build.xml
  run.sh
```

## Prerequisites

On macOS (Homebrew):

```bash
brew install ant tomcat openjdk@21
```

## Quick Start

From project root:

```bash
./run.sh up
```

Then open:

- http://localhost:8080/form-demo/

## run.sh Commands

```bash
./run.sh up       # Build + deploy + start Tomcat
./run.sh build    # Build WAR only
./run.sh deploy   # Build + deploy WAR
./run.sh start    # Start Tomcat only
./run.sh stop     # Stop Tomcat
./run.sh restart  # Restart Tomcat
./run.sh status   # Check Tomcat process status
```

## Manual Build/Deploy (Optional)

```bash
ant -Dtomcat.home=/opt/homebrew/opt/tomcat/libexec war
ant -Dtomcat.home=/opt/homebrew/opt/tomcat/libexec deploy
/opt/homebrew/opt/tomcat/bin/catalina start
```

## Notes

- `build.xml` has a Windows-style default `tomcat.home`; on macOS, use `run.sh` or pass `-Dtomcat.home`.
- This project requires Java 21 for compilation (`source/target=21`).
- `run.sh` auto-switches to Homebrew Java 21 path if current shell is on older Java.

## Troubleshooting

If `ant` is not found:

```bash
brew install ant
```

If Java version is below 21:

```bash
brew install openjdk@21
```

If Tomcat path is custom, override env vars:

```bash
TOMCAT_BASE=/your/tomcat/base TOMCAT_HOME=/your/tomcat/home ./run.sh up
```
