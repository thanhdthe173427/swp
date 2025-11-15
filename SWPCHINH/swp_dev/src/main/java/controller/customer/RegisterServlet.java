package controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.UserDao;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // ✅ Tạo đối tượng User
        User u = new User();
        u.setEmail(email);
        u.setPhone(phone);
        u.setPasswordHash(password);
        u.setFullName(fullname);
        u.setRole("customer");
        u.setStatus("active");

        // ✅ Lưu vào DB
        UserDao dao = new UserDao();
        dao.insertUser(u);

        // ✅ Lưu thông tin user vào session (tùy chọn)
        HttpSession session = request.getSession();
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        session.setAttribute("address", address);
        session.setAttribute("fullname", fullname);
   


        // ✅ Redirect tới success.jsp (tự động về đúng context path)
        response.sendRedirect(request.getContextPath() + "/Common/success.jsp");
    }
}
