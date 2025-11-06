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


                <!-- Bảng danh sách đơn hàng -->
                <div class="bg-white rounded-xl shadow-md overflow-x-auto">
                    <table class="w-full border-collapse border">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 border">ID</th>
                                <th class="px-4 py-2 border">Sản phẩm</th>
                                <th class="px-4 py-2 border">Số lượng</th>
                                <th class="px-4 py-2 border">Đơn giá</th>
                                <th class="px-4 py-2 border">Giảm giá</th>
                                <th class="px-4 py-2 border">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${orderItems}">
                                <tr class="hover:bg-gray-100">
                                    <td class="px-4 py-2 border">${item.id}</td>
                                    <td class="px-4 py-2 border">${item.productName}</td>
                                    <td class="px-4 py-2 border">${item.quantity}</td>
                                    <td class="px-4 py-2 border">
                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td class="px-4 py-2 border">
                                        <fmt:formatNumber value="${item.discount}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td class="px-4 py-2 border text-right">
                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                </div>
                <a href="admin-orders" class="mt-4 inline-block px-4 py-2 bg-gray-300 rounded hover:bg-gray-400">Quay lại danh sách</a>
            </main>
        </div>

    </body>




</html>
