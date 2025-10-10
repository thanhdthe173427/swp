package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot_password_submit"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu
        String email = request.getParameter("email");

        // 2. Danh sách email giả định (Thay thế bằng kết nối Database thực tế)
        String[] validEmails = {"admin@gmail.com", "user1@example.com", "user2@example.com"};
        boolean emailExists = false;

        for (String validEmail : validEmails) {
            if (validEmail.equalsIgnoreCase(email)) {
                emailExists = true;
                break;
            }
        }
        
        // 3. Chuẩn bị dữ liệu để hiển thị trên trang kết quả
        String resultTitle;
        String resultMessage;
        String messageType; // "success" hoặc "error"

        if (emailExists) {
            resultTitle = "Thành công!";
            resultMessage = "Chúng tôi đã gửi liên kết đặt lại mật khẩu đến email: <b>" + email + "</b>. Vui lòng kiểm tra hộp thư của bạn.";
            messageType = "success";
        } else {
            resultTitle = "Lỗi!";
            resultMessage = "Email <b>" + email + "</b> không tồn tại trong hệ thống. Vui lòng thử lại.";
            messageType = "error";
        }

        // 4. Đặt thuộc tính vào request để JSP hiển thị
        request.setAttribute("resultTitle", resultTitle);
        request.setAttribute("resultMessage", resultMessage);
        request.setAttribute("messageType", messageType);
        request.setAttribute("email", email); // Giữ lại email để hiển thị nếu cần

        // 5. Chuyển tiếp (Forward) yêu cầu đến trang JSP kết quả
        // Giả định bạn có một file JSP tên là forgot_result.jsp để hiển thị kết quả
        request.getRequestDispatcher("/forgot_result.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến form quên mật khẩu ban đầu
        response.sendRedirect("forgot_password.jsp");
    }
}