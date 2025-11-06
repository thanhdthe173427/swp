<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nguyên Liệu - Admin</title>
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

        <h2 class="text-2xl font-bold mb-4">Quản Lý Nguyên Liệu</h2>

        <button onclick="openAddModal()"
                class="bg-[#F8D7DA] px-4 py-2 rounded-lg hover:bg-[#F1A7A7] mb-4">
            <i class="fas fa-plus"></i> Thêm nguyên liệu
        </button>

        <form action="admin-materials" method="get" class="mb-4">
            <input type="text" name="search" value="${search}" placeholder="Tìm kiếm nguyên liệu..."
                   class="px-4 py-2 border rounded-lg">
            <button type="submit" class="bg-[#F8D7DA] px-4 py-2 rounded-lg hover:bg-[#F1A7A7]">Tìm</button>
        </form>

        <div class="bg-white rounded-xl shadow-md overflow-x-auto">
            <table class="w-full">
                <thead class="bg-[#F8D7DA]">
                <tr>
                    <th class="px-6 py-4 text-left">ID</th>
                    <th class="px-6 py-4 text-left">Tên</th>
                    <th class="px-6 py-4 text-left">Mô tả</th>
                    <th class="px-6 py-4 text-left">Đơn vị</th>
                    <th class="px-6 py-4 text-left">Giá cost (VNĐ)</th>
                    <th class="px-6 py-4 text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${materials}">
                    <tr class="border-b">
                        <td class="px-6 py-4">${m.id}</td>
                        <td class="px-6 py-4">${m.name}</td>
                        <td class="px-6 py-4">${m.description}</td>
                        <td class="px-6 py-4">${m.unit}</td>
                        <td class="px-6 py-4">${m.costPrice}</td>
                        <td class="px-6 py-4 text-center flex justify-center gap-2">
                            <a href="#" onclick='openUpdateModal({
                                id: "${m.id}",
                                name: "${m.name}",
                                description: "${m.description}",
                                unit: "${m.unit}",
                                costPrice: "${m.costPrice}"
                            })' class="text-green-600 hover:text-green-800"><i class="fas fa-edit"></i></a>

                            <form action="admin-materials" method="post">
                                <input type="hidden" name="deleteId" value="${m.id}">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa?')"
                                        class="text-red-600 hover:text-red-800"><i class="fas fa-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </main>
</div>

<!-- Add & Update Modal (giữ nguyên như trước) -->
<div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center">
    <div class="bg-white rounded-xl w-full max-w-md p-6">
        <h3 class="text-xl font-bold mb-4">Thêm nguyên liệu mới</h3>
        <form action="admin-materials" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" placeholder="Tên" required class="border px-4 py-2 rounded-lg">
            <input type="text" name="description" placeholder="Mô tả" class="border px-4 py-2 rounded-lg">
            <input type="text" name="unit" placeholder="Đơn vị" class="border px-4 py-2 rounded-lg">
            <input type="number" name="costPrice" placeholder="Giá cost" min="0" class="border px-4 py-2 rounded-lg">
            <div class="flex justify-end gap-2 mt-2">
                <button type="button" onclick="closeAddModal()" class="px-4 py-2 rounded-lg bg-gray-300">Hủy</button>
                <button type="submit" class="px-4 py-2 rounded-lg bg-[#F8D7DA] hover:bg-[#F1A7A7]">Thêm</button>
            </div>
        </form>
    </div>
</div>

<div id="updateModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center">
    <div class="bg-white rounded-xl w-full max-w-md p-6">
        <h3 class="text-xl font-bold mb-4">Cập nhật nguyên liệu</h3>
        <form id="updateForm" action="admin-materials" method="post" class="grid gap-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="materialId" id="updateId">
            <input type="text" name="name" id="updateName" placeholder="Tên" required class="border px-4 py-2 rounded-lg">
            <input type="text" name="description" id="updateDescription" placeholder="Mô tả" class="border px-4 py-2 rounded-lg">
            <input type="text" name="unit" id="updateUnit" placeholder="Đơn vị" class="border px-4 py-2 rounded-lg">
            <input type="number" name="costPrice" id="updateCostPrice" placeholder="Giá cost" min="0" class="border px-4 py-2 rounded-lg">
            <div class="flex justify-end gap-2 mt-2">
                <button type="button" onclick="closeUpdateModal()" class="px-4 py-2 rounded-lg bg-gray-300">Hủy</button>
                <button type="submit" class="px-4 py-2 rounded-lg bg-[#F8D7DA] hover:bg-[#F1A7A7]">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    // ----- Add Modal -----
    const addModal = document.getElementById("addModal");

    function openAddModal() {
        addModal.classList.remove("hidden");
    }

    function closeAddModal() {
        addModal.classList.add("hidden");
        // reset form nếu muốn
        addModal.querySelector("form").reset();
    }

    // ----- Update Modal -----
    const updateModal = document.getElementById("updateModal");

    function openUpdateModal(material) {
        document.getElementById("updateId").value = material.id;
        document.getElementById("updateName").value = material.name;
        document.getElementById("updateDescription").value = material.description;
        document.getElementById("updateUnit").value = material.unit;
        document.getElementById("updateCostPrice").value = material.costPrice;
        updateModal.classList.remove("hidden");
    }

    function closeUpdateModal() {
        updateModal.classList.add("hidden");
        // reset form nếu muốn
        updateModal.querySelector("form").reset();
    }
</script>
</body>