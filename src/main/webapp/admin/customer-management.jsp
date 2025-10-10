<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="dao.CustomerDAO" %>

<%
    // Lấy parameters
    String search = request.getParameter("search");
    String status = request.getParameter("status");
    String pageParam = request.getParameter("page");
    
    if (search == null) search = "";
    if (status == null || status.isEmpty()) status = "all";
    
    // Lấy dữ liệu từ database
    CustomerDAO customerDAO = new CustomerDAO();
    List<User> allCustomers = customerDAO.getAllCustomers();
    
    // Lọc theo search và status
    List<User> filteredCustomers = new java.util.ArrayList<>();
    for (User user : allCustomers) {
        boolean matchSearch = search.isEmpty() || 
                             user.getFullName().toLowerCase().contains(search.toLowerCase());
        boolean matchStatus = status.equals("all") || 
                             user.getStatus().equalsIgnoreCase(status);
        
        if (matchSearch && matchStatus) {
            filteredCustomers.add(user);
        }
    }
    
    // Phân trang
    int currentPage = 1;
    int pageSize = 10;
    
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int totalRecords = filteredCustomers.size();
    int totalPages = (totalRecords == 0) ? 1 : (int) Math.ceil((double) totalRecords / pageSize);
    if (currentPage > totalPages) currentPage = totalPages;
    
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalRecords);
    
    List<User> customers = (totalRecords > 0) ? filteredCustomers.subList(startIndex, endIndex) : new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .sidebar-gradient {
            background: linear-gradient(180deg, #F8D7DA 0%, #F5C2C7 100%);
            color: #C9184A;
        }
        .sidebar-gradient a { color: #C9184A; transition: 0.2s; }
        .sidebar-gradient a:hover { background-color: #F5C2C7; color: #A4133C; }
        .sidebar-gradient a.active {
            background-color: #F1AEB5;
            border-left: 4px solid #A4133C;
            font-weight: 600;
        }
        thead.pink-header {
            background: linear-gradient(to right, #F8D7DA, #F5C2C7);
        }
    </style>
</head>

<body class="bg-gray-50">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="w-64 sidebar-gradient flex-shrink-0">
        <div class="p-6">
            <h1 class="text-2xl font-bold flex items-center gap-2">
                <i class="fas fa-store"></i> Admin Panel
            </h1>
        </div>
        <nav class="mt-6">
            <a href="<%= request.getContextPath() %>/admin/products" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7]">
                <i class="fas fa-box"></i> <span>Quản Lý Hàng Hóa</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/categories" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7]">
                <i class="fas fa-chart-line"></i> <span>Quản Lý Danh Mục</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/customers" class="active flex items-center gap-3 px-6 py-3">
                <i class="fas fa-users"></i> <span>Quản Lý Khách Hàng</span>
            </a>
            <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7]">
                <i class="fas fa-cog"></i> <span>Cài Đặt</span>
            </a>
        </nav>
    </aside>

    <!-- Main -->
    <main class="flex-1 overflow-auto">
        <header class="bg-white shadow-sm border-b border-gray-200">
            <div class="px-8 py-4 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Quản Lý Khách Hàng</h2>
                    <p class="text-gray-600 text-sm">Xem và quản lý danh sách tài khoản khách hàng</p>
                </div>
                <div class="flex items-center gap-3">
                    <img src="https://via.placeholder.com/40" alt="Avatar" class="w-10 h-10 rounded-full">
                    <span class="font-medium text-gray-700">Admin</span>
                </div>
            </div>
        </header>

        <div class="p-8">
            <h6 class="text-2xl font-semibold mb-6 text-center">CUSTOMER ACCOUNT MANAGEMENT</h6>

            <!-- Filter + Search -->
            <div class="bg-white p-4 rounded-xl shadow-md mb-6">
                <form action="<%= request.getContextPath() %>/admin/customers" method="GET" class="flex justify-between items-center gap-4">
                    <div class="flex items-center gap-2">
                        <label class="font-medium">Lọc:</label>
                        <select name="status" class="border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-pink-300">
                            <option value="all" <%= "all".equals(status) ? "selected" : "" %>>Tất cả khách hàng</option>
                            <option value="active" <%= "active".equals(status) ? "selected" : "" %>>Đang hoạt động</option>
                            <option value="inactive" <%= "inactive".equals(status) ? "selected" : "" %>>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="flex items-center gap-2">
                        <input type="text" name="search" value="<%= search %>"
                               class="border border-gray-300 rounded-lg px-4 py-2 w-64 focus:ring-2 focus:ring-pink-300"
                               placeholder="Tìm theo tên khách hàng...">
                        <button type="submit"
                                class="px-4 py-2 bg-[#F8D7DA] hover:bg-[#F5C2C7] rounded-lg font-medium transition">
                            <i class="fa fa-search mr-1"></i>Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                <table class="w-full text-sm">
                    <thead class="pink-header">
                    <tr>
                        <th class="px-6 py-4 text-center font-semibold">#</th>
                        <th class="px-6 py-4 text-left font-semibold">Họ và Tên</th>
                        <th class="px-6 py-4 text-left font-semibold">Email</th>
                        <th class="px-6 py-4 text-center font-semibold">Trạng Thái</th>
                        <th class="px-6 py-4 text-center font-semibold">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (customers != null && !customers.isEmpty()) {
                            int index = (currentPage - 1) * 10 + 1;
                            for (User c : customers) {
                    %>
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="px-6 py-3 text-center"><%= index++ %></td>
                        <td class="px-6 py-3"><%= c.getFullName() %></td>
                        <td class="px-6 py-3"><%= c.getEmail() %></td>
                        <td class="px-6 py-3 text-center">
                            <% if ("active".equalsIgnoreCase(c.getStatus())) { %>
                                <span class="text-green-600 font-semibold">Hoạt động</span>
                            <% } else { %>
                                <span class="text-red-600 font-semibold">Ngừng</span>
                            <% } %>
                        </td>
                        <td class="px-6 py-3 text-center">
                            <a href="<%= request.getContextPath() %>/admin/customers?action=detail&id=<%= c.getId() %>"
                               class="text-blue-600 hover:text-blue-800">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="px-6 py-6 text-center text-gray-500">
                            Không tìm thấy khách hàng nào phù hợp.
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <!-- Pagination -->
<nav class="mt-6 flex justify-center w-full">
    <ul class="flex gap-1">
        <% if (currentPage > 1) { %>
            <li>
                <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= currentPage - 1 %>"
                   class="px-3 py-2 bg-[#F8D7DA] hover:bg-[#F5C2C7] rounded transition">&laquo; Trước</a>
            </li>
        <% } %>

        <%
            int start = Math.max(1, currentPage - 2);
            int end = Math.min(totalPages, start + 4);
            for (int i = start; i <= end; i++) {
        %>
            <li>
                <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= i %>"
                   class="px-3 py-2 border rounded transition
                   <%= (i == currentPage) ? "bg-[#F1AEB5] font-semibold" : "bg-white hover:bg-gray-100" %>">
                    <%= i %>
                </a>
            </li>
        <% } %>

        <% if (currentPage < totalPages) { %>
            <li>
                <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= currentPage + 1 %>"
                   class="px-3 py-2 bg-[#F8D7DA] hover:bg-[#F5C2C7] rounded transition">Sau &raquo;</a>
            </li>
        <% } %>
    </ul>
</nav>

        </div>
    </main>
</div>
</body>
</html>