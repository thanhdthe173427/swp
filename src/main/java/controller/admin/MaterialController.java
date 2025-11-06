package controller.admin;

import dao.MaterialDAO;
import model.Material;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MaterialController", urlPatterns = {"/admin-materials"})
public class MaterialController extends HttpServlet {

    private MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                long id = Long.parseLong(request.getParameter("deleteId"));
                materialDAO.delete(id);
            } else if ("update".equals(action)) {
                long id = Long.parseLong(request.getParameter("materialId"));
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                String unit = request.getParameter("unit");
                BigDecimal cost = new BigDecimal(request.getParameter("costPrice"));

                Material m = new Material();
                m.setId(id);
                m.setName(name);
                m.setDescription(desc);
                m.setUnit(unit);
                m.setCostPrice(cost);

                materialDAO.update(m);
            } else if ("add".equals(action)) {
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                String unit = request.getParameter("unit");
                BigDecimal cost = new BigDecimal(request.getParameter("costPrice"));

                Material m = new Material();
                m.setName(name);
                m.setDescription(desc);
                m.setUnit(unit);
                m.setCostPrice(cost);

                materialDAO.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sau khi thao tác xong, forward về lại JSP với danh sách cập nhật
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String search = request.getParameter("search");
        List<Material> materials;
        try {
            if (search != null && !search.trim().isEmpty()) {
                materials = materialDAO.search(search);
                request.setAttribute("search", search);
            } else {
                materials = materialDAO.getAll();
            }
            request.setAttribute("materials", materials);
            request.getRequestDispatcher("admin/materials.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
