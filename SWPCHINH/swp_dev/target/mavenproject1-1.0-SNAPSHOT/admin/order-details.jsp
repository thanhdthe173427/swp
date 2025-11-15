<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Đơn Hàng - Admin</title>
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

    <!-- Sidebar -->
    <%@ include file="/Trang/sidebarAdmin.jsp" %>

    <!-- Main content -->
    <main class="flex-1 overflow-auto p-8">
        <%@ include file="/Trang/headerAdmin.jsp" %>

        <section class="max-w-6xl mx-auto">
            <!-- Header -->
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2">
                        <i class="fas fa-receipt"></i> Chi Tiết Đơn Hàng
                    </h2>
                    <p class="text-gray-500 text-sm mt-1">Thông tin chi tiết sản phẩm trong đơn hàng</p>
                </div>
                <a href="admin-orders" 
                   class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-5 py-2 rounded-lg shadow-sm flex items-center gap-2">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- Bảng đơn hàng -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-pink-100">
                <table class="w-full text-sm">
                    <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left font-semibold">Mã SP</th>
                            <th class="px-6 py-3 text-left font-semibold">Tên Sản Phẩm</th>
                            <th class="px-6 py-3 text-center font-semibold">Số Lượng</th>
                            <th class="px-6 py-3 text-right font-semibold">Đơn Giá</th>
                            <th class="px-6 py-3 text-right font-semibold">Giảm Giá</th>
                            <th class="px-6 py-3 text-right font-semibold">Thành Tiền</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-pink-50">
                    <c:forEach var="item" items="${orderItems}">
                        <tr class="hover:bg-pink-50">
                            <td class="px-6 py-4 font-medium text-gray-700">${item.id}</td>

                            <!-- Tên sản phẩm -->
                            <td class="px-6 py-4 text-gray-800">
                                <c:forEach var="p" items="${products}">
                                    <c:if test="${p.id == item.productId}">
                                        ${p.name}
                                    </c:if>
                                </c:forEach>
                            </td>

                            <td class="px-6 py-4 text-center">${item.quantity}</td>
                            <td class="px-6 py-4 text-right">
                                <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <fmt:formatNumber value="${item.discount}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td class="px-6 py-4 text-right font-semibold text-gray-800">
                                <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                    </c:forEach>


                    <c:if test="${empty orderItems}">
                            <tr>
                                <td colspan="6" class="py-6 text-center text-gray-500 italic">
                                    Không có sản phẩm nào trong đơn hàng này.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>

                    <!-- Tổng tiền -->
                    <tfoot class="bg-pink-50 border-t border-pink-100">
                        <tr>
                            <td colspan="5" class="text-right px-6 py-4 font-semibold text-gray-700">Tổng cộng:</td>
                            <td class="text-right px-6 py-4 font-bold text-pink-700 text-lg">
                                <fmt:formatNumber value="${orderTotal}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
