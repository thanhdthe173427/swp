<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách hàng tồn kho</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>

    <style>
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
<body class="bg-gray-50" x-data="{ showReport: ${showReportModal == true} }">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="w-64 flex-shrink-0 sidebar-gradient text-gray-800">
        <div class="p-6">
            <h1 class="text-2xl font-bold flex items-center gap-2">
                <i class="fas fa-warehouse"></i> Admin Panel
            </h1>
        </div>

        <nav class="mt-6">
            <a href="admin-product" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                <i class="fas fa-box"></i> <span>Quản Lý Hàng Hóa</span>
            </a>
            <a href="admin-categories" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-chart-line"></i> <span>Quản lý Danh Mục</span>
            </a>
            <a href="admin-batches" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                <i class="fas fa-boxes"></i> <span>Quản Lý Lô Hàng</span>
            </a>
            <a href="warehouse" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                <i class="fa-solid fa-house"></i> <span>Kho Hàng</span>
            </a>
            <a href="#" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                <i class="fas fa-cog"></i> <span>Cài Đặt</span>
            </a>
        </nav>
    </aside>

    <!-- Main -->
    <main class="flex-1 overflow-auto">
        <header class="bg-white shadow-sm border-b border-gray-200">
            <div class="px-8 py-4 flex items-center justify-between">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Danh Sách Hàng Tồn Kho</h2>
                    <p class="text-gray-600 text-sm mt-1">Xem danh sách hàng trong kho</p>
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

            <div class="p-4 border-b border-gray-200 flex justify-between items-center">
                <div>
                    <h3 class="text-lg font-semibold text-gray-800">
                        Kho: <span class="text-[#D9534F]">${warehouse.name}</span> (${warehouse.code})
                    </h3>
                    <p class="text-sm text-gray-600">Địa chỉ: ${warehouse.address}</p>
                </div>

                <!-- 🔹 Nút Report -->
                <form action="inventory" method="get">
                    <input type="hidden" name="warehouseId" value="${warehouseId}" />
                    <input type="hidden" name="report" value="gen" />
                    <button type="submit"
                            class="bg-[#D9534F] hover:bg-[#c9302c] text-white font-semibold py-2 px-4 rounded-lg shadow transition">
                        <i class="fas fa-file-alt mr-2"></i> Xuất Báo Cáo
                    </button>
                </form>
            </div>

            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-[#F8D7DA] text-gray-800">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-semibold">ID</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Tên sản phẩm</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Số lượng tồn</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold">Ngày cập nhật</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-center">Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="i" items="${inventoryList}">
                            <tr class="table-row border-b border-gray-200">
                                <td class="px-6 py-4 text-sm font-medium text-gray-900">${i.id}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${i.productName}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${i.quantity}</td>
                                <td class="px-6 py-4 text-sm text-gray-700">${i.updatedAt}</td>
                                <td class="px-6 py-4 text-sm text-center">
                                    <span class="badge ${i.quantity > 0 ? 'badge-success' : 'badge-danger'}">
                                        ${i.quantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                                    </span>
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

<!-- 🔸 MODAL Báo cáo hàng sắp hết -->
<c:if test="${showReportModal}">
    <div class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-xl w-[700px] p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h2 class="text-xl font-bold text-gray-800">📉 Những mặt hàng sắp hết - Xem xét nhập thêm</h2>
                <a href="inventory?warehouseId=${warehouseId}" 
                   class="text-gray-500 hover:text-gray-700 text-2xl">&times;</a>
            </div>

            <div class="overflow-x-auto max-h-[400px] overflow-y-auto">
                <table class="w-full border border-gray-200">
                    <thead class="bg-[#F8D7DA] text-gray-800">
                    <tr>
                        <th class="px-4 py-2 text-left text-sm font-semibold">ID</th>
                        <th class="px-4 py-2 text-left text-sm font-semibold">Tên sản phẩm</th>
                        <th class="px-4 py-2 text-left text-sm font-semibold">Số lượng tồn</th>
                        <th class="px-4 py-2 text-left text-sm font-semibold">Ngày cập nhật</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${lowStockList}">
                        <tr class="border-b hover:bg-gray-50">
                            <td class="px-4 py-2 text-sm text-gray-800">${item.id}</td>
                            <td class="px-4 py-2 text-sm text-gray-700">${item.productName}</td>
                            <td class="px-4 py-2 text-sm text-gray-700">${item.quantity}</td>
                            <td class="px-4 py-2 text-sm text-gray-700">${item.updatedAt}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lowStockList}">
                        <tr><td colspan="4" class="text-center py-4 text-gray-500">🎉 Tất cả hàng trong kho đều đủ số lượng.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="flex justify-end mt-4">
                <a href="inventory?warehouseId=${warehouseId}"
                   class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-4 rounded-lg transition">
                    Đóng
                </a>
            </div>
        </div>
    </div>
</c:if>

</body>
</html>
