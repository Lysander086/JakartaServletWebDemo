package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/submit")
public class FormServlet extends HttpServlet {

    private static final Logger log = Logger.getLogger(FormServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name    = req.getParameter("name");
        String email   = req.getParameter("email");
        String message = req.getParameter("message");

        log.info("=== Form Submission ===");
        log.info("Name:    " + name);
        log.info("Email:   " + email);
        log.info("Message: " + message);

        // Redirect back to the form with a ?sent=1 flag so the user sees confirmation
        resp.sendRedirect(req.getContextPath() + "/index.jsp?sent=1");
    }
}
