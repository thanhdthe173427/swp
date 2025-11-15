<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    // ✅ Lấy đường dẫn hiện tại để tự động highlight menu đang mở
    String currentPath = request.getRequestURI();
%>

<aside class="w-64 flex-shrink-0 bg-gradient-to-b from-[#F8D7DA] to-[#F1A7A7] text-gray-800 shadow-xl min-h-screen">
    <!-- Header -->
    <div class="p-6 border-b border-pink-200">
        <a href="${pageContext.request.contextPath}/admin-product"
           class="text-2xl font-bold flex items-center gap-3 text-[#8b0057] hover:text-pink-900 transition">
            <i class="fas fa-store"></i>
            <span>Admin Panel</span>
        </a>
    </div>

    <!-- Navigation -->
    <nav class="mt-4 font-medium text-sm space-y-1">
        <a href="${pageContext.request.contextPath}/admin-product"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-product") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-box"></i>
            <span>Quản Lý Hàng Hóa</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin-categories"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-categories") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-chart-line"></i>
            <span>Quản Lý Danh Mục</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin-batches"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-batches") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-boxes"></i>
            <span>Quản Lý Lô Hàng</span>
        </a>

        <a href="${pageContext.request.contextPath}/warehouse"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("warehouse") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fa-solid fa-warehouse"></i>
            <span>Kho Hàng</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin-formulas"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-formulas") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-flask"></i>
            <span>Quản Lý Công Thức</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin-materials"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-materials") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-vial"></i>
            <span>Quản Lý Nguyên Liệu</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin-orders"
           class="flex items-center gap-3 px-6 py-3 rounded-r-full transition
                  <%= currentPath.contains("admin-orders") ? "bg-white text-pink-700 font-semibold shadow-inner border-l-4 border-pink-600" : "hover:bg-white/40 text-gray-800" %>">
            <i class="fas fa-shopping-cart"></i>
            <span>Quản Lý Đơn Hàng</span>
        </a>

        <hr class="my-2 border-pink-200"/>

        <!-- ✅ Về Trang Chủ -->
        <a href="http://localhost:8080/mavenproject1/Homepage"
           class="flex items-center gap-3 px-6 py-3 text-pink-800 hover:text-pink-900 hover:bg-white/40 rounded-r-full transition font-semibold">
            <i class="fas fa-home"></i>
            <span>Về Trang Chủ</span>
        </a>
    </nav>
</aside>
