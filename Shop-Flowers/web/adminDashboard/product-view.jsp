<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Hàng Hóa - Admin Dashboard</title>
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
                    <a href="admin-product" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                        <i class="fas fa-box"></i>
                        <span>Quản Lý Hàng Hóa</span>
                    </a>
                    <a href="admin-categories" class="flex items-center gap-3 px-6 py-3 hover:bg-white hover:bg-opacity-40 transition text-gray-800">
                        <i class="fas fa-chart-line"></i>
                        <span>Quản lý Danh Mục</span>
                    </a>
                    <a href="admin-batches" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                        <i class="fas fa-boxes"></i>
                        <span>Quản Lý Lô Hàng</span>
                    </a>
                    <a href="warehouse" class="flex items-center gap-3 px-6 py-3 bg-white bg-opacity-50 border-l-4 border-gray-600 text-gray-900 hover:bg-opacity-70 transition">
                        <i class="fa-solid fa-house"></i>
                        <span>Kho Hàng</span>
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
                            <h2 class="text-2xl font-bold text-gray-800">Quản Lý Hàng Hóa</h2>
                            <p class="text-gray-600 text-sm mt-1">Quản lý và theo dõi kho hàng của bạn</p>
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
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

                    </div>

                    <button onclick="openModal()" 
                            class="bg-[#F8D7DA] text-gray-800 px-6 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition font-medium flex items-center gap-2 shadow-sm">
                        <i class="fas fa-plus"></i> Thêm sản phẩm
                    </button>


                </div>

                <form action="admin-product" method="get">
                    <div class="bg-white rounded-xl shadow-md p-4 mb-6">
                        <div class="relative">
                            <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input name="search" type="text" id="searchInput" value="${search}" placeholder="Tìm kiếm sản phẩm theo mô ta hoặc tên..." 
                                   class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent outline-none">

                        </div>
                        <br/>      
                        <select name="product_type"
                                class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none"
                                required>
                            <option value="all" ${type == 'all' ? 'selected' : ''}>Tất cả</option>
                            <option value="flowers" ${type == 'flowers' ? 'selected' : ''}>Flowers</option>
                            <option value="accessory" ${type == 'accessory' ? 'selected' : ''}>Accessory</option>
                        </select>
                        <button type="submit"
                                class="ml-2 bg-[#F8D7DA] text-gray-800 px-4 py-2 rounded-lg border border-[#F1A7A7] hover:bg-[#F1A7A7] transition shadow-sm">
                            Lọc
                        </button>
                    </div>
                </form>

                <div class="bg-white rounded-xl shadow-md overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-[#F8D7DA] text-gray-800">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Mã Hàng</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Tên Sản Phẩm</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Mô tả</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Giá bán (VNĐ)</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Giá cost (VNĐ)</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">tồn kho trong tất cả lô hàng</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">số lượng lô hàng chứa sản phẩm</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold">Kho hàng</th>
                                    <th class="px-6 py-4 text-center text-sm font-semibold">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${products}">
                                    <tr class="table-row border-b border-gray-200">
                                        <td class="px-6 py-4 text-sm font-medium text-gray-900">${p.getId()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getName()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getDescription()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getBasePrice()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getCostPrice()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getTotalQty()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getTotalBatches()}</td>
                                        <td class="px-6 py-4 text-sm text-gray-700">${p.getWarehouses()}</td>
                                        
                                        <td class="px-6 py-4 text-sm text-center">
                                            <div style="display: flex;">
                                                <a href="#" class="text-green-600 hover:text-green-800 mr-4 transition"
                                                   onclick='openUpdateModal({
                                                               id: "${p.getId()}",
                                                               isAccessory: ${p.isIsAccessory()},
                                                               categoryId: "${p.getCategoryId()}",
                                                               name: "${p.getName()}",
                                                               description: "${p.getDescription()}",
                                                               basePrice: "${p.getBasePrice()}",
                                                               unit: "${p.getUnit()}",
                                                               costPrice: "${p.getCostPrice()}"
                                                           })'>
                                                    <i class="fas fa-edit"></i>
                                                </a>


                                                <form action="admin-product" method="post">
                                                    <input type="hidden" name="deleteId" value="${p.getId()}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <button type="submit" class="text-red-600 hover:text-red-800 transition"
                                                            onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
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
<div id="addProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <!-- Nút đóng -->
        <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Thêm sản phẩm mới</h3>

        <form action="admin-product" method="post" class="grid grid-cols-1 gap-4">

            <select name="product_type_create" 
                    class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none"
                    required>
                <option value="">--Chọn loại hàng--</option>
                <option value="flowers">Flowers</option>
                <option value="accessory">Accessory</option>
            </select>

            <select name="categoryId" 
                    class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none" 
                    required>
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.getId()}">${c.getName()}</option>
                </c:forEach>   
            </select>


            <input type="text" name="name" placeholder="Tên sản phẩm" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <!--      <input type="text" name="material" placeholder="Nguyên liệu" required 
                         class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">-->
            <input type="text" name="description" placeholder="mô tả" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="number" name="basePrice" placeholder="Giá bán (VNĐ)" required min="0"
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="number" name="costPrice" placeholder="Giá cost (VNĐ)" required min="0"
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="text" name="unit" placeholder="Đơn vị" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeModal()" 
                        class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f29c9c] transition">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Form Update Product Modal -->
<div id="updateProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg p-6 relative">
        <!-- Nút đóng -->
        <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
        </button>

        <h3 class="text-xl font-bold text-gray-800 mb-4">Cập nhật sản phẩm</h3>


        <form id="updateProductForm" action="admin-product" method="post" class="grid grid-cols-1 gap-4">
            <input type="hidden" name="productId" id="updateProductId">
            <input type="hidden" name="action" value="update">

            <select name="product_type_update" id="updateType" 
                    class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none"
                    required>
                <option value="">--Chọn loại hàng--</option>
                <option value="flowers" ${p.isIsAccessory() ? "" : "selected"}>Flowers</option>
                <option value="accessory" ${p.isIsAccessory() ? "selected" : ""}>Accessory</option>
            </select>

            <select name="categoryId" id="updateCategoryId"
                    class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none"
                    required>
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.getId()}">${c.getName()}</option> <!-- value = id, hiển thị = name -->
                </c:forEach>
            </select>

            <input type="text" name="name" id="updateName" placeholder="Tên sản phẩm" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="text" name="description" id="updateDescription" placeholder="Mô tả" required
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="number" name="basePrice" id="updateBasePrice" placeholder="Giá bán (VNĐ)" required min="0"
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="number" name="costPrice" id="updateCostPrice" placeholder="Giá cost (VNĐ)" required min="0"
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">
            <input type="text" name="unit" id="updateUnit" placeholder="Đơn vị" required 
                   class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 outline-none">

            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg bg-[#F5B5B5] text-gray-800 font-medium hover:bg-[#f29c9c] transition">Hủy</button>
                <button type="submit" onclick="closeUpdateModal()"
                        class="px-4 py-2 rounded-lg bg-[#F8D7DA] text-gray-800 font-medium hover:bg-[#f5b5bb] transition">Cập nhật</button>
            </div>
        </form>
    </div>
</div>








<script>
    function openModal() {
        document.getElementById("addProductModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("addProductModal").classList.add("hidden");
    }

    function openUpdateModal(product) {
        // Set giá trị hiện tại của sản phẩm vào form
        document.getElementById("updateProductId").value = product.id;
        document.getElementById("updateCategoryId").value = product.categoryId;
        document.getElementById("updateName").value = product.name;
        document.getElementById("updateDescription").value = product.description;
        document.getElementById("updateBasePrice").value = product.basePrice;
        document.getElementById("updateCostPrice").value = product.costPrice;
        document.getElementById("updateUnit").value = product.unit;
        const isAcc = product.isAccessory === true || product.isAccessory === "true";
        document.getElementById("updateType").value = isAcc ? "accessory" : "flowers";
        // Hiện popup
        document.getElementById("updateProductModal").classList.remove("hidden");
    }

    function closeUpdateModal() {
        document.getElementById("updateProductModal").classList.add("hidden");
    }
</script>


</body>
</html>