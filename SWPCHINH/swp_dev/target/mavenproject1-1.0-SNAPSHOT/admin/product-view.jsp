<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Hàng Hóa - Admin Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            * {
                transition: all 0.25s ease-in-out;
            }
            ::-webkit-scrollbar {
                width: 6px;
            }
            ::-webkit-scrollbar-thumb {
                background-color: #f3a7b8;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background-color: #e17c8e;
            }

            /* Thêm style để label hiển thị đẹp hơn */
            .form-group {
                /* Bỏ margin-bottom vì đã dùng 'grid gap-4' trong form */
            }
            .form-label {
                display: block;
                margin-bottom: 0.25rem;
                font-size: 0.875rem; /* text-sm */
                font-weight: 500; /* font-medium */
                color: #374151; /* text-gray-700 */
            }
            .form-input {
                width: 100%;
                border: 1px solid #fbcfe8; /* border-pink-200 */
                border-radius: 0.5rem; /* rounded-lg */
                padding: 0.5rem 1rem; /* px-4 py-2 */
                box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05); /* shadow-sm */
            }
            .form-input:focus {
                outline: 2px solid transparent;
                outline-offset: 2px;
                border-color: #f9a8d4; /* ring-pink-300 */
                box-shadow: 0 0 0 2px #f9a8d4; /* ring-2 */
            }
            .form-input:disabled, .form-input[readonly] {
                background-color: #f3f4f6; /* bg-gray-100 */
                cursor: not-allowed;
            }
        </style>
    </head>

    <body class="bg-gradient-to-r from-pink-50 via-white to-pink-100 text-gray-700">
        <div class="flex min-h-screen">

            <%@ include file="/Trang/sidebarAdmin.jsp" %>

            <main class="flex-1 overflow-auto">
                <%@ include file="/Trang/headerAdmin.jsp" %>

                <section class="p-8">

                    <%-- Flash Message (Thông báo) --%>
                    <c:if test="${not empty message}">
                        <div id="flashMessage" class="mb-4 p-4 rounded-lg
                             ${messageType == 'success' ? 'bg-green-100 text-green-700' : ''}
                             ${messageType == 'error' ? 'bg-red-100 text-red-700' : ''}"
                             role="alert">
                            <span class="font-medium">${message}</span>
                        </div>
                        <script>
                            // Tự động ẩn thông báo sau 5 giây
                            setTimeout(function () {
                                var flashMessage = document.getElementById('flashMessage');
                                if (flashMessage) {
                                    flashMessage.style.transition = 'opacity 0.5s ease';
                                    flashMessage.style.opacity = '0';
                                    setTimeout(function () {
                                        flashMessage.style.display = 'none';
                                    }, 500);
                                }
                            }, 5000);
                        </script>
                    </c:if>

                    <%-- Header trang --%>
                    <div class="flex justify-between items-center mb-8">
                        <div>
                            <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2">
                                <i class="fas fa-box"></i> Quản Lý Hàng Hóa
                            </h2>
                            <p class="text-gray-500 text-sm mt-1">Theo dõi và cập nhật thông tin sản phẩm</p>
                        </div>
                        <button onclick="openModal()"
                                class="bg-gradient-to-r from-pink-300 to-pink-400 hover:from-pink-400 hover:to-pink-500 text-white font-medium px-5 py-2 rounded-lg shadow-md flex items-center gap-2">
                            <i class="fas fa-plus"></i> Thêm sản phẩm
                        </button>
                    </div>

                    <%-- Form Lọc và Tìm kiếm --%>
                    <form action="admin-product" method="get" class="mb-8 flex items-center gap-3 flex-wrap bg-white rounded-xl shadow p-4">
                        <div class="relative w-80">
                            <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input name="search" type="text" value="${search}" placeholder="Tìm theo tên hoặc mô tả..."
                                   class="pl-10 pr-4 py-2 border border-pink-200 rounded-lg w-full focus:ring-2 focus:ring-pink-300 shadow-sm">
                        </div>

                        <select name="product_type" class="px-4 py-2 border border-pink-200 rounded-lg focus:ring-2 focus:ring-pink-300 shadow-sm">
                            <option value="all" ${type == 'all' ? 'selected' : ''}>Tất cả</option>
                            <option value="flowers" ${type == 'flowers' ? 'selected' : ''}>Flowers</option>
                            <option value="accessory" ${type == 'accessory' ? 'selected' : ''}>Accessory</option>
                        </select>

                        <button type="submit" class="bg-pink-200 hover:bg-pink-300 text-gray-800 px-5 py-2 rounded-lg shadow-sm font-medium">
                            <i class="fas fa-filter"></i> Lọc
                        </button>
                    </form>

                    <%-- Bảng danh sách sản phẩm --%>
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-pink-100">
                        <table class="w-full text-sm">
                            <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
                                <tr>
                                    <th class="px-6 py-3 text-left font-semibold">Ảnh</th> <%-- ✅ THÊM MỚI --%>
                                    <th class="px-6 py-3 text-left font-semibold">Mã SP</th>
                                    <th class="px-6 py-3 text-left font-semibold">Tên Sản Phẩm</th>
                                    <th class="px-6 py-3 text-left font-semibold">Mô Tả</th>
                                    <th class="px-6 py-3 text-left font-semibold">Số lượng</th>
                                    <th class="px-6 py-3 text-left font-semibold">Giá Bán (₫)</th>
                                    <th class="px-6 py-3 text-left font-semibold">Giá Cost (₫)</th>
                                    <th class="px-6 py-3 text-left font-semibold">Trạng Thái</th>
                                    <th class="px-6 py-3 text-center font-semibold">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-pink-50">
                                <c:forEach var="p" items="${products}">
                                    <tr class="hover:bg-pink-50 ${!p.isIsActive() ? 'opacity-60 bg-gray-50' : ''}">

                                        <%-- ✅ THÊM MỚI: Cột Ảnh --%>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty p.getUrl()}">
                                                    <img src="${p.getUrl()}" alt="${p.getName()}" class="w-16 h-16 object-cover rounded-md border border-pink-100">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="w-16 h-16 flex items-center justify-center bg-gray-100 rounded-md text-gray-400">
                                                        <i class="fas fa-image text-2xl"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="px-6 py-4 font-medium text-gray-800">${p.getId()}</td>
                                        <td class="px-6 py-4 text-gray-700">${p.getName()}</td>
                                        <td class="px-6 py-4 text-gray-600">${p.getDescription()}</td>
                                        <td class="px-6 py-4 text-gray-600">${p.getQuantity()}</td>
                                        <td class="px-6 py-4 text-gray-700">${p.getBasePrice()}</td>
                                        <td class="px-6 py-4 text-gray-700">${p.getCostPrice()}</td>
                                        <td class="px-6 py-4">
                                            <c:if test="${p.isIsActive()}">
                                                <span class="px-3 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">Hoạt động</span>
                                            </c:if>
                                            <c:if test="${!p.isIsActive()}">
                                                <span class="px-3 py-1 text-xs font-medium rounded-full bg-gray-200 text-gray-700">Đã ẩn</span>
                                            </c:if>
                                        </td>

                                        <td class="px-6 py-4 text-center">
                                            <div class="flex justify-center gap-4">

                                                <%-- Nút Sửa (Mở Modal Update) --%>
                                                <a href="#" class="text-green-600 hover:text-green-800 transition text-lg"
                                                   title="Sửa"
                                                   onclick='openUpdateModal({
                                                               id: "${p.getId()}",
                                                               isAccessory: ${p.isIsActive()},
                                                               categoryId: "${p.getCategoryId()}",
                                                               name: "${p.getName()}",
                                                               description: "${p.getDescription()}",
                                                               basePrice: "${p.getBasePrice()}",
                                                               unit: "${p.getUnit()}",
                                                               costPrice: "${p.getCostPrice()}",
                                                               quantity: "${p.getQuantity()}",
                                                               url: "${p.getUrl()}" <%-- ✅ THÊM MỚI: Truyền URL --%>
                                                           })'>
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <%-- Nút Ẩn (Delete mềm) --%>
                                                <c:if test="${p.isIsActive()}">
                                                    <form action="admin-product" method="post" onsubmit="return confirmDelete(true)">
                                                        <input type="hidden" name="deleteId" value="${p.getId()}">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button type="submit" class="transition text-lg text-red-500 hover:text-red-700" title="Ẩn sản phẩm">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <%-- Nút Khôi phục --%>
                                                <c:if test="${!p.isIsActive()}">
                                                    <form action="admin-product" method="post" onsubmit="return confirm('Bạn có chắc muốn khôi phục sản phẩm này?')">
                                                        <input type="hidden" name="restoreId" value="${p.getId()}">
                                                        <input type="hidden" name="action" value="restore">
                                                        <button type="submit" class="transition text-lg text-blue-500 hover:text-blue-700" title="Khôi phục">
                                                            <i class="fas fa-undo-alt"></i>
                                                        </button>
                                                    </form>

                                                    <%-- Nút Xóa vĩnh viễn (Delete cứng) --%>
                                                    <form action="admin-product" method="post" onsubmit="return confirmDelete(false)">
                                                        <input type="hidden" name="deleteId" value="${p.getId()}">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button type="submit" class="transition text-lg text-gray-700 hover:text-red-900" title="Xóa vĩnh viễn">
                                                            <i class="fas fa-skull-crossbones"></i>
                                                        </button>
                                                    </form>
                                                </c:if>

                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <%-- Trường hợp không có sản phẩm nào --%>
                                <c:if test="${empty products}">
                                    <tr>
                                        <%-- ✅ CẬP NHẬT: colspan = 9 (vì thêm cột ảnh) --%>
                                        <td colspan="9" class="py-6 text-center text-gray-500 italic">
                                            Không tìm thấy sản phẩm nào.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </section>
            </main>
        </div>

        <%-- =============================================== --%>
        <%-- 🔹 MODAL THÊM SẢN PHẨM (ĐÃ THÊM LABEL VÀ URL) --%>
        <%-- =============================================== --%>
        <div id="addProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 overflow-auto py-10">
            <%-- Thêm overflow-auto và py-10 để cuộn nếu nội dung dài --%>
            <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-8 relative">
                <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>

                <h3 class="text-xl font-bold text-pink-700 mb-6">Thêm Sản Phẩm Mới</h3>

                <%-- Sử dụng grid và gap-4 để các form-group tự cách đều --%>
                <form action="admin-product" method="post" class="grid grid-cols-2 gap-4">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="addType" class="form-label">Loại hàng *</label>
                        <select name="product_type_create" id="addType" class="form-input" required>
                            <option value="">-- Chọn loại hàng --</option>
                            <option value="flowers">Flowers</option>
                            <option value="accessory">Accessory</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="addCategory" class="form-label">Danh mục *</label>
                        <select name="categoryId" id="addCategory" class="form-input" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.getId()}">${c.getName()}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group col-span-2">
                        <label for="addName" class="form-label">Tên sản phẩm *</label>
                        <input type="text" name="name" id="addName" placeholder="Tên sản phẩm" required class="form-input">
                    </div>
                    <div class="form-group col-span-2">
                        <label for="updateUrl" class="form-label">Đường dẫn ảnh (URL)</label>
                        <input type="text" name="url" id="updateUrl" class="form-input" placeholder="https://example.com/image.jpg">
                    </div>


                    <div class="form-group col-span-2">
                        <label for="addDescription" class="form-label">Mô tả *</label>
                        <input type="text" name="description" id="addDescription" placeholder="Mô tả" required class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="addQuantity" class="form-label">Số lượng (Tồn kho)</label>
                        <input type="number" name="quantity" id="addQuantity" value="0" min="0" required class="form-input" readonly>
                        <small class="text-xs text-gray-500 mt-1 block">Dùng "Nhập kho" để thêm tồn kho.</small>
                    </div>

                    <div class="form-group">
                        <label for="addUnit" class="form-label">Đơn vị *</label>
                        <input type="text" name="unit" id="addUnit" placeholder="bó, hộp, gói..." required class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="addBasePrice" class="form-label">Giá bán (₫) *</label>
                        <input type="number" name="basePrice" id="addBasePrice" placeholder="Giá bán (₫)" min="0" required class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="addCostPrice" class="form-label">Giá cost (₫)</label>
                        <input type="number" name="costPrice" id="addCostPrice" value="0" min="0" required class="form-input" readonly>
                        <small class="text-xs text-gray-500 mt-1 block">Tự động tính khi nhập kho.</small>
                    </div>

                    <div class="flex justify-end gap-2 mt-4 col-span-2">
                        <button type="button" onclick="closeModal()" class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300">Hủy</button>
                        <button type="submit" class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <%-- =================================================== --%>
        <%-- 🔹 MODAL CẬP NHẬT SẢN PHẨM (ĐÃ THÊM LABEL VÀ URL) --%>
        <%-- =================================================== --%>
        <div id="updateProductModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50 overflow-auto py-10">
            <%-- Thêm overflow-auto và py-10 để cuộn nếu nội dung dài --%>
            <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-8 relative">
                <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>

                <h3 class="text-xl font-bold text-pink-700 mb-6">Cập Nhật Sản Phẩm</h3>

                <form id="updateProductForm" action="admin-product" method="post" class="grid grid-cols-2 gap-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productId" id="updateProductId">

                    <div class="form-group">
                        <label for="updateType" class="form-label">Loại hàng *</label>
                        <select name="product_type_update" id="updateType" class="form-input" required>
                            <option value="">-- Chọn loại hàng --</option>
                            <option value="flowers">Flowers</option>
                            <option value="accessory">Accessory</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="updateCategoryId" class="form-label">Danh mục *</label>
                        <select name="categoryId" id="updateCategoryId" class="form-input" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.getId()}">${c.getName()}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group col-span-2">
                        <label for="updateName" class="form-label">Tên sản phẩm *</label>
                        <input type="text" name="name" id="updateName" required class="form-input">
                    </div>

                    <div class="form-group col-span-2">
                        <label for="updateUrl" class="form-label">Đường dẫn ảnh (URL)</label>
                        <input type="text" name="url" id="updateUrl" class="form-input" placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="form-group col-span-2">
                        <label for="updateDescription" class="form-label">Mô tả *</label>
                        <input type="text" name="description" id="updateDescription" required class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="updateQuantity" class="form-label">Số lượng (Tồn kho)</label>
                        <input type="number" name="quantity" id="updateQuantity" required min="0" class="form-input" readonly>
                        <small class="text-xs text-gray-500 mt-1 block">Quản lý tại "Nhập kho".</small>
                    </div>

                    <div class="form-group">
                        <label for="updateUnit" class="form-label">Đơn vị *</label>
                        <input type="text" name="unit" id="updateUnit" required class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="updateBasePrice" class="form-label">Giá bán (₫) *</label>
                        <input type="number" name="basePrice" id="updateBasePrice" required min="0" class="form-input">
                    </div>

                    <div class="form-group">
                        <label for="updateCostPrice" class="form-label">Giá cost (₫)</label>
                        <input type="number" name="costPrice" id="updateCostPrice" required min="0" class="form-input" readonly>
                        <small class="text-xs text-gray-500 mt-1 block">Tự động tính khi nhập kho.</small>
                    </div>

                    <div class="flex justify-end gap-2 mt-4 col-span-2">
                        <button type="button" onclick="closeUpdateModal()" class="px-4 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300">Hủy</button>
                        <button type="submit" class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">Cập nhật</button>
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
                // ✅ Reset form khi đóng
                previewImage('', 'addUrlPreview'); // Ẩn ảnh xem trước
                document.getElementById("addUrl").value = ''; // Xóa link
            }

            function openUpdateModal(product) {
                document.getElementById("updateProductId").value = product.id;
                document.getElementById("updateCategoryId").value = product.categoryId;
                document.getElementById("updateName").value = product.name;
                document.getElementById("updateDescription").value = product.description;
                document.getElementById("updateBasePrice").value = product.basePrice;
                document.getElementById("updateQuantity").value = product.quantity;
                document.getElementById("updateCostPrice").value = product.costPrice;
                document.getElementById("updateUnit").value = product.unit;
                document.getElementById("updateType").value = product.isAccessory ? "accessory" : "flowers";

                // Xử lý giá trị null/undefined cho URL
                const imageUrl = (product.url && product.url !== 'null') ? product.url : '';
                document.getElementById("updateUrl").value = imageUrl;

                // ✅ Kích hoạt xem trước ngay khi mở
                previewImage(imageUrl, 'updateUrlPreview');

                document.getElementById("updateProductModal").classList.remove("hidden");
            }

            function closeUpdateModal() {
                document.getElementById("updateProductModal").classList.add("hidden");
                // ✅ Reset form khi đóng
                previewImage('', 'updateUrlPreview'); // Ẩn ảnh xem trước
            }

            // ✅ HÀM MỚI: Xử lý xem trước ảnh
            function previewImage(url, previewId) {
                const imgPreview = document.getElementById(previewId);
                const errorText = document.getElementById(previewId.replace('Preview', 'Error'));

                // Kiểm tra link cơ bản
                if (url && (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('data:image'))) {
                    imgPreview.src = url;
                    imgPreview.classList.remove('hidden'); // Hiện ảnh
                    errorText.classList.add('hidden'); // Ẩn lỗi

                    // Xử lý khi link ảnh bị lỗi 404, 403...
                    imgPreview.onerror = function () {
                        imgPreview.classList.add('hidden'); // Ẩn ảnh
                        errorText.classList.remove('hidden'); // Hiện lỗi
                    };
                } else if (url === '') {
                    // Nếu người dùng xóa link
                    imgPreview.src = '';
                    imgPreview.classList.add('hidden');
                    errorText.classList.add('hidden');
                } else {
                    // Nếu link không hợp lệ (không có http)
                    imgPreview.src = '';
                    imgPreview.classList.add('hidden');
                    if (url.length > 0) { // Chỉ hiện lỗi nếu có gõ gì đó
                        errorText.classList.remove('hidden');
                    }
                }
            }

            // Hàm JAVASCRIPT CHO CONFIRM DELETE
            function confirmDelete(isActive) {
                if (isActive) {
                    return confirm('Bạn có chắc muốn ẨN sản phẩm này?\n(Sản phẩm sẽ bị ẩn khỏi trang bán hàng)');
                } else {
                    return confirm('SẢN PHẨM NÀY ĐANG BỊ ẨN!\n\nBạn có chắc muốn XÓA VĨNH VIỄN không?\nHành động này không thể hoàn tác.');
                }
            }
        </script>

        <script>
            function openModal() {
                document.getElementById("addProductModal").classList.remove("hidden");
            }
            function closeModal() {
                document.getElementById("addProductModal").classList.add("hidden");
            }

            function openUpdateModal(product) {
                document.getElementById("updateProductId").value = product.id;
                document.getElementById("updateCategoryId").value = product.categoryId;
                document.getElementById("updateName").value = product.name;
                document.getElementById("updateDescription").value = product.description;
                document.getElementById("updateBasePrice").value = product.basePrice;
                document.getElementById("updateQuantity").value = product.quantity;
                document.getElementById("updateCostPrice").value = product.costPrice;
                document.getElementById("updateUnit").value = product.unit;
                document.getElementById("updateType").value = product.isAccessory ? "accessory" : "flowers";

                // ✅ CẬP NHẬT: Xử lý giá trị null/undefined cho URL
                document.getElementById("updateUrl").value = (product.url && product.url !== 'null') ? product.url : '';

                document.getElementById("updateProductModal").classList.remove("hidden");
            }

            function closeUpdateModal() {
                document.getElementById("updateProductModal").classList.add("hidden");
            }

            // Hàm JAVASCRIPT CHO CONFIRM DELETE
            function confirmDelete(isActive) {
                if (isActive) {
                    return confirm('Bạn có chắc muốn ẨN sản phẩm này?\n(Sản phẩm sẽ bị ẩn khỏi trang bán hàng)');
                } else {
                    return confirm('SẢN PHẨM NÀY ĐANG BỊ ẨN!\n\nBạn có chắc muốn XÓA VĨNH VIỄN không?\nHành động này không thể hoàn tác.');
                }
            }
        </script>
    </body>
</html>