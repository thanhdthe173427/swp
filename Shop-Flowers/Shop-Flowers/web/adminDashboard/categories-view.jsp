<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }

        /* 🔹 Sidebar nền hồng phấn, chữ hồng đậm */
        .sidebar-gradient {
            background: linear-gradient(180deg, #F8D7DA 0%, #F5C2C7 100%);
            color: #C9184A;
        }

        .sidebar-gradient a {
            color: #C9184A;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .sidebar-gradient a:hover {
            background-color: #F5C2C7;
            color: #A4133C;
        }

        .sidebar-gradient a.active {
            background-color: #F1AEB5;
            border-left: 4px solid #A4133C;
            font-weight: 600;
        }

        /* 🔹 Nút hồng phấn */
        .btn-pink {
            background-color: #F8D7DA;
            color: #000;
            transition: background-color 0.2s ease;
        }

        .btn-pink:hover {
            background-color: #F5C2C7;
        }

        /* 🔹 Header bảng */
        thead.pink-header {
            background: linear-gradient(to right, #F8D7DA, #F5C2C7);
            color: #000;
        }

        .table-row:hover {
            background-color: #f9fafb;
        }
    </style>
</head>

<body class="bg-gray-50">
<div class="flex min-h-screen">
    <!-- 🔹 Sidebar -->
    <aside class="w-64 sidebar-gradient flex-shrink-0">
        <div class="p-6">
            <h1 class="text-2xl font-bold flex items-center gap-2">
                <i class="fas fa-store"></i>
                Admin Panel
            </h1>
        </div>

        <nav class="mt-6">
            <a href="admin-product" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7] transition">
                <i class="fas fa-box"></i>
                <span>Quản Lý Hàng Hóa</span>
            </a>
            <a href="admin-categories" class="active flex items-center gap-3 px-6 py-3">
                <i class="fas fa-chart-line"></i>
                <span>Quản Lý Danh Mục</span>
            </a>
            <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7] transition">
                <i class="fas fa-cog"></i>
                <span>Cài Đặt</span>
            </a>
            <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7] transition">
                <i class="fas fa-user"></i>
                <span>Tài Khoản</span>
            </a>
        </nav>
    </aside>

    <!-- 🔹 Main content -->
    <main class="flex-1 overflow-auto">
        <header class="bg-white shadow-sm border-b border-gray-200">
            <div class="px-8 py-4 flex items-center justify-between">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Quản Lý Danh Mục</h2>
                    <p class="text-gray-600 text-sm mt-1">Quản lý và theo dõi danh mục của bạn</p>
                </div>
                <div class="flex items-center gap-4">
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-bell text-gray-600"></i>
                    </button>
                    <div class="flex items-center gap-2">
                        <img src="/placeholder.svg?height=40&width=40" alt="Avatar" class="w-10 h-10 rounded-full">
                        <span class="text-sm font-medium text-gray-700">Admin User</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="p-8">
            <!-- 🔹 Nút thêm danh mục -->
            <button onclick="openModal()" 
                    class="btn-pink px-6 py-2 rounded-lg font-medium flex items-center gap-2">
                <i class="fas fa-plus"></i> Thêm danh mục
            </button>

            <!-- 🔹 Form tìm kiếm -->
            <form action="admin-categories" method="get" class="mt-6">
                <div class="bg-white rounded-xl shadow-md p-4 mb-6">
                    <div class="relative">
                        <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm kiếm danh mục theo mô tả hoặc tên..." 
                               class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 focus:border-transparent outline-none">
                    </div>
                </div>
            </form>

            <!-- 🔹 Bảng danh mục -->
            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="pink-header">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Mã Danh Mục</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Tên Danh Mục</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Mô tả</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Slug</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Tạo lúc</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Cập nhật lúc</th>
                            <th class="px-6 py-4 text-center text-sm font-semibold">Thao Tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" items="${categories}">
                            <tr class="table-row border-b border-gray-200">
                                <td class="px-6 py-4 text-sm font-medium text-gray-900">${p.getId()}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${p.getName()}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${p.getDescription()}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${p.getSlug()}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${p.getCreatedAt()}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${p.getUpdatedAt()}</td>
                                <td class="px-6 py-4 text-sm text-center">
                                    <a href="#" class="text-green-600 hover:text-green-800 mr-3 transition"
                                       data-id="${p.getId()}"
                                       data-name="${p.getName()}"
                                       data-description="${p.getDescription()}"
                                       onclick="handleUpdateClick(this)">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <form action="admin-categories" method="post">
                                        <input type="hidden" name="deleteId" value="${p.getId()}">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit" class="text-red-600 hover:text-red-800 transition"
                                                onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- 🔹 Modal thêm danh mục -->
<div id="addProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm danh mục mới</h3>

        <form action="admin-categories" method="post" class="grid grid-cols-1 gap-4">
            <input type="text" name="name" placeholder="Tên danh mục" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 outline-none">
            <input type="text" name="description" placeholder="Mô tả" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeModal()" 
                        class="px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-100">Hủy</button>
                <button type="submit" 
                        class="px-6 py-2 rounded-lg bg-[#F8D7DA] text-black hover:bg-[#F5C2C7]">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- 🔹 Modal cập nhật danh mục -->
<div id="updateProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật danh mục</h3>

        <form id="updateProductForm" action="admin-categories" method="post" class="grid grid-cols-1 gap-4">
            <input type="hidden" name="productId" id="updateProductId">
            <input type="hidden" name="action" value="update">

            <input type="text" name="name" id="updateName" placeholder="Tên danh mục" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 outline-none">
            <input type="text" name="description" id="updateDescription" placeholder="Mô tả" required
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-100">Hủy</button>
                <button type="submit" onclick="closeUpdateModal()"
                        class="px-6 py-2 rounded-lg bg-[#F8D7DA] text-black hover:bg-[#F5C2C7]">Cập nhật</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>









<script>
    // Mở popup thêm
    function openModal() {
        document.getElementById("addProductModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("addProductModal").classList.add("hidden");
    }

    // Mở popup update
    function handleUpdateClick(el) {
        // Lấy data từ thẻ <a>
        var id = el.getAttribute("data-id");
        var name = el.getAttribute("data-name");
        var description = el.getAttribute("data-description");

        // Gán giá trị vào form update
        document.getElementById("updateProductId").value = id;
        document.getElementById("updateName").value = name;
        document.getElementById("updateDescription").value = description;

        // Hiện popup
        document.getElementById("updateProductModal").classList.remove("hidden");
    }

    function closeUpdateModal() {
        document.getElementById("updateProductModal").classList.add("hidden");
    }

    // Tự đóng popup khi submit
    document.getElementById("updateProductForm").addEventListener("submit", function () {
        closeUpdateModal();
    });
</script>



</body>
</html>