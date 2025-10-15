<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>Customer Management</title>
</head>
<body>
<h2>Customer Management</h2>
<table border="1">
    <tr>
        <th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Status</th><th>Action</th>
    </tr>
    <c:forEach var="c" items="${customers}">
        <tr>
            <td>${c.id}</td>
            <td>${c.fullName}</td>
            <td>${c.email}</td>
            <td>${c.phone}</td>
            <td>${c.status}</td>
            <td>
                <form action="customers" method="post" style="display:inline">
                    <input type="hidden" name="action" value="status"/>
                    <input type="hidden" name="id" value="${c.id}"/>
                    <input type="hidden" name="status" value="${c.status=='active'?'inactive':'active'}"/>
                    <button type="submit">${c.status=='active'?'Deactivate':'Activate'}</button>
                </form>
                <a href="customers?action=detail&id=${c.id}">View Detail</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
