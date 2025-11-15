package controller.admin;

import dao.CustomerDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-customers")
public class AdminCustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Chưa đăng nhập
            response.sendRedirect("/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() == null || !user.getRole().equalsIgnoreCase("admin")) {
            response.sendRedirect("/HomePage");
            return;
        }
        String action = request.getParameter("action");

        if (action == null) action = "list";

        switch (action) {
            case "detail":
                Long id = Long.parseLong(request.getParameter("id"));
                User customer = customerDAO.getCustomerById(id);
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("admin/customer-detail.jsp").forward(request, response);

                break;
            default:
                List<User> list = customerDAO.getAllCustomers();
                request.setAttribute("customers", list);
                request.getRequestDispatcher("admin/customer-management.jsp").forward(request, response);

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dob");
            String status = request.getParameter("status");

            User u = new User();
            u.setId(id);
            u.setFullName(fullName);
            u.setEmail(email);
            u.setPhone(phone);
            u.setDob(java.sql.Date.valueOf(dob));
            u.setStatus(status);

            customerDAO.updateCustomer(u);
        } else if ("status".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            String status = request.getParameter("status");
            customerDAO.changeStatus(id, status);
        }
        response.sendRedirect("customers");
    }
}
