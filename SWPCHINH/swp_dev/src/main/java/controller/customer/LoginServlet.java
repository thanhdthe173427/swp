package controller.customer;

import dao.UserDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Common/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // 1. Validate input cơ bản
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email hoặc tên đăng nhập!");
            request.getRequestDispatcher("/Common/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu!");
            request.getRequestDispatcher("/Common/login.jsp").forward(request, response);
            return;
        }

        // 2. Xác thực với Database
        UserDao userDao = new UserDao();
        User user = userDao.getUserByEmailAndPassword(username, password);

        if (user != null) {
            
            // ⭐ BƯỚC CẬP NHẬT: KIỂM TRA TRẠNG THÁI "inactive" HOẶC "deactive" ⭐
            String status = user.getStatus();
            if ("inactive".equalsIgnoreCase(status) || "deactive".equalsIgnoreCase(status)) {
                // ❌ Tài khoản bị vô hiệu hóa
                request.setAttribute("error", "Tài khoản của bạn đang bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.");
                request.getRequestDispatcher("/Common/login.jsp").forward(request, response);
                return; 
            }
            
            // ✅ Đăng nhập thành công (Tài khoản hợp lệ và active)
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("isLoggedIn", true);

            // Ghi nhớ đăng nhập
            if (remember != null) {
                session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 ngày
            } else {
                session.setMaxInactiveInterval(30 * 60); // 30 phút
            }

            // Chuyển hướng đến trang chủ
            response.sendRedirect(request.getContextPath() + "/Homepage");
        } else {
            // ❌ Sai tài khoản/mật khẩu
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng !");
            request.getRequestDispatcher("/Common/login.jsp").forward(request, response);
        }
    }
}