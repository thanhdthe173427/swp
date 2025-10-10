<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) request.getAttribute("user");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Detail</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-pink-50 to-pink-100 min-h-screen flex items-center justify-center">

  <div class="w-full max-w-2xl bg-white shadow-xl rounded-2xl p-8">
    <h2 class="text-3xl font-semibold text-center text-pink-600 mb-6">Customer Detail</h2>

    <form action="customers" method="post" class="space-y-5">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" value="${user.id}"/>

      <!-- Full Name -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Full Name</label>
        <input type="text" name="fullName" value="${user.fullName}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2 focus:outline-none focus:ring-2 focus:ring-pink-400"
               required>
      </div>

      <!-- Email -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Email</label>
        <input type="email" name="email" value="${user.email}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2 focus:outline-none focus:ring-2 focus:ring-pink-400"
               required>
      </div>

      <!-- Phone -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Phone</label>
        <input type="text" name="phone" value="${user.phone}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2 focus:outline-none focus:ring-2 focus:ring-pink-400"
               pattern="[0-9+ ]*" placeholder="e.g. +84901234567">
      </div>

      <!-- Date of Birth -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Date of Birth</label>
        <input type="date" name="dob"
 value="<%= (user != null && user.getDob() != null) ? sdf.format(user.getDob()) : "" %>"               class="w-full border border-pink-200 rounded-xl px-4 py-2 focus:outline-none focus:ring-2 focus:ring-pink-400">
      </div>

      <!-- Status -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Status</label>
        <select name="status"
                class="w-full border border-pink-200 rounded-xl px-4 py-2 bg-white focus:outline-none focus:ring-2 focus:ring-pink-400">
          <option value="active" ${user.status == 'active' ? 'selected' : ''}>Active</option>
          <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Inactive</option>
        </select>
      </div>

      <!-- Buttons -->
      <div class="flex justify-between pt-6">
        <button type="submit"
                class="bg-pink-500 hover:bg-pink-600 text-white font-semibold px-6 py-2 rounded-xl shadow-md transition-all duration-200">
           Save
        </button>

        <a href="customers"
           class="bg-gray-400 hover:bg-gray-500 text-white font-semibold px-6 py-2 rounded-xl shadow-md transition-all duration-200 text-center">
           Back
        </a>
      </div>
    </form>
  </div>

</body>
</html>
