package controller;

import dao.FormulaDAO;
import dao.MaterialDAO;
import dao.ProductDAO;
import model.Material;
import model.Product;
import model.Formula;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "FormulaController", urlPatterns = {"/admin-formulas"})
public class FormulaController extends HttpServlet {

    private FormulaDAO formulaDAO;
    private ProductDAO productDAO;
    private MaterialDAO materialDAO;

    @Override
    public void init() {
        formulaDAO = new FormulaDAO();
        productDAO = new ProductDAO();
        materialDAO = new MaterialDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit" -> showEdit(req, resp);
                default -> listFormulas(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "insert" -> insertFormula(req, resp);
                case "update" -> updateFormula(req, resp);
                case "delete" -> deleteFormula(req, resp);
                default -> listFormulas(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // ✅ Hiển thị danh sách công thức
    private void listFormulas(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String search = req.getParameter("search");
        List<Formula> formulas = formulaDAO.getAllWithNames(search);

        req.setAttribute("formulas", formulas);
        req.setAttribute("search", search);
        req.setAttribute("products", productDAO.getAll());
        req.setAttribute("materials", materialDAO.getAll());

        req.getRequestDispatcher("/adminDashboard/admin-formulas.jsp").forward(req, resp);
    }

    // ✅ Khi bấm "Edit" → load danh sách materials đã chọn
    private void showEdit(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        long productId = Long.parseLong(req.getParameter("productId"));
        Product product = productDAO.getById(productId);
        List<Material> allMaterials = materialDAO.getAll();
        List<Material> selectedMaterials = formulaDAO.getMaterialsByProductId(productId);

        req.setAttribute("editProduct", product);
        req.setAttribute("materials", allMaterials);
        req.setAttribute("selectedMaterials", selectedMaterials);

        listFormulas(req, resp);
    }

    // ✅ Thêm công thức mới
    private void insertFormula(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    long productId = Long.parseLong(req.getParameter("productId"));
    String[] materialIds = req.getParameterValues("materialIds");

    if (materialIds != null && materialIds.length > 0) {
        Map<Long, Integer> materialQuantities = new HashMap<>();
        for (String mid : materialIds) {
            String qtyParam = req.getParameter("quantity_" + mid);
            int qty = qtyParam != null && !qtyParam.isEmpty() ? Integer.parseInt(qtyParam) : 1;
            materialQuantities.put(Long.parseLong(mid), qty);
        }
        formulaDAO.addFormulas(productId, materialQuantities);
    }
    listFormulas(req, resp);
}


    // ✅ Cập nhật công thức
    private void updateFormula(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    long productId = Long.parseLong(req.getParameter("productId"));
    String[] materialIds = req.getParameterValues("materialIds");

    formulaDAO.deleteByProduct(productId);

    if (materialIds != null && materialIds.length > 0) {
        Map<Long, Integer> materialQuantities = new HashMap<>();
        for (String mid : materialIds) {
            String qtyParam = req.getParameter("quantity_" + mid);
            int qty = qtyParam != null && !qtyParam.isEmpty() ? Integer.parseInt(qtyParam) : 1;
            materialQuantities.put(Long.parseLong(mid), qty);
        }
        formulaDAO.addFormulas(productId, materialQuantities);
    }
    listFormulas(req, resp);
}


    // ✅ Xóa công thức theo sản phẩm
    private void deleteFormula(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        long productId = Long.parseLong(req.getParameter("productId"));
        formulaDAO.deleteByProduct(productId);

        listFormulas(req, resp);
    }
}
