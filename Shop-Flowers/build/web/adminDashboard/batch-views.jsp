<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Lô Hàng - Admin Dashboard</title>
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
                        <i class="fas fa-list"></i>
                        <span>Quản lý Danh Mục</span>
                    </a>
                    <a href="admin-batches" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                        <i class="fas fa-boxes"></i>
                        <span>Quản Lý Lô Hàng</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                        <i class="fas fa-cog"></i>
                        <span>Cài Đặt</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                        <i class="fas fa-user"></i>
                        <span>Tài Khoản</span>
                    </a>
                </nav>
            </aside>

            <main class="flex-1 overflow-auto">
                <header class="bg-white shadow-sm border-b border-gray-200">
                    <div class="px-8 py-4 flex items-center justify-between">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-800">Quản Lý Lô Hàng</h2>
                            <p class="text-gray-600 text-sm mt-1">Quản lý và theo dõi lô hàng của bạn</p>
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
                    <button onclick="openModal()" 
                            class="bg-[#F8D7DA] text-gray-800 px-6 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition font-medium flex items-center gap-2 shadow-sm mb-6">
                        <i class="fas fa-plus"></i> Thêm lô hàng
                    </button>

                    <form action="admin-batches" method="get">
                        <div class="bg-white rounded-xl shadow-md p-4 mb-6">
                            <div class="relative">
                                <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                                <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm kiếm lô hàng theo mã lô..." 
                                       class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent outline-none">
                            </div>
                        </div>
                    </form>

                    <div class="bg-white rounded-xl shadow-md overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-[#F8D7DA] text-gray-800">
                                    <tr>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">ID</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mã Sản Phẩm</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Tên Sản Phẩm</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mã Kho</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mã Hóa Đơn NCC</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Mã Lô</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Ngày SX</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">Ngày HH</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">SL Tồn</th>
                                        <th class="px-6 py-4 text-left text-sm font-semibold">SL Đặt Trước</th>
                                        <th class="px-6 py-4 text-center text-sm font-semibold">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${batches}">
                                        <tr class="table-row border-b border-gray-200">
                                            <td class="px-6 py-4 text-sm font-medium text-gray-900">${b.getId()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getProductId()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">
                                                <c:forEach var="p" items="${products}">
                                                    <c:if test="${p.id == b.productId}">
                                                        ${p.name}
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                            
                                            
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getWarehouseId()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getSupplierInvoiceId()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getBatchCode()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getMfgDate()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getExpiryDate()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getQtyOnHand()}</td>
                                            <td class="px-6 py-4 text-sm text-gray-700">${b.getQtyReserved()}</td>
                                            <td class="px-6 py-4 text-sm text-center">
                                                <div style="display: flex; justify-content: center;">
                                                    <a href="#" class="text-green-600 hover:text-green-800 mr-3 transition"
                                                       data-id="${b.getId()}"
                                                       data-productid="${b.getProductId()}"
                                                       data-warehouseid="${b.getWarehouseId()}"
                                                       data-supplierinvoiceid="${b.getSupplierInvoiceId()}"
                                                       data-batchcode="${b.getBatchCode()}"
                                                       data-mfgdate="${b.getMfgDate()}"
                                                       data-expirydate="${b.getExpiryDate()}"
                                                       data-qtyonhand="${b.getQtyOnHand()}"
                                                       data-qtyreserved="${b.getQtyReserved()}"
                                                       onclick="handleUpdateClick(this)">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <form action="admin-batches" method="post">
                                                        <input type="hidden" name="deleteId" value="${b.getId()}">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button type="submit" class="text-red-600 hover:text-red-800 transition"
                                                                onclick="return confirm('Bạn có chắc chắn muốn xóa lô hàng này?')">
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

        <div id="addBatchModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>

                <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm lô hàng mới</h3>

                <form action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Sản phẩm <span class="text-red-500">*</span></label>
                        <select name="productId" required 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach var="p" items="${products}">
                                <option value="${p.getId()}">${p.getName()} (ID: ${p.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Kho hàng</label>
                        <select name="warehouseId" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="w" items="${warehouses}">
                                <option value="${w.getId()}">${w.getName()} (ID: ${w.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Hóa đơn nhà cung cấp</label>
                        <select name="supplierInvoiceId" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="si" items="${supplierInvoices}">
                                <option value="${si.getId()}">Invoice #${si.getId()}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <input type="text" name="batchCode" placeholder="Mã lô" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Ngày sản xuất</label>
                        <input type="date" name="mfgDate" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Ngày hết hạn</label>
                        <input type="date" name="expiryDate" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    </div>
                    
                    <input type="number" name="qtyOnHand" placeholder="Số lượng tồn" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    
                    <input type="number" name="qtyReserved" placeholder="Số lượng đặt trước" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                    <div class="col-span-2 flex justify-end gap-2 mt-4">
                        <button type="button" onclick="closeModal()" 
                                class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Hủy</button>
                        <button type="submit" 
                                class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="updateBatchModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>

                <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật lô hàng</h3>

                <form id="updateBatchForm" action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
                    <input type="hidden" name="batchId" id="updateBatchId">
                    <input type="hidden" name="action" value="update">

                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Sản phẩm <span class="text-red-500">*</span></label>
                        <select name="productId" id="updateProductId" required 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach var="p" items="${products}">
                                <option value="${p.getId()}">${p.getName()} (ID: ${p.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Kho hàng</label>
                        <select name="warehouseId" id="updateWarehouseId" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="w" items="${warehouses}">
                                <option value="${w.getId()}">${w.getName()} (ID: ${w.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Hóa đơn nhà cung cấp</label>
                        <select name="supplierInvoiceId" id="updateSupplierInvoiceId" 
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- Không chọn --</option>
                            <c:forEach var="si" items="${supplierInvoices}">
                                <option value="${si.getId()}">Invoice #${si.getId()}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <input type="text" name="batchCode" id="updateBatchCode" placeholder="Mã lô" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Ngày sản xuất</label>
                        <input type="date" name="mfgDate" id="updateMfgDate" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    </div>
                    
                    <div>
                        <label class="block text-sm text-gray-600 mb-1">Ngày hết hạn</label>
                        <input type="date" name="expiryDate" id="updateExpiryDate" required 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    </div>
                    
                    <input type="number" name="qtyOnHand" id="updateQtyOnHand" placeholder="Số lượng tồn" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                    
                    <input type="number" name="qtyReserved" id="updateQtyReserved" placeholder="Số lượng đặt trước" required 
                           class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                    <div class="col-span-2 flex justify-end gap-2 mt-4">
                        <button type="button" onclick="closeUpdateModal()"
                                class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Hủy</button>
                        <button type="submit"
                                class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Cập nhật</button>
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
                var id = el.getAttribute("data-id");
                var productId = el.getAttribute("data-productid");
                var warehouseId = el.getAttribute("data-warehouseid");
                var supplierInvoiceId = el.getAttribute("data-supplierinvoiceid");
                var batchCode = el.getAttribute("data-batchcode");
                var mfgDate = el.getAttribute("data-mfgdate");
                var expiryDate = el.getAttribute("data-expirydate");
                var qtyOnHand = el.getAttribute("data-qtyonhand");
                var qtyReserved = el.getAttribute("data-qtyreserved");

                document.getElementById("updateBatchId").value = id;
                document.getElementById("updateProductId").value = productId;
                document.getElementById("updateWarehouseId").value = warehouseId === "null" ? "" : warehouseId;
                document.getElementById("updateSupplierInvoiceId").value = supplierInvoiceId === "null" ? "" : supplierInvoiceId;
                document.getElementById("updateBatchCode").value = batchCode;
                document.getElementById("updateMfgDate").value = mfgDate;
                document.getElementById("updateExpiryDate").value = expiryDate;
                document.getElementById("updateQtyOnHand").value = qtyOnHand;
                document.getElementById("updateQtyReserved").value = qtyReserved;

                document.getElementById("updateBatchModal").classList.remove("hidden");
            }

            function closeUpdateModal() {
                document.getElementById("updateBatchModal").classList.add("hidden");
            }
        </script>
    </body>
</html>