<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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

            .sidebar-gradient {
                background: linear-gradient(180deg, #F8D7DA 0%, #F1A7A7 100%);
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

            .badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 4px 12px;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 600;
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
           <aside class="w-64 flex-shrink-0 bg-[#F8D7DA] text-gray-800">
        <div class="p-6">
            <h1 class="text-2xl font-bold flex items-center gap-2">
                <i class="fas fa-store"></i>
                Admin Panel
            </h1>
        </div>
        <nav class="mt-6">
            <a href="admin-product" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-box"></i>
                <span>Quản Lý Hàng Hóa</span>
            </a>
            <a href="admin-categories" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-chart-line"></i>
                <span>Quản lý Danh Mục</span>
            </a>
            <a href="admin-batches" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-boxes"></i>
                <span>Quản Lý Lô Hàng</span>
            </a>
            <a href="warehouse" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fa-solid fa-house"></i>
                <span>Kho Hàng</span>
            </a>
            <a href="admin-formulas" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                <i class="fas fa-flask"></i> 
                <span>Quản Lý Công Thức</span> 
            </a>
            <a href="admin-materials" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-flask"></i> 
                <span>Quản Lý Nguyên Liệu</span> 
            </a>
            <a href="admin-orders" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-shopping-cart"></i> 
                <span>Quản Lý Đơn Hàng</span> 
            </a>
        </nav>
    </aside>

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
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

                    </div>

                    <button onclick="openModal()" 
                            class="bg-[#F8D7DA] text-gray-800 px-6 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition font-medium flex items-center gap-2 shadow-sm">
                        <i class="fas fa-plus"></i> Thêm danh mục
                    </button>


                    </form>
                </div>

                <form action="admin-categories" method="get">
                    <div class="bg-white rounded-xl shadow-md p-4 mb-6">
                        <div class="relative">
                            <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm kiếm danh mục theo mô ta hoặc tên..." 
                                   class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent outline-none">

                        </div>
                    </div>
                </form>

                <div class="bg-white rounded-xl shadow-md overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-[#F8D7DA] text-gray-800">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Mã Danh Mục</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Tên Danh Mục</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Mô tả</th>
                                    <th class="px-6 py-4 text-center text-sm font-semibold">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${categories}">
                                    <tr class="table-row border-b border-gray-200">
                                        <td class="px-6 py-4 text-sm font-medium text-gray-900">${p.getId()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getName()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getDescription()}</td>
                                        <td class="px-6 py-4 text-sm text-center">
                                            <div style="display: flex;">
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
                                            </div>     
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
<div id="addProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <!-- Nút đóng -->
        <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm sản danh mục mới</h3>

        <form action="admin-categories" method="post" class="grid grid-cols-1 gap-4">

            <input type="text" name="name" placeholder="Tên sản phẩm" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <!--      <input type="text" name="material" placeholder="Nguyên liệu" required 
                         class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">-->
            <input type="text" name="description" placeholder="mô tả" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeModal()" 
                        class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Form Update Product Modal -->
<div id="updateProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <!-- Nút đóng -->
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật danh mục</h3>

        <form id="updateProductForm" action="admin-categories" method="post" class="grid grid-cols-1 gap-4">
            <input type="hidden" name="productId" id="updateProductId">
            <input type="hidden" name="action" value="update">

            <input type="text" name="name" id="updateName" placeholder="Tên sản phẩm" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="text" name="description" id="updateDescription" placeholder="Mô tả" required
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Hủy</button>
                <button type="submit" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Cập nhật</button>
            </div>
        </form>
    </div>
</div>








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