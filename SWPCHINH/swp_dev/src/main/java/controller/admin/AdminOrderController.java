package controller.admin;


import dao.OrderDao;
import dao.OrderItemDao;
import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.OrderItem;
import model.Product;
import model.User;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Chưa đăng nhập
            resp.sendRedirect("/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() == null || !user.getRole().equalsIgnoreCase("admin")) {
            resp.sendRedirect("/HomePage");
            return;
        }
        OrderDao orderDAO = new OrderDao();
        ProductDAO productDAO = new ProductDAO();
        OrderItemDao orderItemDAO = new OrderItemDao();
        String action = req.getParameter("action");
        String keyword = req.getParameter("search");

        try {
            if ("view".equals(action)) {
                String orderIdStr = req.getParameter("orderId");
                if (orderIdStr == null || orderIdStr.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID không được để trống");
                    return;
                }
                long orderId = Long.parseLong(orderIdStr);
                List<OrderItem> items = orderItemDAO.getItemsByOrderId(orderId);
                List<Product> products = productDAO.getAllProducts();
                BigDecimal orderTotal = BigDecimal.ZERO;
                for (OrderItem item : items) {
                    orderTotal = orderTotal.add(item.getTotalPrice());
                }
                req.setAttribute("orderTotal", orderTotal);
                req.setAttribute("orderItems", items);
                req.setAttribute("products", products);
                req.getRequestDispatcher("admin/order-details.jsp").forward(req, resp);
                return;
            } else {
                // Hiển thị danh sách đơn hàng
                List<Order> orders = orderDAO.getAllOrders(keyword);
                req.setAttribute("orders", orders);
                req.setAttribute("search", keyword);
                req.getRequestDispatcher("admin/admin-orders.jsp").forward(req, resp);
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminOrderController.class.getName()).log(Level.SEVERE, null, ex);
            throw new ServletException(ex);
        }
    }

}
