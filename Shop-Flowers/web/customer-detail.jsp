<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>Customer Detail</title>
</head>
<body>
<h2>Customer Detail</h2>
<form action="customers" method="post">
    <input type="hidden" name="action" value="update"/>
    <input type="hidden" name="id" value="${customer.id}"/>
    Full Name: <input type="text" name="fullName" value="${customer.fullName}"/><br/>
    Email: <input type="email" name="email" value="${customer.email}"/><br/>
    Phone: <input type="text" name="phone" value="${customer.phone}"/><br/>
    DOB: <input type="date" name="dob" value="${customer.dob}"/><br/>
    Status: 
    <select name="status">
        <option value="active" ${customer.status=='active'?'selected':''}>Active</option>
        <option value="inactive" ${customer.status=='inactive'?'selected':''}>Inactive</option>
    </select><br/>
    <button type="submit">Save</button>
    <a href="customers">Back</a>
</form>
</body>
</html>
