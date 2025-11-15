<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<header class="bg-gradient-to-r from-pink-100 via-white to-pink-50 shadow-sm border-b border-pink-200 sticky top-0 z-20 backdrop-blur-md">
    <div class="px-8 py-6 flex flex-col items-center justify-center text-center">
        <!-- ✅ Tiêu đề trang -->
        <h2 class="text-3xl font-bold text-pink-700 flex items-center gap-2 mb-1">
            <i class="fa-solid fa-chart-line"></i>
            <c:choose>
                <c:when test="${not empty pageTitle}">
                    ${pageTitle}
                </c:when>
                <c:otherwise>
                    Trang Quản Trị
                </c:otherwise>
            </c:choose>
        </h2>

        <!-- ✅ Mô tả phụ -->
        <p class="text-gray-600 text-sm">
            <c:choose>
                <c:when test="${not empty pageSubtitle}">
                    ${pageSubtitle}
                </c:when>
                <c:otherwise>
                    Quản lý và theo dõi hoạt động hệ thống
                </c:otherwise>
            </c:choose>
        </p>
    </div>
</header>
