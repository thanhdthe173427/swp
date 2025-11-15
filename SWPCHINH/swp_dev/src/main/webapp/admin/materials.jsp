<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nguyên Liệu - Admin</title>
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
    
    <%@ include file="/Trang/sidebarAdmin.jsp" %>

    <main class="flex-1 overflow-auto">
        <%@ include file="/Trang/headerAdmin.jsp" %>

        <section class="p-8">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2">
                        <i class="fas fa-flask"></i> Quản Lý Nguyên Liệu
                    </h2>
                    <p class="text-gray-500 text-sm mt-1">Theo dõi, thêm và chỉnh sửa nguyên liệu</p>
                </div>
                <button onclick="openAddModal()"
                        class="bg-gradient-to-r from-pink-300 to-pink-400 hover:from-pink-400 hover:to-pink-500 text-white font-medium px-5 py-2 rounded-lg shadow-md flex items-center gap-2">
                    <i class="fas fa-plus"></i> Thêm nguyên liệu
                </button>
            </div>

            <!-- Form tìm kiếm -->
            <form action="admin-materials" method="get" class="mb-8 flex items-center gap-2">
                <div class="relative w-80">
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input type="text" name="search" value="${search}" placeholder="Tìm kiếm nguyên liệu..."
                           class="pl-10 pr-4 py-2 border border-pink-200 rounded-lg w-full focus:ring-2 focus:ring-pink-300 shadow-sm">
                </div>
                <button type="submit"
                        class="bg-pink-200 hover:bg-pink-300 text-gray-800 px-4 py-2 rounded-lg font-medium shadow-sm">
                    Tìm
                </button>
            </form>

            <!-- Bảng -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left font-semibold">ID</th>
                            <th class="px-6 py-3 text-left font-semibold">Tên Nguyên Liệu</th>
                            <th class="px-6 py-3 text-left font-semibold">Mô Tả</th>
                            <th class="px-6 py-3 text-left font-semibold">Số lượng</th>
                            <th class="px-6 py-3 text-left font-semibold">Đơn Vị</th>
                            <th class="px-6 py-3 text-left font-semibold">Giá Cost (VNĐ)</th>
                            <th class="px-6 py-3 text-center font-semibold">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                        <c:forEach var="m" items="${materials}">
                            <tr class="hover:bg-pink-50">
                                <td class="px-6 py-4 font-medium text-gray-800">${m.id}</td>
                                <td class="px-6 py-4 text-gray-700">${m.name}</td>
                                <td class="px-6 py-4 text-gray-600">${m.description}</td>
                                <td class="px-6 py-4 text-gray-700">${m.quantity}</td>
                                <td class="px-6 py-4 text-gray-700">${m.unit}</td>
                                <td class="px-6 py-4 text-gray-700">${m.costPrice}</td>
                                <td class="px-6 py-4 text-center">
                                    <div class="flex justify-center gap-4">
                                        <a href="#"
                                           onclick='openUpdateModal({
                                               id: "${m.id}",
                                               name: "${m.name}",
                                               description: "${m.description}",
                                               unit: "${m.unit}",
                                               costPrice: "${m.costPrice}"
                                           })'
                                           class="text-green-600 hover:text-green-800 text-lg transition">
                                           <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="admin-materials" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa nguyên liệu này?')">
                                            <input type="hidden" name="deleteId" value="${m.id}">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="text-red-500 hover:text-red-700 text-lg transition">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty materials}">
                            <tr>
                                <td colspan="6" class="text-center py-6 text-gray-500 italic">Không có nguyên liệu nào được tìm thấy.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<!-- Modal Thêm -->
<div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-8 relative">
        <button onclick="closeAddModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>
        <h3 class="text-xl font-bold text-pink-700 mb-6">Thêm Nguyên Liệu Mới</h3>

        <form action="admin-materials" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" placeholder="Tên nguyên liệu" required class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="text" name="description" placeholder="Mô tả" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="text" name="unit" placeholder="Đơn vị (VD: kg, bó, gói)" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="number" name="costPrice" placeholder="Giá cost (VNĐ)" min="0" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeAddModal()" class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300">Hủy</button>
                <button type="submit" class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Cập nhật -->
<div id="updateModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-8 relative">
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>
        <h3 class="text-xl font-bold text-pink-700 mb-6">Cập Nhật Nguyên Liệu</h3>

        <form id="updateForm" action="admin-materials" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="materialId" id="updateId">
            <input type="text" name="name" id="updateName" required class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="text" name="description" id="updateDescription" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="text" name="unit" id="updateUnit" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
            <input type="number" name="costPrice" id="updateCostPrice" min="0" class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeUpdateModal()" class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300">Hủy</button>
                <button type="submit" class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    const addModal = document.getElementById("addModal");
    const updateModal = document.getElementById("updateModal");

    function openAddModal() { addModal.classList.remove("hidden"); }
    function closeAddModal() { addModal.classList.add("hidden"); addModal.querySelector("form").reset(); }

    function openUpdateModal(material) {
        document.getElementById("updateId").value = material.id;
        document.getElementById("updateName").value = material.name;
        document.getElementById("updateDescription").value = material.description;
        document.getElementById("updateUnit").value = material.unit;
        document.getElementById("updateCostPrice").value = material.costPrice;
        updateModal.classList.remove("hidden");
    }
    function closeUpdateModal() { updateModal.classList.add("hidden"); updateModal.querySelector("form").reset(); }
</script>

</body>
</html>
