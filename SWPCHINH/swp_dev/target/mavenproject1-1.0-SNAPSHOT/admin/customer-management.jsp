<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="dao.CustomerDAO" %>

<%
    String search = request.getParameter("search");
    String status = request.getParameter("status");
    String pageParam = request.getParameter("page");
    if (search == null) search = "";
    if (status == null || status.isEmpty()) status = "all";

    CustomerDAO customerDAO = new CustomerDAO();
    List<User> allCustomers = customerDAO.getAllCustomers();

    List<User> filteredCustomers = new java.util.ArrayList<>();
    for (User user : allCustomers) {
        boolean matchSearch = search.isEmpty() || user.getFullName().toLowerCase().contains(search.toLowerCase());
        boolean matchStatus = status.equals("all") || user.getStatus().equalsIgnoreCase(status);
        if (matchSearch && matchStatus) filteredCustomers.add(user);
    }

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
        * { transition: all 0.25s ease-in-out; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background-color: #f3a7b8; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background-color: #e17c8e; }
    </style>
</head>

<body class="bg-gradient-to-r from-pink-50 via-white to-pink-100 text-gray-700">

<div class="flex min-h-screen">
    <!-- Sidebar -->
    <%@ include file="/Trang/sidebarAdmin.jsp" %>

    <!-- Main -->
    <main class="flex-1 overflow-auto">
        <%@ include file="/Trang/headerAdmin.jsp" %>

        <section class="p-8">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="text-3xl font-bold text-pink-700">👥 Quản Lý Khách Hàng</h2>
                    <p class="text-gray-500 text-sm mt-1">Theo dõi, tìm kiếm và quản lý tài khoản khách hàng</p>
                </div>
            </div>

            <!-- Bộ lọc -->
            <div class="bg-white rounded-2xl shadow-md p-5 mb-8 border border-pink-100">
                <form action="<%= request.getContextPath() %>/admin/customers" method="GET"
                      class="flex flex-wrap justify-between gap-4 items-center">
                    <div class="flex items-center gap-2">
                        <label class="font-medium text-gray-700">Trạng thái:</label>
                        <select name="status"
                                class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300 bg-white">
                            <option value="all" <%= "all".equals(status) ? "selected" : "" %>>Tất cả</option>
                            <option value="active" <%= "active".equals(status) ? "selected" : "" %>>Hoạt động</option>
                            <option value="inactive" <%= "inactive".equals(status) ? "selected" : "" %>>Ngừng</option>
                        </select>
                    </div>

                    <div class="flex items-center gap-2">
                        <input type="text" name="search" value="<%= search %>"
                               placeholder="Tìm theo tên khách hàng..."
                               class="border border-pink-200 rounded-lg px-4 py-2 w-72 focus:ring-2 focus:ring-pink-300">
                        <button type="submit"
                                class="bg-pink-200 hover:bg-pink-300 text-gray-800 px-4 py-2 rounded-lg flex items-center gap-2 shadow-sm font-medium">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </div>
                </form>
            </div>

            <!-- Bảng -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-center font-semibold">#</th>
                            <th class="px-6 py-3 text-left font-semibold">Họ và Tên</th>
                            <th class="px-6 py-3 text-left font-semibold">Email</th>
                            <th class="px-6 py-3 text-center font-semibold">Trạng Thái</th>
                            <th class="px-6 py-3 text-center font-semibold">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                    <%
                        if (!customers.isEmpty()) {
                            int index = (currentPage - 1) * pageSize + 1;
                            for (User c : customers) {
                    %>
                        <tr class="hover:bg-pink-50">
                            <td class="px-6 py-3 text-center text-gray-600"><%= index++ %></td>
                            <td class="px-6 py-3 font-medium text-gray-800"><%= c.getFullName() %></td>
                            <td class="px-6 py-3 text-gray-700"><%= c.getEmail() %></td>
                            <td class="px-6 py-3 text-center">
                                <% if ("active".equalsIgnoreCase(c.getStatus())) { %>
                                    <span class="px-3 py-1 text-green-700 bg-green-100 rounded-full text-xs font-semibold">Hoạt động</span>
                                <% } else { %>
                                    <span class="px-3 py-1 text-red-700 bg-red-100 rounded-full text-xs font-semibold">Ngừng</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-3 text-center">
                                <a href="<%= request.getContextPath() %>/admin/customers?action=detail&id=<%= c.getId() %>"
                                   class="text-blue-600 hover:text-blue-800 transition text-lg">
                                   <i class="fas fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5" class="py-6 text-center text-gray-500 italic">
                                Không tìm thấy khách hàng nào phù hợp.
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang -->
            <div class="flex justify-center mt-8">
                <ul class="flex gap-2">
                    <% if (currentPage > 1) { %>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= currentPage - 1 %>"
                               class="px-3 py-2 bg-pink-200 hover:bg-pink-300 rounded-lg">« Trước</a>
                        </li>
                    <% } %>

                    <%
                        int start = Math.max(1, currentPage - 2);
                        int end = Math.min(totalPages, start + 4);
                        for (int i = start; i <= end; i++) {
                    %>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= i %>"
                               class="px-3 py-2 rounded-lg transition
                               <%= (i == currentPage) ? "bg-pink-400 text-white font-semibold" : "bg-white border hover:bg-pink-100" %>">
                                <%= i %>
                            </a>
                        </li>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                        <li>
                            <a href="<%= request.getContextPath() %>/admin/customers?search=<%= search %>&status=<%= status %>&page=<%= currentPage + 1 %>"
                               class="px-3 py-2 bg-pink-200 hover:bg-pink-300 rounded-lg">Sau »</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </section>
    </main>
</div>

</body>
</html>
