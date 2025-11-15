<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Lô Hàng - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { transition: all 0.2s ease-in-out; }
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
                    <h2 class="text-3xl font-bold text-pink-700">📦 Quản Lý Lô Hàng</h2>
                    <p class="text-gray-500 text-sm mt-1">Theo dõi và quản lý chi tiết các lô nguyên liệu trong kho</p>
                </div>
                <button onclick="openModal()" 
                        class="btn-primary px-5 py-2 rounded-lg text-gray-800 font-medium shadow-sm hover:shadow-md flex items-center gap-2">
                    <i class="fas fa-plus"></i> Thêm lô hàng
                </button>
            </div>

            <!-- 📋 Bảng danh sách -->
            <div class="bg-white rounded-2xl shadow-lg overflow-x-auto border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-100 to-pink-200 text-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left font-semibold">ID</th>
                            <th class="px-6 py-3 text-left font-semibold">Mã Nguyên Liệu</th>
                            <th class="px-6 py-3 text-left font-semibold">Tên Nguyên Liệu</th>
                            <th class="px-6 py-3 text-left font-semibold">Mã Kho</th>
                            <th class="px-6 py-3 text-left font-semibold">Nhà Cung Cấp</th>
                            <th class="px-6 py-3 text-left font-semibold">Mã Lô</th>
                            <th class="px-6 py-3 text-left font-semibold">Ngày Nhập</th>
                            <th class="px-6 py-3 text-left font-semibold">SL Nhập</th>
                            <th class="px-6 py-3 text-center font-semibold">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                        <c:forEach var="b" items="${batches}">
                            <tr class="hover:bg-pink-50 transition">
                                <td class="px-6 py-3">${b.getId()}</td>
                                <td class="px-6 py-3">${b.getMaterialId()}</td>
                                <td class="px-6 py-3 font-medium text-gray-800">${b.materialName}</td>
                                <td class="px-6 py-3">${b.getWarehouseId()}</td>
                                <td class="px-6 py-3">${b.getSupplierName()}</td>
                                <td class="px-6 py-3">${b.getBatchCode()}</td>
                                <td class="px-6 py-3">${b.getMfgDate()}</td>
                                <td class="px-6 py-3 text-yellow-700 font-semibold">${b.getQtyReserved()}</td>
                                <td class="px-6 py-3 text-center">
                                    <button onclick="handleUpdateClick(this)" 
                                            data-id="${b.getId()}"
                                            data-productid="${b.getMaterialId()}"
                                            data-warehouseid="${b.getWarehouseId()}"
                                            data-supplierid="${b.getSupplierId()}"
                                            data-batchcode="${b.getBatchCode()}"
                                            data-mfgdate="${b.getMfgDate()}"
                                            data-qtyreserved="${b.getQtyReserved()}"
                                            class="text-purple-600 hover:text-purple-800 font-medium flex items-center gap-1 mx-auto">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty batches}">
                            <tr>
                                <td colspan="10" class="text-center text-gray-500 py-6 italic">
                                    Không có lô hàng nào được hiển thị.
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
<div id="addBatchModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl w-full max-w-2xl p-8 shadow-2xl relative">
        <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
            <i class="fas fa-box-open"></i> Thêm Lô Hàng Mới
        </h3>

        <form id="addBatchForm" action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
            <input type="hidden" name="action" value="add">

            <!-- Sản phẩm -->
            <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-600 mb-1">Nguyên liệu</label>
                <select name="productId" required 
                        class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <c:forEach var="p" items="${products}">
                        <option value="${p.getId()}">${p.getName()}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Kho -->
            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Kho Hàng</label>
                <select name="warehouseId" class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <option value="">-- Chọn kho --</option>
                    <c:forEach var="w" items="${warehouses}">
                        <option value="${w.getId()}">${w.getName()}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- NCC -->
            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Nhà Cung Cấp</label>
                <select name="supplierId" class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <option value="">-- Chọn NCC --</option>
                    <c:forEach var="s" items="${suppliers}">
                        <option value="${s.id}">${s.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Mã Lô -->
            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Mã Lô</label>
                <input type="text" name="batchCode" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <!-- Ngày -->
            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Ngày Sản Xuất</label>
                <input type="date" name="mfgDate" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <!-- SL nhập -->
            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Số lượng nhập</label>
                <input type="number" name="qtyReserved" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <!-- Nút -->
            <div class="col-span-2 flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeModal()" 
                        class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 font-medium hover:bg-gray-300">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white font-medium hover:shadow-md">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- 🪟 Modal Sửa -->
<div id="updateBatchModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-2xl w-full max-w-2xl p-8 shadow-2xl relative">
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-2xl font-bold mb-6 text-pink-700 flex items-center gap-2">
            <i class="fas fa-edit"></i> Cập Nhật Lô Hàng
        </h3>

        <form id="updateBatchForm" action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
            <input type="hidden" name="batchId" id="updateBatchId">
            <input type="hidden" name="action" value="update">

            <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-600 mb-1">Nguyên liệu</label>
                <select name="productId" id="updateProductId" required 
                        class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <c:forEach var="p" items="${products}">
                        <option value="${p.getId()}">${p.getName()}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Kho Hàng</label>
                <select name="warehouseId" id="updateWarehouseId" 
                        class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <option value="">-- Chọn kho --</option>
                    <c:forEach var="w" items="${warehouses}">
                        <option value="${w.getId()}">${w.getName()}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Nhà Cung Cấp</label>
                <select name="supplierId" id="updateSupplierId" 
                        class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
                    <option value="">-- Chọn NCC --</option>
                    <c:forEach var="s" items="${suppliers}">
                        <option value="${s.id}">${s.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Mã Lô</label>
                <input type="text" name="batchCode" id="updateBatchCode" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Ngày Sản Xuất</label>
                <input type="date" name="mfgDate" id="updateMfgDate" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-600 mb-1">Số lượng nhập</label>
                <input type="number" name="qtyReserved" id="updateQtyReserved" required 
                       class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300">
            </div>

            <div class="col-span-2 flex justify-end gap-2 mt-4">
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
        document.getElementById("addBatchModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("addBatchModal").classList.add("hidden");
    }

    function handleUpdateClick(el) {
        const id = el.dataset.id;
        document.getElementById("updateBatchId").value = id;
        document.getElementById("updateProductId").value = el.dataset.productid;
        document.getElementById("updateWarehouseId").value = el.dataset.warehouseid;
        document.getElementById("updateSupplierId").value = el.dataset.supplierid;
        document.getElementById("updateBatchCode").value = el.dataset.batchcode;
        document.getElementById("updateMfgDate").value = el.dataset.mfgdate;
        document.getElementById("updateQtyReserved").value = el.dataset.qtyreserved;
        document.getElementById("updateBatchModal").classList.remove("hidden");
    }

    function closeUpdateModal() {
        document.getElementById("updateBatchModal").classList.add("hidden");
    }
</script>
</body>
</html>
