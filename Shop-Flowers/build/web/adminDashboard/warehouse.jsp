<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Kho Hàng - Admin Dashboard</title>
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

            .badge-danger {
                background-color: #fee2e2;
                color: #991b1b;
            }
        </style>
    </head>
    <body class="bg-gray-50">
        <div class="flex min-h-screen">
            <!-- Sidebar -->
            <aside class="w-64 flex-shrink-0 sidebar-gradient text-gray-800">
                <div class="p-6">
                    <h1 class="text-2xl font-bold flex items-center gap-2">
                        <i class="fas fa-warehouse"></i>
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
                    <a href="warehouse" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-60 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                        <i class="fa-solid fa-house"></i>
                        <span>Kho Hàng</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                        <i class="fas fa-cog"></i>
                        <span>Cài Đặt</span>
                    </a>
                </nav>
            </aside>

            <!-- Main -->
            <main class="flex-1 overflow-auto">
                <header class="bg-white shadow-sm border-b border-gray-200">
                    <div class="px-8 py-4 flex items-center justify-between">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-800">Quản Lý Kho Hàng</h2>
                            <p class="text-gray-600 text-sm mt-1">Quản lý và theo dõi danh sách kho hàng</p>
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

                <!-- Main Content -->
                <div class="p-8">
                    <button onclick="openModal()" 
                            class="bg-[#F8D7DA] text-gray-800 px-6 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition font-medium flex items-center gap-2 shadow-sm">
                        <i class="fas fa-plus"></i> Thêm kho hàng
                    </button>
                </div>

                <div class="bg-white rounded-xl shadow-md overflow-hidden mx-8 mb-8">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-[#F8D7DA] text-gray-800">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">ID</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Mã kho</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Tên kho</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Địa chỉ</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-center">Trạng thái</th>
                                    <th class="px-6 py-4 text-center text-sm font-semibold">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="w" items="${warehouses}">
                                    <tr class="table-row border-b border-gray-200">
                                        <td class="px-6 py-4 text-sm font-medium text-gray-900">${w.id}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${w.code}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${w.name}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${w.address}</td>
                                        <td class="px-6 py-4 text-sm text-center">
                                            <span class="badge ${w.isActive ? 'badge-success' : 'badge-danger'}">
                                                ${w.isActive ? 'Hoạt động' : 'Ngừng'}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 text-center">
                                            <div class="flex justify-center gap-3">
                                                <a href="#" class="text-green-600 hover:text-green-800"
                                                   onclick='openUpdateModal({
                                                               id: "${w.id}",
                                                               code: "${w.code}",
                                                               name: "${w.name}",
                                                               address: "${w.address}",
                                                               isActive: ${w.isActive}
                                                           })'>
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="warehouse" method="post" onsubmit="return confirm('Xóa kho này?')">
                                                    <input type="hidden" name="id" value="${w.id}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <button type="submit" class="text-red-600 hover:text-red-800">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>


                                                <!-- Nút Xem chi tiết -->
                                                
                                                <form action="inventory" method="get"">
                                                    <input type="hidden" name="warehouseId" value="${w.id}">
                                                    <button type="submit" class="text-blue-600 hover:text-blue-800">
                                                        <i class="fas fa-eye"></i>
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
            </main>
        </div>

        <!-- Modal Thêm -->
        <div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
                <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
                <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm kho hàng</h3>

                <form action="warehouse" method="post" class="grid grid-cols-1 gap-4">
                    <input type="hidden" name="action" value="create">

                    <input type="text" name="code" placeholder="Mã kho" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    <input type="text" name="name" placeholder="Tên kho" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    <input type="text" name="address" placeholder="Địa chỉ" 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                    <label class="flex items-center gap-2">
                        <input type="checkbox" name="isActive" class="w-4 h-4">
                        <span>Đang hoạt động</span>
                    </label>

                    <div class="flex justify-end gap-2 mt-4">
                        <button type="button" onclick="closeModal()" 
                                class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f29c9c] transition">Hủy</button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Cập nhật -->
        <div id="updateModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
                <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
                <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật kho hàng</h3>

                <form action="warehouse" method="post" class="grid grid-cols-1 gap-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="updateId">

                    <input type="text" name="code" id="updateCode" placeholder="Mã kho" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    <input type="text" name="name" id="updateName" placeholder="Tên kho" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    <input type="text" name="address" id="updateAddress" placeholder="Địa chỉ" 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                    <label class="flex items-center gap-2">
                        <input type="checkbox" name="isActive" id="updateIsActive" class="w-4 h-4">
                        <span>Đang hoạt động</span>
                    </label>

                    <div class="flex justify-end gap-2 mt-4">
                        <button type="button" onclick="closeUpdateModal()" 
                                class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f29c9c] transition">Hủy</button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById("addModal").classList.remove("hidden");
            }
            function closeModal() {
                document.getElementById("addModal").classList.add("hidden");
            }

            function openUpdateModal(w) {
                document.getElementById("updateId").value = w.id;
                document.getElementById("updateCode").value = w.code;
                document.getElementById("updateName").value = w.name;
                document.getElementById("updateAddress").value = w.address;
                document.getElementById("updateIsActive").checked = w.isActive === true || w.isActive === "true";
                document.getElementById("updateModal").classList.remove("hidden");
            }

            function closeUpdateModal() {
                document.getElementById("updateModal").classList.add("hidden");
            }
        </script>
    </body>
</html>
