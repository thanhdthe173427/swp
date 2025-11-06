<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lô Hàng - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        /* Thêm style cho multi-select */
        select[multiple] {
            padding: 8px;
            height: auto;
        }

        select[multiple] option {
            padding: 4px 0;
            margin-bottom: 2px;
        }

        select[multiple] option:checked {
            background: linear-gradient(#4F46E5 0%, #4F46E5 100%);
            background-color: #4F46E5;
            color: white;
        }
    </style>
</head>
<body class="bg-gray-50">

    <!-- Sidebar -->
    <div class="flex h-screen">
        <div class="w-64 sidebar-gradient shadow-lg">
            <div class="p-6">
                <h2 class="text-2xl font-bold text-gray-800">Admin Panel</h2>
            </div>
            
            <nav class="mt-8 space-y-2 px-4">
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
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <div class="bg-white shadow">
                <div class="flex items-center justify-between px-8 py-4">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-800">Quản Lý Lô Hàng</h1>
                        <p class="text-gray-600">Quản lý và theo dõi lô hàng của bạn</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-purple-400 to-pink-600 flex items-center justify-center text-white font-bold">
                            A
                        </div>
                        <span class="text-gray-700 font-medium">Admin User</span>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="p-8">
                <!-- Action Button -->
    <button onclick="openModal()" 
                            class="bg-[#F8D7DA] text-gray-800 px-6 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition font-medium flex items-center gap-2 shadow-sm">
                        <i class="fas fa-plus"></i> Thêm lô hàng
                    </button>
                <!-- Table -->
                <div class="bg-white rounded-lg shadow overflow-hidden">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b">
                            <tr>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">ID</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Mã Nguyên Liệu</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Tên Nguyên Liệu</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Mã Kho</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Nhà cung cấp</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Mã Lô</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Ngày nhập hàng</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">SL nhập vào</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">SL tồn</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y">
                            <c:forEach var="b" items="${batches}">
                                <tr class="table-row">
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getId()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getMaterialId()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">
                                        <span class="font-medium">${b.materialName}</span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getWarehouseId()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getSupplierName()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getBatchCode()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">${b.getMfgDate()}</td>
                                    <td class="px-6 py-4 text-sm text-gray-700">
                                        <span class="badge badge-warning">${b.getQtyReserved()}</span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-700">
                                        <span class="badge badge-success">${b.getQtyOnHand()}</span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-700">
                                        <button onclick="handleUpdateClick(this)" 
                                                data-id="${b.getId()}"
                                                data-productid="${b.getMaterialId()}"
                                                data-warehouseid="${b.getWarehouseId()}"
                                                data-supplierid="${b.getSupplierId()}"
                                                data-batchcode="${b.getBatchCode()}"
                                                data-mfgdate="${b.getMfgDate()}"
                                                data-qtyreserved="${b.getQtyReserved()}"
                                                class="text-purple-600 hover:text-purple-800 font-medium">
                                            <i class="fas fa-edit mr-1"></i> Sửa
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Modal -->
    <div id="addBatchModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl p-6 relative max-h-[90vh] overflow-y-auto">
            <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                <i class="fas fa-times"></i>
            </button>

            <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm lô hàng mới</h3>

            <form id="addBatchForm" action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
                <input type="hidden" name="action" value="add">

                <!-- Add searchable multi-select for products -->
                <div class="col-span-2">
                    <label class="block text-sm text-gray-600 mb-1">Sản phẩm <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input 
                            type="text" 
                            id="addProductSearch" 
                            placeholder="Tìm kiếm sản phẩm theo tên..." 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none mb-2"
                            oninput="filterAddProductOptions()">
                        <select 
                            name="productId" 
                            id="addProductId" 
                            multiple
                            required 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none min-h-32"
                            style="overflow-y: auto;">
                            <c:forEach var="p" items="${products}">
                                <option value="${p.getId()}" data-name="${p.getName()}">${p.getName()} (ID: ${p.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <small class="text-gray-500 block mt-1">💡 Giữ phím Ctrl (Cmd trên Mac) để chọn nhiều sản phẩm</small>
                </div>

                <div>
                    <label class="block text-sm text-gray-600 mb-1">Kho hàng</label>
                    <select name="warehouseId" id="addWarehouseId"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                        <option value="">-- Không chọn --</option>
                        <c:forEach var="w" items="${warehouses}">
                            <option value="${w.getId()}">${w.getName()} (ID: ${w.getId()})</option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="block text-sm text-gray-600 mb-1">Nhà cung cấp</label>
                    <select name="supplierId" id="addSupplierId"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                        <option value="">-- Không chọn --</option>
                        <c:forEach var="s" items="${suppliers}">
                            <option value="${s.id}">${s.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <input type="text" name="batchCode" id="addBatchCode" placeholder="Mã lô" required 
                       class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                <div>
                    <label class="block text-sm text-gray-600 mb-1">Ngày sản xuất</label>
                    <input type="date" name="mfgDate" id="addMfgDate" required 
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                </div>

                <input type="number" name="qtyReserved" id="addQtyReserved" placeholder="Số lượng nhập vào" required 
                       class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                <div class="col-span-2 flex justify-end gap-2 mt-4">
                    <button type="button" onclick="closeModal()" 
                            class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition">Hủy</button>
                    <button type="submit" 
                            class="px-4 py-2 rounded-lg bg-gradient-to-r from-purple-400 to-pink-600 text-white font-medium hover:shadow-lg transition">Thêm</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Update Modal -->
    <div id="updateBatchModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl p-6 relative max-h-[90vh] overflow-y-auto">
            <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                <i class="fas fa-times"></i>
            </button>

            <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật lô hàng</h3>

            <form id="updateBatchForm" action="admin-batches" method="post" class="grid grid-cols-2 gap-4">
                <input type="hidden" name="batchId" id="updateBatchId">
                <input type="hidden" name="action" value="update">

                <!-- Update searchable multi-select for products -->
                <div class="col-span-2">
                    <label class="block text-sm text-gray-600 mb-1">Nguyên liệu <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input 
                            type="text" 
                            id="updateProductSearch" 
                            placeholder="Tìm kiếm nguyên liệu theo tên..." 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none mb-2"
                            oninput="filterUpdateProductOptions()">
                        <select 
                            name="productId" 
                            id="updateProductId" 
                            multiple
                            required 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none min-h-32"
                            style="overflow-y: auto;">
                            <c:forEach var="p" items="${products}">
                                <option value="${p.getId()}" data-name="${p.getName()}">${p.getName()} (ID: ${p.getId()})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <small class="text-gray-500 block mt-1">💡 Giữ phím Ctrl (Cmd trên Mac) để chọn nhiều nguyên liệu</small>
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
                    <label class="block text-sm text-gray-600 mb-1">Nhà cung cấp</label>
                    <select name="supplierId" id="updateSupplierId"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
                        <option value="">-- Không chọn --</option>
                        <c:forEach var="s" items="${suppliers}">
                            <option value="${s.id}">${s.name}</option>
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

                <input type="number" name="qtyReserved" id="updateQtyReserved" placeholder="Số lượng nhập vào" required 
                       class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

                <div class="col-span-2 flex justify-end gap-2 mt-4">
                    <button type="button" onclick="closeUpdateModal()" 
                            class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 font-medium hover:bg-gray-300 transition">Hủy</button>
                    <button type="submit" 
                            class="px-4 py-2 rounded-lg bg-gradient-to-r from-purple-400 to-pink-600 text-white font-medium hover:shadow-lg transition">Cập nhật</button>
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
            document.getElementById("addProductSearch").value = "";
        }

        function handleUpdateClick(el) {
            var id = el.getAttribute("data-id");
            var productId = el.getAttribute("data-productid");
            var warehouseId = el.getAttribute("data-warehouseid");
            var supplierId = el.getAttribute("data-supplierid");
            var batchCode = el.getAttribute("data-batchcode");
            var mfgDate = el.getAttribute("data-mfgdate");
            var qtyReserved = el.getAttribute("data-qtyreserved");

            document.getElementById("updateBatchId").value = id;
            document.getElementById("updateProductId").value = productId;
            document.getElementById("updateWarehouseId").value = warehouseId === "null" ? "" : warehouseId;
            document.getElementById("updateSupplierId").value = supplierId === "null" ? "" : supplierId;
            document.getElementById("updateBatchCode").value = batchCode;
            document.getElementById("updateMfgDate").value = mfgDate;
            document.getElementById("updateQtyReserved").value = qtyReserved;

            document.getElementById("updateBatchModal").classList.remove("hidden");
        }

        function closeUpdateModal() {
            document.getElementById("updateBatchModal").classList.add("hidden");
            document.getElementById("updateProductSearch").value = "";
        }

        function filterAddProductOptions() {
            const searchInput = document.getElementById("addProductSearch").value.toLowerCase();
            const selectElement = document.getElementById("addProductId");
            const options = selectElement.querySelectorAll("option");

            options.forEach(option => {
                const optionName = option.getAttribute("data-name").toLowerCase();
                if (optionName.includes(searchInput) || searchInput === "") {
                    option.style.display = "block";
                } else {
                    option.style.display = "none";
                }
            });
        }

        function filterUpdateProductOptions() {
            const searchInput = document.getElementById("updateProductSearch").value.toLowerCase();
            const selectElement = document.getElementById("updateProductId");
            const options = selectElement.querySelectorAll("option");

            options.forEach(option => {
                const optionName = option.getAttribute("data-name").toLowerCase();
                if (optionName.includes(searchInput) || searchInput === "") {
                    option.style.display = "block";
                } else {
                    option.style.display = "none";
                }
            });
        }
    </script>
</body>
</html>
