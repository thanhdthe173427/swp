<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Hàng Hóa - Admin Dashboard</title>
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

            /* 🔹 Sidebar hồng phấn + chữ hồng đậm */
            .sidebar-gradient {
                background-color: #F8D7DA;
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

            /* Nút thêm sản phẩm màu hồng phấn */
            .btn-pink {
                background-color: #F8D7DA;
                color: #000000;
                transition: background-color 0.2s ease;
            }

            .btn-pink:hover {
                background-color: #F5C2C7;
            }

            /* Header bảng hồng nhạt */
            thead.pink-header {
                background: linear-gradient(to right, #F8D7DA, #F5C2C7);
                color: #000000;
            }

            .stat-card {
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .stat-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            }

            .table-row:hover {
                background-color: #f9fafb;
            }

            .badge-success {
                background-color: #d1fae5;
                color: #065f46;
            }

            .badge-warning {
                background-color: #fef3c7;
                color: #92400e;
            }

            .badge-danger {
                background-color: #fee2e2;
                color: #991b1b;
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
                    <a href="admin-product" class="active flex items-center gap-3 px-6 py-3">
                        <i class="fas fa-box"></i>
                        <span>Quản Lý Hàng Hóa</span>
                    </a>
                    <a href="admin-categories" class="flex items-center gap-3 px-6 py-3 hover:bg-[#F5C2C7] transition">
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

            <!-- 🔹 Nội dung chính -->
            <main class="flex-1 overflow-auto">
                <header class="bg-white shadow-sm border-b border-gray-200">
                    <div class="px-8 py-4 flex items-center justify-between">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-800">Quản Lý Hàng Hóa</h2>
                            <p class="text-gray-600 text-sm mt-1">Quản lý và theo dõi kho hàng của bạn</p>
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
                    <!-- 🔹 Button thêm -->
                    <button onclick="openModal()" 
                            class="btn-pink px-6 py-2 rounded-lg font-medium flex items-center gap-2">
                        <i class="fas fa-plus"></i> Thêm sản phẩm
                    </button>

                    <!-- 🔹 Form tìm kiếm -->
                    <form action="admin-product" method="get" class="mt-6">
                        <div class="bg-white rounded-xl shadow-md p-4 mb-6">
                            <div class="relative">
                                <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                                <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm kiếm sản phẩm theo mô tả hoặc tên..." 
                                       class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-300 focus:border-transparent outline-none">
                            </div>
                        </div>
                    </form>

                    <!-- 🔹 Bảng sản phẩm -->
                    <div class="bg-white rounded-xl shadow-md overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="pink-header">
                                    <tr>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mã Hàng</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Tên Sản Phẩm</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mô tả</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Giá bán (VNĐ)</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Giá cost (VNĐ)</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Tạo lúc</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Cập nhật lúc</th>
                                        <th class="px-6 py-4 text-center text-sm font-semibold">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${products}">
                                        <tr class="table-row border-b border-gray-200">
                                            <td class="px-6 py-4 text-sm font-medium text-gray-900">${p.getId()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getName()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getDescription()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getBasePrice()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getCostPrice()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getCreatedAt()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${p.getUpdatedAt()}</td>
                                            <td class="px-6 py-4 text-sm text-center">
                                                <a href="#" class="text-green-600 hover:text-green-800 mr-3 transition"
                                                   onclick='openUpdateModal({
                                                               id: "${p.getId()}",
                                                               categoryId: "${p.getCategoryId()}",
                                                               name: "${p.getName()}",
                                                               description: "${p.getDescription()}",
                                                               basePrice: "${p.getBasePrice()}",
                                                               unit: "${p.getUnit()}",
                                                               costPrice: "${p.getCostPrice()}"
                                                           })'>
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <form action="admin-product" method="post">
                                                    <input type="hidden" name="deleteId" value="${p.getId()}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <button type="submit" class="text-red-600 hover:text-red-800 transition"
                                                            onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
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
    </body>
</html>






<script>
    function openModal() {
        document.getElementById("addProductModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("addProductModal").classList.add("hidden");
    }

    function openUpdateModal(product) {
        // Set giá trị hiện tại của sản phẩm vào form
        document.getElementById("updateProductId").value = product.id;
        document.getElementById("updateCategoryId").value = product.categoryId;
        document.getElementById("updateName").value = product.name;
        document.getElementById("updateDescription").value = product.description;
        document.getElementById("updateBasePrice").value = product.basePrice;
        document.getElementById("updateCostPrice").value = product.costPrice;
        document.getElementById("updateUnit").value = product.unit;
        // Hiện popup
        document.getElementById("updateProductModal").classList.remove("hidden");
    }

    function closeUpdateModal() {
        document.getElementById("updateProductModal").classList.add("hidden");
    }
</script>


</body>
</html>