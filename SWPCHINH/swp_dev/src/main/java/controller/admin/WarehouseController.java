package controller.admin;

import dao.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import model.User;
import model.Warehouse;

@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseController extends HttpServlet {

    private final WarehouseDAO warehouseDao = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "edit": {
                Long id = Long.parseLong(request.getParameter("id"));
                Warehouse warehouse = warehouseDao.getById(id);
                request.setAttribute("warehouseEdit", warehouse);
                break; // Dùng break để ngăn fall-through
            }
            case "add": {
                request.setAttribute("isAddMode", true);
                break; // Dùng break để ngăn fall-through
            }
            // Bạn sẽ cần thêm default case ở đây nếu muốn hoàn thiện switch
            // default:
            //     break; 
        }

        List<Warehouse> warehouses = warehouseDao.getAll();
        request.setAttribute("warehouses", warehouses);
        request.getRequestDispatcher("admin/warehouse.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            create(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            update(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            delete(request, response);
        } else {
            this.doGet(request, response);
        }
    }

    protected void create(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        boolean isActive = "on".equals(request.getParameter("isActive"));

        Warehouse w = new Warehouse();
        w.setCode(code);
        w.setName(name);
        w.setAddress(address);
        w.setIsActive(isActive);

        warehouseDao.add(w);
        this.doGet(request, response);
    }

    protected void update(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        boolean isActive = "on".equals(request.getParameter("isActive"));

        Warehouse w = warehouseDao.getById(id);
        w.setCode(code);
        w.setName(name);
        w.setAddress(address);
        w.setIsActive(isActive);

        warehouseDao.update(w);
        this.doGet(request, response);
    }

    protected void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        warehouseDao.delete(id);
        this.doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Warehouse Controller - CRUD operations with forward to warehouse.jsp";
    }
}
