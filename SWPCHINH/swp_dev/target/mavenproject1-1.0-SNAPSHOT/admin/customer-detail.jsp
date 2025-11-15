<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) request.getAttribute("user");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi Tiết Khách Hàng</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <style>
    * { transition: all 0.25s ease-in-out; }
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-thumb { background-color: #f3a7b8; border-radius: 10px; }
    ::-webkit-scrollbar-thumb:hover { background-color: #e17c8e; }
  </style>
</head>

<body class="bg-gradient-to-br from-pink-50 via-white to-pink-100 min-h-screen flex items-center justify-center">

  <div class="w-full max-w-2xl bg-white/90 backdrop-blur-md shadow-2xl rounded-2xl p-8 border border-pink-100">
    <div class="text-center mb-8">
      <h2 class="text-3xl font-bold text-pink-700 mb-2">👩‍💼 Chi Tiết Khách Hàng</h2>
      <p class="text-gray-500 text-sm">Xem và chỉnh sửa thông tin cá nhân khách hàng</p>
    </div>

    <form action="customers" method="post" class="space-y-5">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" value="${user.id}"/>

      <!-- Họ tên -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Họ và Tên</label>
        <input type="text" name="fullName" value="${user.fullName}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-pink-400 bg-white shadow-sm"
               required>
      </div>

      <!-- Email -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Email</label>
        <input type="email" name="email" value="${user.email}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-pink-400 bg-white shadow-sm"
               required>
      </div>

      <!-- Số điện thoại -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Số điện thoại</label>
        <input type="text" name="phone" value="${user.phone}"
               class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-pink-400 bg-white shadow-sm"
               pattern="[0-9+ ]*" placeholder="VD: +84901234567">
      </div>

      <!-- Ngày sinh -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Ngày sinh</label>
        <input type="date" name="dob"
               value="<%= (user != null && user.getDob() != null) ? sdf.format(user.getDob()) : "" %>"
               class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-pink-400 bg-white shadow-sm">
      </div>

      <!-- Trạng thái -->
      <div>
        <label class="block text-gray-700 font-semibold mb-1">Trạng thái</label>
        <select name="status"
                class="w-full border border-pink-200 rounded-xl px-4 py-2.5 bg-white focus:outline-none focus:ring-2 focus:ring-pink-400 shadow-sm">
          <option value="active" ${user.status == 'active' ? 'selected' : ''}>Hoạt động</option>
          <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
        </select>
      </div>

      <!-- Nút thao tác -->
      <div class="flex justify-between pt-8">
        <a href="customers"
           class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-xl shadow-md transition-all duration-200 flex items-center gap-2">
           <i class="fas fa-arrow-left"></i> Quay lại
        </a>

        <button type="submit"
                class="bg-gradient-to-r from-pink-400 to-purple-500 hover:from-pink-500 hover:to-purple-600 text-white font-semibold px-6 py-2 rounded-xl shadow-md transition-all duration-200 flex items-center gap-2">
           <i class="fas fa-save"></i> Lưu thay đổi
        </button>
      </div>
    </form>
  </div>

</body>
</html>
