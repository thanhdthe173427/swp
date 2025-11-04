package controller;

import dao.OrderDAO;
import dao.OrderItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.OrderItem;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
                req.setAttribute("orderItems", items);
                req.getRequestDispatcher("adminDashboard/order-details.jsp").forward(req, resp);
                return;
            } else {
                // Hiển thị danh sách đơn hàng
                List<Order> orders = orderDAO.getAllOrders(keyword);
                req.setAttribute("orders", orders);
                req.setAttribute("search", keyword);
                req.getRequestDispatcher("adminDashboard/admin-orders.jsp").forward(req, resp);
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminOrderController.class.getName()).log(Level.SEVERE, null, ex);
            throw new ServletException(ex);
        }
    }

}
