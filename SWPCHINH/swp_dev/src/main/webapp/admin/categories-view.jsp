<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { transition: all 0.25s ease-in-out; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background-color: #f3a7b8; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background-color: #e17c8e; }
        .btn-primary { background: linear-gradient(to right, #F8D7DA, #F1A7A7); }
        .btn-primary:hover { background: linear-gradient(to right, #F1A7A7, #F8D7DA); }
    </style>
</head>

<body class="bg-gradient-to-r from-pink-50 to-white text-gray-700 min-h-screen">

<div class="flex min-h-screen">
    <%@ include file="/Trang/sidebarAdmin.jsp" %>
    <main class="flex-1 overflow-auto">
        <%@ include file="/Trang/headerAdmin.jsp" %>

        <section class="p-8">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-3xl font-bold text-pink-700">🗂️ Quản Lý Danh Mục</h2>
                    <p class="text-gray-500 text-sm mt-1">Theo dõi và chỉnh sửa danh mục sản phẩm</p>
                </div>
                <button onclick="openModal()" 
                        class="btn-primary px-5 py-2 rounded-lg text-gray-800 font-medium shadow-sm hover:shadow-md flex items-center gap-2">
                    <i class="fas fa-plus"></i> Thêm danh mục
                </button>
            </div>

            <!-- 🔍 Form tìm kiếm -->
            <form action="admin-categories" method="get" class="mb-8 flex items-center gap-3">
                <div class="relative w-80">
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm danh mục theo tên hoặc mô tả..."
                           class="pl-10 pr-4 py-2 border border-pink-200 rounded-lg w-full focus:ring-2 focus:ring-pink-300 shadow-sm">
                </div>
                <button type="submit"
                        class="btn-primary px-5 py-2 rounded-lg text-gray-800 font-medium shadow-sm hover:shadow-md flex items-center gap-2">
                    <i class="fas fa-search"></i> Tìm
                </button>
            </form>

            <!-- 📋 Bảng danh mục -->
            <div class="bg-white rounded-2xl shadow-lg overflow-x-auto border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-100 to-pink-200 text-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left font-semibold">Mã Danh Mục</th>
                            <th class="px-6 py-3 text-left font-semibold">Tên Danh Mục</th>
                            <th class="px-6 py-3 text-left font-semibold">Mô Tả</th>
                            <th class="px-6 py-3 text-center font-semibold">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                        <c:forEach var="p" items="${categories}">
                            <tr class="hover:bg-pink-50 transition">
                                <td class="px-6 py-3 font-medium text-gray-800">${p.getId()}</td>
                                <td class="px-6 py-3 text-gray-700">${p.getName()}</td>
                                <td class="px-6 py-3 text-gray-600">${p.getDescription()}</td>
                                <td class="px-6 py-3 text-center">
                                    <div class="flex justify-center gap-4">
                                        <a href="#" 
                                           class="text-green-600 hover:text-green-800 transition text-lg"
                                           data-id="${p.getId()}"
                                           data-name="${p.getName()}"
                                           data-description="${p.getDescription()}"
                                           onclick="handleUpdateClick(this)">
                                           <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="admin-categories" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                            <input type="hidden" name="deleteId" value="${p.getId()}">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="text-red-500 hover:text-red-700 text-lg transition">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="4" class="text-center text-gray-500 py-6 italic">
                                    Không tìm thấy danh mục nào.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<!-- 🪟 Modal Thêm -->
<div id="addCategoryModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl w-full max-w-lg p-8 shadow-2xl relative">
        <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
            <i class="fas fa-folder-plus"></i> Thêm Danh Mục Mới
        </h3>

        <form action="admin-categories" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" placeholder="Tên danh mục" required
                   class="px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            <input type="text" name="description" placeholder="Mô tả" required
                   class="px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeModal()"
                        class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 font-medium hover:bg-gray-300">Hủy</button>
                <button type="submit"
                        class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white font-medium hover:shadow-md">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- 🪟 Modal Sửa -->
<div id="updateCategoryModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl w-full max-w-lg p-8 shadow-2xl relative">
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
            <i class="fas fa-edit"></i> Cập Nhật Danh Mục
        </h3>

        <form id="updateCategoryForm" action="admin-categories" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" id="updateCategoryId">

            <input type="text" name="name" id="updateName" placeholder="Tên danh mục" required
                   class="px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            <input type="text" name="description" id="updateDescription" placeholder="Mô tả" required
                   class="px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 font-medium hover:bg-gray-300">Hủy</button>
                <button type="submit"
                        class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white font-medium hover:shadow-md">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById("addCategoryModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("addCategoryModal").classList.add("hidden");
    }

    function handleUpdateClick(el) {
        const id = el.dataset.id;
        const name = el.dataset.name;
        const description = el.dataset.description;

        document.getElementById("updateCategoryId").value = id;
        document.getElementById("updateName").value = name;
        document.getElementById("updateDescription").value = description;
        document.getElementById("updateCategoryModal").classList.remove("hidden");
    }

    function closeUpdateModal() {
        document.getElementById("updateCategoryModal").classList.add("hidden");
    }
</script>
</body>
</html>
