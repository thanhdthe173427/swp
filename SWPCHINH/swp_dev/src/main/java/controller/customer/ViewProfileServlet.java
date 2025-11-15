package controller.customer;

import dao.UserDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * ✅ Servlet hiển thị trang View Profile
 */
@WebServlet(name = "ViewProfileServlet", urlPatterns = {"/ViewProfile"})
public class ViewProfileServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            // Nếu chưa đăng nhập → chuyển hướng về trang login
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // Lấy dữ liệu user mới nhất từ DB
        User fullUser = userDao.getUserById(sessionUser.getId());

        // Đưa user vào request scope
        request.setAttribute("userProfile", fullUser);

        // Forward sang trang JSP để hiển thị thông tin
        RequestDispatcher rd = request.getRequestDispatcher("/Customer/viewProfile.jsp");
        rd.forward(request, response);
    }
}
