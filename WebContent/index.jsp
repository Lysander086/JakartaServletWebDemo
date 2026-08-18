<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Form Demo</title>
    <style>
        body { font-family: sans-serif; max-width: 400px; margin: 60px auto; }
        label { display: block; margin-top: 12px; font-weight: bold; }
        input, textarea { width: 100%; padding: 8px; margin-top: 4px; box-sizing: border-box; }
        button { margin-top: 16px; padding: 10px 24px; cursor: pointer; }
        .success { color: green; margin-top: 16px; }
    </style>
</head>
<body>
    <h2>Contact Form</h2>

    <%-- Show confirmation message after redirect ---%>
    <% if ("1".equals(request.getParameter("sent"))) { %>
        <p class="success">Submitted! Check the server log.</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/submit" method="post">
        <label for="name">Name</label>
        <input type="text" id="name" name="name" required placeholder="Your name">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required placeholder="you@example.com">

        <label for="message">Message</label>
        <textarea id="message" name="message" rows="4" required placeholder="Write something..."></textarea>

        <button type="submit">Submit</button>
    </form>
</body>
</html>
