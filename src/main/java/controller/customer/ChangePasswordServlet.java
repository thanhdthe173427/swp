package controller.customer;

import dao.UserDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ChangePassword")
public class ChangePasswordServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        request.getRequestDispatcher("/Customer/changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ✅ Kiểm tra hợp lệ
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("/Customer/changePassword.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra mật khẩu cũ
        if (!currentPassword.equals(user.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("/Customer/changePassword.jsp").forward(request, response);
            return;
        }

        // ✅ Kiểm tra xác nhận mật khẩu mới
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/Customer/changePassword.jsp").forward(request, response);
            return;
        }

        // ✅ Cập nhật mật khẩu mới
        user.setPasswordHash(newPassword);
        userDao.updateUser(user);

        // ✅ Cập nhật lại session
        session.setAttribute("user", user);
        request.setAttribute("success", "Cập nhật mật khẩu thành công!");

        request.getRequestDispatcher("/Customer/changePassword.jsp").forward(request, response);
    }
}
