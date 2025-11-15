<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản Lý Kho Hàng - Admin</title>
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

  <%@ include file="/Trang/sidebarAdmin.jsp" %>

  <main class="flex-1 overflow-auto">
    <%@ include file="/Trang/headerAdmin.jsp" %>

    <section class="p-8">

      <!-- Header -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2">
            <i class="fa-solid fa-warehouse"></i> Quản Lý Kho Hàng
          </h2>
          <p class="text-gray-500 text-sm mt-1">Theo dõi và quản lý các kho vật tư</p>
        </div>
        <button onclick="openModal()"
                class="bg-gradient-to-r from-pink-300 to-pink-400 hover:from-pink-400 hover:to-pink-500 text-white font-medium px-5 py-2 rounded-lg shadow-md flex items-center gap-2">
          <i class="fas fa-plus"></i> Thêm kho hàng
        </button>
      </div>

      <!-- Bảng -->
      <div class="bg-white rounded-2xl shadow-lg overflow-hidden border border-pink-100">
        <table class="w-full text-sm">
          <thead class="bg-gradient-to-r from-pink-200 to-pink-100 text-gray-700">
          <tr>
            <th class="px-6 py-3 text-left font-semibold">ID</th>
            <th class="px-6 py-3 text-left font-semibold">Mã Kho</th>
            <th class="px-6 py-3 text-left font-semibold">Tên Kho</th>
            <th class="px-6 py-3 text-left font-semibold">Địa Chỉ</th>
            <th class="px-6 py-3 text-center font-semibold">Trạng Thái</th>
            <th class="px-6 py-3 text-center font-semibold">Thao Tác</th>
          </tr>
          </thead>

          <tbody class="divide-y divide-pink-50">
          <c:forEach var="w" items="${warehouses}">
            <tr class="hover:bg-pink-50">
              <td class="px-6 py-4 font-medium text-gray-800">${w.id}</td>
              <td class="px-6 py-4">${w.code}</td>
              <td class="px-6 py-4">${w.name}</td>
              <td class="px-6 py-4">${w.address}</td>
              <td class="px-6 py-4 text-center">
                <span class="px-3 py-1 rounded-full text-xs font-semibold
                             ${w.isActive ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                  ${w.isActive ? 'Hoạt động' : 'Ngừng'}
                </span>
              </td>
              <td class="px-6 py-4 text-center">
                <div class="flex justify-center gap-4">
                  <!-- Sửa -->
                  <a href="#" class="text-green-600 hover:text-green-800 text-lg"
                     onclick='openUpdateModal({
                       id: "${w.id}",
                       code: "${w.code}",
                       name: "${w.name}",
                       address: "${w.address}",
                       isActive: ${w.isActive}
                     })'>
                    <i class="fas fa-edit"></i>
                  </a>

                  <!-- Xóa -->
                  <form action="warehouse" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa kho này?')">
                    <input type="hidden" name="id" value="${w.id}">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="text-red-500 hover:text-red-700 text-lg">
                      <i class="fas fa-trash"></i>
                    </button>
                  </form>

                  <!-- Xem tồn kho -->
                  <form action="inventory" method="get">
                    <input type="hidden" name="warehouseId" value="${w.id}">
                    <button type="submit" class="text-blue-500 hover:text-blue-700 text-lg">
                      <i class="fas fa-eye"></i>
                    </button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty warehouses}">
            <tr>
              <td colspan="6" class="text-center py-6 text-gray-500 italic">Chưa có kho hàng nào.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</div>

<!-- Modal Thêm -->
<div id="addModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-8 relative">
    <button onclick="closeModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
      <i class="fas fa-times"></i>
    </button>

    <h3 class="text-xl font-bold text-pink-700 mb-6">Thêm Kho Hàng</h3>

    <form action="warehouse" method="post" class="grid gap-4">
      <input type="hidden" name="action" value="create">

      <input type="text" name="code" placeholder="Mã kho" required
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
      <input type="text" name="name" placeholder="Tên kho" required
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
      <input type="text" name="address" placeholder="Địa chỉ"
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">

      <label class="flex items-center gap-2">
        <input type="checkbox" name="isActive" class="w-4 h-4 text-pink-500">
        <span class="text-gray-700">Đang hoạt động</span>
      </label>

      <div class="flex justify-end gap-2 mt-4">
        <button type="button" onclick="closeModal()"
                class="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-gray-800">Hủy</button>
        <button type="submit"
                class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">
          Thêm
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Cập nhật -->
<div id="updateModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-8 relative">
    <button onclick="closeUpdateModal()" class="absolute top-3 right-3 text-gray-500 hover:text-gray-700">
      <i class="fas fa-times"></i>
    </button>

    <h3 class="text-xl font-bold text-pink-700 mb-6">Cập Nhật Kho Hàng</h3>

    <form action="warehouse" method="post" class="grid gap-4">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="id" id="updateId">

      <input type="text" name="code" id="updateCode" required
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
      <input type="text" name="name" id="updateName" required
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">
      <input type="text" name="address" id="updateAddress"
             class="border border-pink-200 rounded-lg px-4 py-2 focus:ring-2 focus:ring-pink-300">

      <label class="flex items-center gap-2">
        <input type="checkbox" name="isActive" id="updateIsActive" class="w-4 h-4 text-pink-500">
        <span class="text-gray-700">Đang hoạt động</span>
      </label>

      <div class="flex justify-end gap-2 mt-4">
        <button type="button" onclick="closeUpdateModal()"
                class="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-gray-800">Hủy</button>
        <button type="submit"
                class="px-4 py-2 rounded-lg bg-gradient-to-r from-pink-400 to-purple-500 text-white hover:from-pink-500 hover:to-purple-600 shadow-md">
          Cập nhật
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  function openModal() {
    document.getElementById("addModal").classList.remove("hidden");
  }
  function closeModal() {
    document.getElementById("addModal").classList.add("hidden");
  }

  function openUpdateModal(w) {
    document.getElementById("updateId").value = w.id;
    document.getElementById("updateCode").value = w.code;
    document.getElementById("updateName").value = w.name;
    document.getElementById("updateAddress").value = w.address;
    document.getElementById("updateIsActive").checked = w.isActive === true || w.isActive === "true";
    document.getElementById("updateModal").classList.remove("hidden");
  }

  function closeUpdateModal() {
    document.getElementById("updateModal").classList.add("hidden");
  }
</script>
</body>
</html>
