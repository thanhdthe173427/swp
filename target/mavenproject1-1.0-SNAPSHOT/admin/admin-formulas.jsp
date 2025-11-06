<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Công Thức - Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
    <body class="bg-gray-50">
        <div class="flex min-h-screen">

            <!-- Sidebar -->
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

            <!-- Main content -->
            <main class="flex-1 overflow-auto p-8">
                <h2 class="text-2xl font-bold mb-4">Quản Lý Công Thức Sản Phẩm</h2>

                <!-- Nút thêm công thức -->
                <button onclick="openAddModal()" class="bg-[#F8D7DA] px-4 py-2 rounded-lg hover:bg-[#F1A7A7] mb-4">
                    <i class="fas fa-plus"></i> Gán công thức mới
                </button>

                <!-- Form tìm kiếm -->
                <form action="admin-formulas" method="get" class="mb-4 flex gap-2">
                    <input type="text" name="search" value="${search}" placeholder="Tìm theo tên sản phẩm..."
                           class="px-4 py-2 border rounded-lg w-64">
                    <button type="submit" class="bg-[#F8D7DA] px-4 py-2 rounded-lg hover:bg-[#F1A7A7]">Tìm</button>
                </form>

                <!-- Bảng danh sách công thức -->
                <div class="bg-white rounded-xl shadow-md overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-[#F8D7DA]">
                            <tr>
                                <th class="px-6 py-4 text-left">ID Sản Phẩm</th>
                                <th class="px-6 py-4 text-left">Tên Sản Phẩm</th>
                                <th class="px-6 py-4 text-left">Nguyên Liệu</th>
                                <th class="px-6 py-4 text-center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${formulas}">
                                <tr class="border-b">
                                    <td class="px-6 py-4">${f.productId}</td>
                                    <td class="px-6 py-4">${f.productName}</td>
                                    <td class="px-6 py-4">
                                        <ul class="list-disc ml-4">
                                            <c:forEach var="m" items="${f.materials}">
                                                <li>
                                                    ${m.name} - Số lượng: ${m.quantity}
                                                </li>
                                            </c:forEach>
                                        </ul>

                                    </td>
                                    <td class="px-6 py-4 text-center flex justify-center gap-3">
                                        <a href="admin-formulas?action=edit&productId=${f.productId}" 
                                           class="text-green-600 hover:text-green-800"><i class="fas fa-edit"></i></a>

                                        <form action="admin-formulas" method="post" onsubmit="return confirm('Xóa công thức này?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="productId" value="${f.productId}">
                                            <button type="submit" class="text-red-600 hover:text-red-800"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- ✅ Add Modal -->
        <div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center">
            <div class="bg-white rounded-xl w-full max-w-md p-6">
                <h3 class="text-xl font-bold mb-4">Gán Nguyên Liệu Cho Sản Phẩm</h3>
                <form action="admin-formulas" method="post" class="grid gap-4">
                    <input type="hidden" name="action" value="insert">

                    <label>Sản phẩm:</label>
                    <select name="productId" required class="border px-4 py-2 rounded-lg">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="p" items="${products}">
                            <option value="${p.id}">${p.name}</option>
                        </c:forEach>
                    </select>

                    <label>Nguyên liệu:</label>
<div class="max-h-48 overflow-y-auto border rounded-lg p-3">
    <c:forEach var="m" items="${materials}">
        <div class="flex items-center gap-2 mb-2">
            <input type="checkbox" name="materialIds" value="${m.id}" class="mt-1">
            <span>${m.name}</span>
            <input type="number" name="quantity_${m.id}" placeholder="Số lượng" class="w-20 px-2 py-1 border rounded" min="1">
        </div>
    </c:forEach>
</div>


                    <div class="flex justify-end gap-2 mt-2">
                        <button type="button" onclick="closeAddModal()" class="px-4 py-2 rounded-lg bg-gray-300">Hủy</button>
                        <button type="submit" class="px-4 py-2 rounded-lg bg-[#F8D7DA] hover:bg-[#F1A7A7]">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ✅ Edit Modal -->
        <c:if test="${not empty editProduct}">
            <div id="editModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                <div class="bg-white rounded-xl w-full max-w-md p-6">
                    <h3 class="text-xl font-bold mb-4">Cập Nhật Công Thức Cho Sản Phẩm</h3>
                    <form action="admin-formulas" method="post" class="grid gap-4">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productId" value="${editProduct.id}">

                        <label>Tên sản phẩm:</label>
                        <input type="text" value="${editProduct.name}" disabled class="border px-4 py-2 rounded-lg bg-gray-100">

                        <label>Nguyên liệu:</label>
<div class="max-h-48 overflow-y-auto border rounded-lg p-3">
    <c:forEach var="m" items="${materials}">
        <c:set var="selected" value="0"/>
        <c:forEach var="sm" items="${selectedMaterials}">
            <c:if test="${sm.id == m.id}">
                <c:set var="selected" value="${sm.quantity}"/>
            </c:if>
        </c:forEach>
        <div class="flex items-center gap-2 mb-2">
            <input type="checkbox" name="materialIds" value="${m.id}" class="mt-1" <c:if test="${selected > 0}">checked</c:if>>
            <span>${m.name}</span>
            <input type="number" name="quantity_${m.id}" placeholder="Số lượng" class="w-20 px-2 py-1 border rounded" min="1" value="${selected > 0 ? selected : ''}">
        </div>
    </c:forEach>
</div>


                        <div class="flex justify-end gap-2 mt-2">
                            <a href="admin-formulas" class="px-4 py-2 rounded-lg bg-gray-300">Hủy</a>
                            <button type="submit" class="px-4 py-2 rounded-lg bg-[#F8D7DA] hover:bg-[#F1A7A7]">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <script>
            const addModal = document.getElementById("addModal");
            function openAddModal() {
                addModal.classList.remove("hidden");
            }
            function closeAddModal() {
                addModal.classList.add("hidden");
                addModal.querySelector("form").reset();
            }
        </script>

    </body>
</html>
