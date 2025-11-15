<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng - Admin</title>
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
        <%@ include file="/Trang/sidebarAdmin.jsp" %> <!-- ✅ Sidebar -->
        <main class="flex-1 overflow-auto">
            <%@ include file="/Trang/headerAdmin.jsp" %> <!-- ✅ Header -->

            <section class="p-8">
                <div class="flex justify-between items-center mb-8">
                    <div>
                        <h2 class="text-3xl font-bold text-pink-700">📦 Quản Lý Đơn Hàng</h2>
                        <p class="text-gray-500 text-sm mt-1">Theo dõi và xử lý các đơn hàng của khách</p>
                    </div>
                    <div class="text-sm text-gray-500 italic">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="'Hôm nay: 'dd/MM/yyyy" />
                    </div>
                </div>

                <!-- 🔍 Form tìm kiếm -->
                <form action="admin-orders" method="get" class="mb-8 flex items-center gap-3">
                    <div class="relative w-80">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" name="search" value="${search}" placeholder="Tìm theo mã đơn, khách hàng, SĐT..."
                               class="pl-10 pr-4 py-2 border border-pink-200 rounded-lg w-full focus:ring-2 focus:ring-pink-300 shadow-sm">
                    </div>
                    <button type="submit" 
                            class="btn-primary px-5 py-2 rounded-lg text-gray-800 font-medium shadow-sm hover:shadow-md flex items-center gap-2">
                        <i class="fas fa-search"></i> Tìm
                    </button>
                </form>

                <!-- 📋 Bảng danh sách đơn hàng -->
                <div class="bg-white rounded-2xl shadow-lg overflow-x-auto border border-pink-100">
                    <table class="w-full text-sm">
                        <thead class="bg-gradient-to-r from-pink-100 to-pink-200 text-gray-700">
                            <tr>
                                <th class="px-6 py-3 text-left font-semibold">Mã Đơn</th>
                                <th class="px-6 py-3 text-left font-semibold">Khách Hàng</th>
                                <th class="px-6 py-3 text-left font-semibold">SĐT</th>
                                <th class="px-6 py-3 text-left font-semibold">Trạng Thái</th>
                                <th class="px-6 py-3 text-left font-semibold">Thanh Toán</th>
                                <th class="px-6 py-3 text-right font-semibold">Tổng Tiền</th>
                                <th class="px-6 py-3 text-left font-semibold">Ngày Đặt</th>
                                <th class="px-6 py-3 text-center font-semibold">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-pink-100">
                            <c:forEach var="o" items="${orders}">
                                <tr class="hover:bg-pink-50 transition">
                                    <td class="px-6 py-4 font-medium text-gray-800">${o.orderCode}</td>
                                    <td class="px-6 py-4">${o.customerName}</td>
                                    <td class="px-6 py-4">${o.customerPhone}</td>

                                    <!-- Trạng thái -->
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${o.status eq 'Đang xử lý'}">
                                                <span class="bg-yellow-100 text-yellow-800 px-3 py-1 rounded-full text-xs font-semibold">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${o.status eq 'Hoàn thành'}">
                                                <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-xs font-semibold">Hoàn thành</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-gray-200 text-gray-700 px-3 py-1 rounded-full text-xs font-semibold">${o.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Thanh toán -->
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${o.paymentStatus eq 'Paid'}">
                                                <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-semibold">Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-semibold">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="px-6 py-4 text-right font-semibold text-gray-800">
                                        <fmt:formatNumber value="${o.grandTotal}" type="currency" currencySymbol="₫"/>
                                    </td>

                                    <td class="px-6 py-4 text-gray-600">
                                        <fmt:formatDate value="${o.placedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>

                                    <td class="px-6 py-4 text-center">
                                        <a href="admin-orders?action=view&orderId=${o.id}"
                                           class="text-blue-600 hover:text-blue-800 font-medium flex items-center gap-1 mx-auto">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="8" class="text-center text-gray-500 py-6 italic">
                                        Không tìm thấy đơn hàng nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- 🪟 Modal Chi tiết Đơn hàng -->
    <div id="orderDetailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-2xl shadow-2xl w-[750px] p-6 relative">
            <button id="closeModalBtn" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            <div class="border-b pb-3 mb-4">
                <h2 class="text-2xl font-bold text-pink-700 flex items-center gap-2">
                    <i class="fas fa-receipt"></i> Chi tiết đơn hàng
                </h2>
            </div>

            <div id="orderModalContent" class="overflow-x-auto max-h-[450px] overflow-y-auto text-sm text-gray-700">
                <!-- Nội dung load bằng JS -->
            </div>

            <div class="flex justify-end mt-4">
                <button id="closeModalBtn2" 
                        class="px-5 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium">Đóng</button>
            </div>
        </div>
    </div>

    <script>
        function openOrderModal(orderId) {
            fetch("admin-orders?action=view&orderId=" + orderId)
                .then(res => res.text())
                .then(html => {
                    document.getElementById('orderModalContent').innerHTML = html;
                    document.getElementById('orderDetailModal').classList.remove('hidden');
                })
                .catch(err => console.error(err));
        }

        document.getElementById('closeModalBtn').onclick = () =>
            document.getElementById('orderDetailModal').classList.add('hidden');
        document.getElementById('closeModalBtn2').onclick = () =>
            document.getElementById('orderDetailModal').classList.add('hidden');
    </script>
</body>
</html>
