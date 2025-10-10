<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>

<%
    User customer = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f9f9f9;
        }
        h1 {
            color: #333;
        }
        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            width: 400px;
        }
        input, select, button, a {
            display: block;
            margin-top: 10px;
            width: 100%;
            padding: 8px;
            font-size: 14px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        a {
            text-align: center;
            text-decoration: none;
            color: white;
            background-color: #6c757d;
            border-radius: 6px;
            margin-top: 10px;
        }
        a:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <h1>Edit Customer Information</h1>

    <% if (customer != null) { %>
        <form action="<%= request.getContextPath() %>/admin/customers" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= customer.getId() %>">

            <label>Full Name:</label>
            <input type="text" name="full_name" value="<%= customer.getFullName() %>" required>

            <label>Email:</label>
            <input type="email" name="email" value="<%= customer.getEmail() %>" required>

            <label>Phone:</label>
            <input type="text" name="phone" value="<%= customer.getPhone() %>" required>

            <label>Date of Birth:</label>
            <input type="date" name="dob" 
                   value="<%= customer.getDob() != null 
                            ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(customer.getDob()) 
                            : "" %>">

            <label>Status:</label>
            <select name="status">
                <option value="Active" <%= "Active".equals(customer.getStatus()) ? "selected" : "" %>>Active</option>
                <option value="Inactive" <%= "Inactive".equals(customer.getStatus()) ? "selected" : "" %>>Inactive</option>
            </select>

            <button type="submit">💾 Save Changes</button>
            <a href="<%= request.getContextPath() %>/admin/customers?action=list">Cancel</a>
        </form>
    <% } else { %>
        <p style="color:red;">Customer not found!</p>
        <a href="<%= request.getContextPath() %>/admin/customers?action=list">Back to list</a>
    <% } %>
</body>
</html>
