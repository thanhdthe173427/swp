<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    User customer = (User) request.getAttribute("user");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Thông Tin Khách Hàng</title>
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

    <% if (customer != null) { %>
    <div class="bg-white shadow-2xl rounded-2xl w-full max-w-2xl p-8 border border-pink-100">
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-pink-700 mb-2">👩‍💼 Chỉnh Sửa Thông Tin Khách Hàng</h1>
            <p class="text-gray-500 text-sm">Cập nhật thông tin cá nhân khách hàng trong hệ thống</p>
        </div>

        <form action="<%= request.getContextPath() %>/admin/customers" method="post" class="space-y-5">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= customer.getId() %>">

            <!-- Họ và Tên -->
            <div>
                <label class="block text-gray-700 font-semibold mb-1">Họ và Tên</label>
                <input type="text" name="full_name" value="<%= customer.getFullName() %>"
                       class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:ring-2 focus:ring-pink-400 shadow-sm"
                       required>
            </div>

            <!-- Email -->
            <div>
                <label class="block text-gray-700 font-semibold mb-1">Email</label>
                <input type="email" name="email" value="<%= customer.getEmail() %>"
                       class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:ring-2 focus:ring-pink-400 shadow-sm"
                       required>
            </div>

            <!-- Số điện thoại -->
            <div>
                <label class="block text-gray-700 font-semibold mb-1">Số điện thoại</label>
                <input type="text" name="phone" value="<%= customer.getPhone() %>"
                       class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:ring-2 focus:ring-pink-400 shadow-sm"
                       placeholder="+84901234567" pattern="[0-9+ ]*" required>
            </div>

            <!-- Ngày sinh -->
            <div>
                <label class="block text-gray-700 font-semibold mb-1">Ngày sinh</label>
                <input type="date" name="dob"
                       value="<%= customer.getDob() != null ? sdf.format(customer.getDob()) : "" %>"
                       class="w-full border border-pink-200 rounded-xl px-4 py-2.5 focus:ring-2 focus:ring-pink-400 shadow-sm">
            </div>

            <!-- Trạng thái -->
            <div>
                <label class="block text-gray-700 font-semibold mb-1">Trạng thái</label>
                <select name="status"
                        class="w-full border border-pink-200 rounded-xl px-4 py-2.5 bg-white focus:ring-2 focus:ring-pink-400 shadow-sm">
                    <option value="Active" <%= "Active".equals(customer.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                    <option value="Inactive" <%= "Inactive".equals(customer.getStatus()) ? "selected" : "" %>>Ngừng hoạt động</option>
                </select>
            </div>

            <!-- Nút hành động -->
            <div class="flex justify-between pt-8">
                <a href="<%= request.getContextPath() %>/admin/customers?action=list"
                   class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-xl shadow-md transition flex items-center gap-2">
                   <i class="fas fa-arrow-left"></i> Quay lại
                </a>

                <button type="submit"
                        class="bg-gradient-to-r from-pink-400 to-purple-500 hover:from-pink-500 hover:to-purple-600 text-white font-semibold px-6 py-2 rounded-xl shadow-md transition flex items-center gap-2">
                    <i class="fas fa-save"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
    <% } else { %>
        <div class="bg-white rounded-2xl shadow-2xl p-8 text-center">
            <h2 class="text-2xl font-bold text-pink-700 mb-3">❌ Không tìm thấy khách hàng</h2>
            <p class="text-gray-500 mb-6">Có thể khách hàng này đã bị xóa hoặc không tồn tại trong hệ thống.</p>
            <a href="<%= request.getContextPath() %>/admin/customers?action=list"
               class="bg-pink-400 hover:bg-pink-500 text-white font-semibold px-6 py-2 rounded-xl shadow-md transition">
               Quay lại danh sách
            </a>
        </div>
    <% } %>

</body>
</html>
