<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Nguyên Liệu Tồn Kho</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <style>
        * { transition: all 0.25s ease-in-out; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background-color: #f3a7b8; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background-color: #e17c8e; }
        @media print {
            .no-print { display: none !important; }
            body { background: white !important; }
            .print-content { padding: 20px; }
        }
    </style>
</head>

<body class="bg-gradient-to-r from-pink-50 via-white to-pink-100 text-gray-700"
      x-data="inventoryPage()">

<div class="flex min-h-screen">
    <%@ include file="/Trang/sidebarAdmin.jsp" %>
    <main class="flex-1 overflow-auto">
        <%@ include file="/Trang/headerAdmin.jsp" %>

        <section class="p-8">
            <div class="flex justify-between items-center mb-8 pb-4 border-b border-pink-100">
                <div>
                    <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2">
                        <i class="fas fa-warehouse"></i> Danh Sách Nguyên Liệu Tồn Kho
                    </h2>
                    <p class="text-gray-500 text-sm mt-1">Theo dõi lượng nguyên liệu còn lại trong kho</p>
                </div>

                <button type="button" @click="showReportModal = true"
                        class="bg-gradient-to-r from-pink-400 to-red-500 hover:from-pink-500 hover:to-red-600 text-white font-medium px-5 py-2 rounded-lg shadow-md flex items-center gap-2 transition">
                    <i class="fas fa-file-alt"></i> Xem Báo Cáo
                </button>
            </div>

            <div class="bg-white rounded-2xl shadow-md overflow-hidden border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                    <tr>
                        <th class="px-6 py-3 text-left font-semibold">ID</th>
                        <th class="px-6 py-3 text-left font-semibold">Tên Nguyên Liệu</th>
                        <th class="px-6 py-3 text-left font-semibold">Số Lượng Tồn</th>
                        <th class="px-6 py-3 text-left font-semibold">Ngày Cập Nhật</th>
                        <th class="px-6 py-3 text-center font-semibold">Trạng Thái</th>
                        <th class="px-6 py-3 text-center font-semibold">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                    <c:forEach var="i" items="${inventoryList}">
                        <tr class="hover:bg-pink-50">
                            <td class="px-6 py-4 font-medium text-gray-800">${i.id}</td>
                            <td class="px-6 py-4">${i.materialName}</td>
                            <td class="px-6 py-4">${i.quantity}</td>
                            <td class="px-6 py-4 text-gray-600">${i.updatedAt}</td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-3 py-1 rounded-full text-xs font-semibold
                                    <c:choose>
                                        <c:when test='${i.quantity > 0}'>bg-green-100 text-green-700</c:when>
                                        <c:otherwise>bg-red-100 text-red-700</c:otherwise>
                                    </c:choose>">
                                        ${i.quantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <button
                                        class="bg-blue-500 hover:bg-blue-600 text-white font-medium px-3 py-1 rounded-lg flex items-center gap-1 mx-auto transition"
                                        data-material-id="${i.id}"
                                        data-material-name="${i.materialName}"
                                        data-quantity="${i.quantity}"
                                        data-warehouse-id="${warehouseId}"
                                        @click="openEditModal($el)">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty inventoryList}">
                        <tr><td colspan="6" class="py-6 text-center text-gray-500 italic">Không có nguyên liệu nào trong kho này.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<!-- Modal Sửa Số Lượng -->
<div x-show="showEditModal" x-transition class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50 no-print" style="display: none;">
    <div @click.away="showEditModal = false" class="bg-white rounded-2xl shadow-2xl w-[500px] p-6 border border-pink-100">
        <div class="flex justify-between items-center border-b border-pink-100 pb-3 mb-4">
            <h2 class="text-xl font-bold text-pink-700 flex items-center gap-2">
                <i class="fas fa-edit text-blue-500"></i> Cập Nhật Số Lượng Tồn
            </h2>
            <button type="button" @click="showEditModal = false" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>

        <form @submit.prevent="submitEditForm" class="space-y-4">
            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1">Tên Nguyên Liệu</label>
                <input type="text" x-model="editData.materialName" disabled class="w-full px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-gray-600" />
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1">Số Lượng Tồn Mới</label>
                <input type="number" x-model="editData.quantity" min="0" required class="w-full px-4 py-2 border border-pink-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500" />
            </div>

            <div class="flex justify-end gap-3 mt-6">
                <button type="button" @click="showEditModal = false" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-4 rounded-lg transition">Hủy</button>
                <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition">Cập Nhật</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Báo Cáo -->
<div x-show="showReportModal" x-transition class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50 p-4" style="display: none;">
    <div @click.away="showReportModal = false" class="bg-white rounded-2xl shadow-2xl w-full max-w-5xl max-h-[90vh] overflow-auto border border-pink-100 print-content">
        <!-- Header -->
        <div class="sticky top-0 bg-white border-b border-pink-100 p-6 flex justify-between items-center no-print">
            <h2 class="text-2xl font-bold text-pink-700 flex items-center gap-2">
                <i class="fas fa-chart-bar text-red-500"></i> Báo Cáo Tồn Kho
            </h2>
            <div class="flex gap-2">
                <button type="button" @click="window.print()" 
                        class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition flex items-center gap-2">
                    <i class="fas fa-print"></i> In Báo Cáo
                </button>
                <button type="button" @click="showReportModal = false" 
                        class="text-gray-500 hover:text-gray-700 text-2xl px-2">&times;</button>
            </div>
        </div>

        <!-- Report Content -->
        <div class="p-8">
            <!-- Report Header -->
            <div class="text-center mb-8 pb-6 border-b-2 border-pink-200">
                <h1 class="text-3xl font-bold text-gray-800 mb-2">BÁO CÁO TỒN KHO</h1>
                <p class="text-gray-600">Mã Kho: <span class="font-semibold">${warehouseId}</span></p>
                <p class="text-gray-600">Ngày xuất: <span class="font-semibold" x-text="getCurrentDate()"></span></p>
            </div>

            <!-- Statistics Summary - DỮ LIỆU TỪ DATABASE -->
            <div class="grid grid-cols-3 gap-6 mb-8">
                <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-6 border border-blue-200">
                    <div class="flex items-center gap-3">8
                        <div class="bg-blue-500 text-white rounded-full w-12 h-12 flex items-center justify-center">
                            <i class="fas fa-boxes text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Tổng Số Mặt Hàng</p>
                            <p class="text-2xl font-bold text-blue-700">${totalItems}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-6 border border-green-200">
                    <div class="flex items-center gap-3">
                        <div class="bg-green-500 text-white rounded-full w-12 h-12 flex items-center justify-center">
                            <i class="fas fa-check-circle text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Còn Hàng</p>
                            <p class="text-2xl font-bold text-green-700">${inStock}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-red-50 to-red-100 rounded-xl p-6 border border-red-200">
                    <div class="flex items-center gap-3">
                        <div class="bg-red-500 text-white rounded-full w-12 h-12 flex items-center justify-center">
                            <i class="fas fa-exclamation-triangle text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Hết Hàng</p>
                            <p class="text-2xl font-bold text-red-700">${outOfStock}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Report Table - DỮ LIỆU TỪ DATABASE Database->Dao->Servlet->JSP->modal bao cao  --> 
            <div class="bg-white rounded-xl shadow-md overflow-hidden border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                    <tr>
                        <th class="px-6 py-4 text-left font-bold">STT</th>
                        <th class="px-6 py-4 text-left font-bold">Tên Nguyên Liệu</th>
                        <th class="px-6 py-4 text-center font-bold">Số Lượng Tồn</th>
                        <th class="px-6 py-4 text-center font-bold">Ngày Cập Nhật</th>
                        <th class="px-6 py-4 text-center font-bold">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                    <c:forEach var="i" items="${inventoryList}" varStatus="status">
                        <tr class="hover:bg-pink-50">
                            <td class="px-6 py-4 font-medium text-gray-800">${status.index + 1}</td>
                            <td class="px-6 py-4 font-medium">${i.materialName}</td>
                            <td class="px-6 py-4 text-center font-semibold">${i.quantity}</td>
                            <td class="px-6 py-4 text-center text-gray-600">${i.updatedAt}</td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-3 py-1 rounded-full text-xs font-semibold
                                    <c:choose>
                                        <c:when test='${i.quantity > 0}'>bg-green-100 text-green-700</c:when>
                                        <c:otherwise>bg-red-100 text-red-700</c:otherwise>
                                    </c:choose>">
                                        ${i.quantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty inventoryList}">
                        <tr><td colspan="5" class="py-8 text-center text-gray-500 italic">Không có dữ liệu</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Report Footer -->
            <div class="mt-8 pt-6 border-t border-pink-100 text-center text-gray-500 text-sm">
                <p>Báo cáo được tạo tự động từ hệ thống quản lý kho</p>
                <p class="mt-1">© 2025 - Warehouse Management System</p>
            </div>
        </div>
    </div>
</div>

<script>
    /**
     * Alpine.js data for Inventory Page
     * Dữ liệu đã được load từ database thông qua Servlet
     */
    function inventoryPage() {
        // Lấy warehouseId từ JSP (đã có từ database)
        const warehouseId = '${warehouseId}';
        const validWarehouseId = (warehouseId && warehouseId !== 'null' && warehouseId !== '') 
                                 ? warehouseId : 'default-warehouse'; 

        return {
            showReportModal: false, 
            showEditModal: false,
            
            editData: { 
                materialId: '', 
                materialName: '', 
                quantity: '', 
                warehouseId: validWarehouseId 
            },

            /**
             * Mở modal chỉnh sửa
             */
            openEditModal(el) {
                this.editData.materialId = el.dataset.materialId;
                this.editData.materialName = el.dataset.materialName;
                this.editData.quantity = el.dataset.quantity;
                this.editData.warehouseId = el.dataset.warehouseId || validWarehouseId;
                this.showEditModal = true;
            },

            /**
             * Submit form cập nhật số lượng
             */
            submitEditForm() {
                if (!this.editData.warehouseId || this.editData.warehouseId === 'default-warehouse') {
                    alert("Lỗi: Không tìm thấy ID kho hàng. Vui lòng tải lại trang.");
                    this.showEditModal = false; 
                    return; 
                }

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'inventory';

                const fields = {
                    action: 'updateQuantity',
                    warehouseId: this.editData.warehouseId,
                    materialId: this.editData.materialId,
                    quantity: this.editData.quantity
                };

                for (const [key, value] of Object.entries(fields)) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    form.appendChild(input);
                }

                document.body.appendChild(form);
                form.submit();
            },

            /**
             * Format ngày tháng hiện tại
             */
            getCurrentDate() {
                return new Date().toLocaleDateString('vi-VN', {
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                });
            }
        }
    }
</script>
</body>
</html>