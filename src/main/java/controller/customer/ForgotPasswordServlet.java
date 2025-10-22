package controller.customer;

import dao.UserDao;  // ✅ Sửa lại đúng tên lớp thật
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.mail.MessagingException;
import model.User;
import utils.EmailUtil;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            req.getRequestDispatcher("/Common/forgot_password.jsp").forward(req, resp);
            return;
        }

        try {
            // ✅ Đúng class name của bạn
            UserDao dao = new UserDao();
            User user = dao.findByEmail(email);

            if (user == null) {
                req.setAttribute("error", "Không tìm thấy tài khoản với email này.");
                req.getRequestDispatcher("/Common/forgot_password.jsp").forward(req, resp);
                return;
            }

            // ✅ Tạo token reset mật khẩu
            String token = UUID.randomUUID().toString();
            dao.saveResetToken(email, token);

            // ✅ Tạo link reset
            String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                    + req.getContextPath() + "/ResetPassword?token=" + token;

            String subject = "Đặt lại mật khẩu FlowerShop";
            String html = "<h3>Xin chào " + user.getFullName() + "!</h3>"
                    + "<p>Bạn vừa yêu cầu đặt lại mật khẩu cho tài khoản FlowerShop.</p>"
                    + "<p>Nhấn vào liên kết dưới đây để tạo mật khẩu mới:</p>"
                    + "<a href='" + resetLink + "' style='color:#e60073; font-weight:bold;'>Đặt lại mật khẩu</a>"
                    + "<p>Nếu bạn không yêu cầu điều này, vui lòng bỏ qua email.</p>";

            EmailUtil.send(email, subject, html);
            req.setAttribute("msg", "Liên kết đặt lại mật khẩu đã được gửi tới email của bạn!");
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi gửi email: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi hệ thống!");
        }

        req.getRequestDispatcher("/Common/forgot_password.jsp").forward(req, resp);
    }
}
