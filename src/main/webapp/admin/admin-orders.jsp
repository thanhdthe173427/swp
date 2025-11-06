<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Đơn Hàng - Admin</title>
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

            <!-- Main -->
            <main class="flex-1 overflow-auto p-8">
                <h2 class="text-2xl font-bold mb-4">Quản Lý Đơn Hàng</h2>

                <!-- Form tìm kiếm -->
                <form action="admin-orders" method="get" class="mb-4 flex gap-2">
                    <input type="text" name="search" value="${search}" placeholder="Tìm theo mã đơn, khách hàng, SĐT..."
                           class="px-4 py-2 border rounded-lg w-72">
                    <button type="submit" class="bg-[#F8D7DA] px-4 py-2 rounded-lg hover:bg-[#F1A7A7]">Tìm</button>
                </form>

                <!-- Bảng danh sách đơn hàng -->
                <div class="bg-white rounded-xl shadow-md overflow-x-auto">
                    <table class="w-full border-collapse">
                        <thead class="bg-[#F8D7DA]">
                            <tr>
                                <th class="px-4 py-3 text-left">Mã Đơn</th>
                                <th class="px-4 py-3 text-left">Khách Hàng</th>
                                <th class="px-4 py-3 text-left">SĐT</th>
                                <th class="px-4 py-3 text-left">Trạng Thái</th>
                                <th class="px-4 py-3 text-left">Thanh Toán</th>
                                <th class="px-4 py-3 text-right">Tổng Tiền</th>
                                <th class="px-4 py-3 text-left">Ngày Đặt</th>
                                <th class="px-4 py-3 text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="px-4 py-3">${o.orderCode}</td>
                                    <td class="px-4 py-3">${o.customerName}</td>
                                    <td class="px-4 py-3">${o.customerPhone}</td>
                                    <td class="px-4 py-3">${o.status}</td>
                                    <td class="px-4 py-3">${o.paymentStatus}</td>
                                    <td class="px-4 py-3 text-right">
                                        <fmt:formatNumber value="${o.grandTotal}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td class="px-4 py-3">
                                        <fmt:formatDate value="${o.placedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <a href="admin-orders?action=view&orderId=${o.id}"
                                           class="text-blue-600 hover:text-blue-800">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                    </td>




                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div id="orderDetailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl shadow-xl w-[700px] p-6">
                <div class="flex justify-between items-center border-b pb-3 mb-4">
                    <h2 class="text-xl font-bold text-gray-800">Chi tiết đơn hàng</h2>
                    <button id="closeModalBtn" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
                </div>

                <div id="orderModalContent" class="overflow-x-auto max-h-[400px] overflow-y-auto">
                    <!-- Nội dung sẽ được load bằng JS -->
                </div>

                <div class="flex justify-end mt-4">
                    <button id="closeModalBtn2" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold py-2 px-4 rounded-lg transition">
                        Đóng
                    </button>
                </div>
            </div>
        </div>




    </body>


    <script>
        function openOrderModal(orderId) {
            console.log(orderId);
            fetch(`admin-orders?action=view&orderId=${orderId}`)
                    .then(res => res.text())
                    .then(html => {
                        // Inject dữ liệu vào modal
                        document.getElementById('orderModalContent').innerHTML = html;
                        // Hiển thị modal
                        document.getElementById('orderDetailModal').classList.remove('hidden');
                    })
                    .catch(err => console.error(err));
        }

// Ẩn modal khi click nút đóng
        document.getElementById('closeModalBtn').onclick = function () {
            document.getElementById('orderDetailModal').classList.add('hidden');
        }

        document.getElementById('closeModalBtn2').onclick = function () {
            document.getElementById('orderDetailModal').classList.add('hidden');
        }

    </script>



</html>
