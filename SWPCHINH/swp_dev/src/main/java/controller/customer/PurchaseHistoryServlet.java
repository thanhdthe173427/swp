package controller.customer;

import dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import model.User;

import java.io.IOException;
import java.util.List;

/**
 * Hiển thị danh sách đơn hàng (lịch sử mua hàng) của khách hàng hiện tại.
 */
@WebServlet(name = "PurchaseHistoryServlet", urlPatterns = {"/PurchaseHistory"})
public class PurchaseHistoryServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Nếu chưa đăng nhập → chuyển hướng tới trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // Lấy danh sách đơn hàng theo user
        List<Order> orders = orderDao.getOrdersByUserId(user.getId());

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/Customer/purchaseHistory.jsp").forward(request, response);
    }
}
