package filter;

import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter này kiểm tra quyền truy cập Admin.
 * Chỉ cho phép người dùng có role="admin" truy cập vào các đường dẫn được map.
 */
public class AdminAuthFilter implements Filter {

    // Khởi tạo (không cần logic đặc biệt)
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Có thể để trống
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Lấy session hiện tại

        boolean isLoggedIn = (session != null && session.getAttribute("isLoggedIn") != null && (boolean) session.getAttribute("isLoggedIn"));
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (isLoggedIn && user != null) {
            // ⭐ BƯỚC KIỂM TRA QUYỀN HẠN (ROLE) ⭐
            // Giả sử chỉ role "admin" mới được phép
            if ("admin".equalsIgnoreCase(user.getRole())) {
                // ✅ Nếu là admin, cho phép tiếp tục truy cập
                chain.doFilter(request, response);
            } else {
                // ❌ Nếu không phải admin, chuyển hướng đến trang không có quyền (ví dụ: trang chủ)
                System.out.println("⚠️ Truy cập bị từ chối: User " + user.getEmail() + " không có quyền Admin.");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
                
                // Hoặc chuyển hướng về trang chủ:
                // httpResponse.sendRedirect(httpRequest.getContextPath() + "/Homepage");
            }
        } else {
            // ❌ Nếu chưa đăng nhập, chuyển hướng về trang login
            System.out.println("❌ Truy cập bị từ chối: Chưa đăng nhập.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login");
        }
    }

    // Hủy filter (không cần logic đặc biệt)
    @Override
    public void destroy() {
        // Có thể để trống
    }
}