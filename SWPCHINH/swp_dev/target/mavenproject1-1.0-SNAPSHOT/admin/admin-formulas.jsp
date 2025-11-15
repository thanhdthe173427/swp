<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Công Thức - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        * { transition: all 0.25s ease-in-out; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background-color: #f3a7b8; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background-color: #e17c8e; }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .btn-primary { background: linear-gradient(to right, #F8D7DA, #F1A7A7); }
        .btn-primary:hover { background: linear-gradient(to right, #F1A7A7, #F8D7DA); }
    </style>
</head>

<body class="bg-gradient-to-r from-pink-50 to-white text-gray-700 min-h-screen">
    <div class="flex min-h-screen">

        <%@ include file="/Trang/sidebarAdmin.jsp" %> <!-- ✅ Sidebar -->

        <main class="flex-1 overflow-auto">
            <%@ include file="/Trang/headerAdmin.jsp" %> <!-- ✅ Header -->

            <section class="p-8">
                <div class="flex justify-between items-center mb-8">
                    <div>
                        <h2 class="text-3xl font-bold text-pink-700">💐 Quản Lý Công Thức Sản Phẩm</h2>
                        <p class="text-gray-500 text-sm mt-1">Theo dõi và chỉnh sửa công thức pha chế sản phẩm</p>
                    </div>
                    <button onclick="openAddModal()" 
                            class="btn-primary px-5 py-2 rounded-lg text-gray-800 font-medium shadow-md hover:shadow-lg flex items-center gap-2">
                        <i class="fas fa-plus"></i> Gán công thức mới
                    </button>
                </div>

                <!-- 🔍 Form tìm kiếm -->
                <form action="admin-formulas" method="get" class="mb-8 flex items-center gap-3">
                    <div class="relative w-72">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" name="search" value="${search}" placeholder="Tìm theo tên sản phẩm..."
                               class="pl-10 pr-4 py-2 border border-pink-200 rounded-lg w-full focus:ring-2 focus:ring-pink-300 shadow-sm">
                    </div>
                    <button type="submit" class="btn-primary px-4 py-2 rounded-lg text-gray-800 font-medium shadow-sm hover:shadow-md">
                        Tìm
                    </button>
                </form>

                <!-- 📋 Bảng danh sách -->
                <div class="bg-white rounded-2xl shadow-md overflow-x-auto border border-pink-100">
                    <table class="w-full text-sm">
                        <thead class="bg-gradient-to-r from-pink-100 to-pink-200 text-gray-700">
                            <tr>
                                <th class="px-6 py-4 text-left font-semibold">ID Sản Phẩm</th>
                                <th class="px-6 py-4 text-left font-semibold">Tên Sản Phẩm</th>
                                <th class="px-6 py-4 text-left font-semibold">Nguyên Liệu</th>
                                <th class="px-6 py-4 text-center font-semibold">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-pink-100">
                            <c:forEach var="f" items="${formulas}">
                                <tr class="hover:bg-pink-50 transition">
                                    <td class="px-6 py-4">${f.productId}</td>
                                    <td class="px-6 py-4 font-semibold text-gray-800">${f.productName}</td>
                                    <td class="px-6 py-4 text-gray-600">
                                        <ul class="list-disc ml-5">
                                            <c:forEach var="m" items="${f.materials}">
                                                <li>${m.name} <span class="text-xs text-gray-500">(${m.quantity})</span></li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <div class="flex justify-center gap-4">
                                            <a href="admin-formulas?action=edit&productId=${f.productId}"
                                               class="text-green-600 hover:text-green-800 text-lg"><i class="fas fa-edit"></i></a>
                                            <form action="admin-formulas" method="post" 
                                                  onsubmit="return confirm('Xóa công thức này?')" class="inline-block">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="productId" value="${f.productId}">
                                                <button type="submit" class="text-red-500 hover:text-red-700 text-lg"><i class="fas fa-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty formulas}">
                                <tr>
                                    <td colspan="4" class="text-center text-gray-500 py-6 italic">
                                        Không có công thức nào được tìm thấy.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- ✅ Modal thêm -->
    <div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
        <div class="bg-white rounded-2xl w-full max-w-lg p-8 shadow-2xl relative card-hover">
            <button onclick="closeAddModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                <i class="fas fa-times text-lg"></i>
            </button>

            <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
                <i class="fas fa-flask"></i> Gán Nguyên Liệu Cho Sản Phẩm
            </h3>

            <form action="admin-formulas" method="post" class="grid gap-4">
                <input type="hidden" name="action" value="insert">

                <div>
                    <label class="font-semibold">Sản phẩm:</label>
                    <select name="productId" required class="mt-1 w-full border border-pink-300 px-4 py-2 rounded-lg focus:ring-2 focus:ring-pink-200">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="p" items="${products}">
                            <option value="${p.id}">${p.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="font-semibold">Nguyên liệu:</label>
                    <div class="max-h-48 overflow-y-auto border border-pink-200 rounded-lg p-3">
                        <c:forEach var="m" items="${materials}">
                            <div class="flex items-center gap-3 mb-2">
                                <input type="checkbox" name="materialIds" value="${m.id}" class="accent-pink-400">
                                <span class="flex-1">${m.name}</span>
                                <input type="number" name="quantity_${m.id}" placeholder="SL" 
                                       class="w-24 px-2 py-1 border rounded focus:ring-1 focus:ring-pink-300 text-center" min="1">
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="flex justify-end gap-3 mt-4">
                    <button type="button" onclick="closeAddModal()" 
                            class="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300">Hủy</button>
                    <button type="submit" 
                            class="btn-primary px-4 py-2 rounded-lg text-gray-800 font-medium shadow-md hover:shadow-lg">Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ✅ Modal sửa -->
    <c:if test="${not empty editProduct}">
        <div id="editModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-2xl w-full max-w-lg p-8 shadow-2xl relative card-hover">
                <a href="admin-formulas" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-lg"></i>
                </a>

                <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
                    <i class="fas fa-pen"></i> Cập Nhật Công Thức
                </h3>

                <form action="admin-formulas" method="post" class="grid gap-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productId" value="${editProduct.id}">

                    <label class="font-semibold">Tên sản phẩm:</label>
                    <input type="text" value="${editProduct.name}" disabled 
                           class="border px-4 py-2 rounded-lg bg-gray-100">

                    <label class="font-semibold">Nguyên liệu:</label>
                    <div class="max-h-48 overflow-y-auto border border-pink-200 rounded-lg p-3">
                        <c:forEach var="m" items="${materials}">
                            <c:set var="selected" value="0"/>
                            <c:forEach var="sm" items="${selectedMaterials}">
                                <c:if test="${sm.id == m.id}">
                                    <c:set var="selected" value="${sm.quantity}"/>
                                </c:if>
                            </c:forEach>
                            <div class="flex items-center gap-3 mb-2">
                                <input type="checkbox" name="materialIds" value="${m.id}" class="accent-pink-400" 
                                       <c:if test="${selected > 0}">checked</c:if>>
                                <span class="flex-1">${m.name}</span>
                                <input type="number" name="quantity_${m.id}" placeholder="SL" 
                                       class="w-24 px-2 py-1 border rounded focus:ring-1 focus:ring-pink-300 text-center" min="1" 
                                       value="${selected > 0 ? selected : ''}">
                            </div>
                        </c:forEach>
                    </div>

                    <div class="flex justify-end gap-3 mt-4">
                        <a href="admin-formulas" 
                           class="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300">Hủy</a>
                        <button type="submit" 
                                class="btn-primary px-4 py-2 rounded-lg text-gray-800 font-medium shadow-md hover:shadow-lg">
                            Cập nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <script>
        const addModal = document.getElementById("addModal");
        function openAddModal() { addModal.classList.remove("hidden"); }
        function closeAddModal() { addModal.classList.add("hidden"); addModal.querySelector("form").reset(); }
    </script>
</body>
</html>
