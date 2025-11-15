package controller.admin;

import dao.FormulaDAO;
import dao.InventoryDAO;
import dao.MaterialDAO;
import dao.ProductDAO;
import model.Material;
import model.Product;
import model.Formula;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
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
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "edit":
                    showEdit(req, resp);
                    break; // Bắt buộc phải có break
                default:
                    listFormulas(req, resp);
                    break; // Tùy chọn, nhưng nên có
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
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "insert":
                    insertFormula(req, resp);
                    break;
                case "update":
                    updateFormula(req, resp);
                    break;
                case "delete":
                    deleteFormula(req, resp);
                    break;
                default:
                    listFormulas(req, resp);
                    break;
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

        req.getRequestDispatcher("admin/admin-formulas.jsp").forward(req, resp);
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
                int qty = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;
                materialQuantities.put(Long.parseLong(mid), qty);
            }
            formulaDAO.addFormulas(productId, materialQuantities);
            recalculateProductCostAndQuantity(productId, materialQuantities);
        } else {
            recalculateProductCostAndQuantity(productId, Collections.emptyMap());
        }
        listFormulas(req, resp);
    }




    private void updateFormula(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        long productId = Long.parseLong(req.getParameter("productId"));
        String[] materialIds = req.getParameterValues("materialIds");
        formulaDAO.deleteByProduct(productId);
        if (materialIds != null && materialIds.length > 0) {
            Map<Long, Integer> materialQuantities = new HashMap<>();
            for (String mid : materialIds) {
                String qtyParam = req.getParameter("quantity_" + mid);
                int qty = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;
                materialQuantities.put(Long.parseLong(mid), qty);
            }
            formulaDAO.addFormulas(productId, materialQuantities);
            recalculateProductCostAndQuantity(productId, materialQuantities);
        } else {
            recalculateProductCostAndQuantity(productId, Collections.emptyMap());
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

    // helper: tính tổng costPrice và producibleQuantity rồi update product
    private void recalculateProductCostAndQuantity(long productId, Map<Long,Integer> materialQuantities) {
        if (materialQuantities == null || materialQuantities.isEmpty()) {
            // Không có công thức -> đặt cost = 0 và quantity = 0 (tuỳ yêu cầu)
            productDAO.updateCostPrice(productId, BigDecimal.ZERO);
//            productDAO.updateQuantity(productId, 0);
            return;
        }

        BigDecimal totalCostPrice = BigDecimal.ZERO;
        InventoryDAO inventoryDAO = new InventoryDAO();

        // Khởi tạo bằng max và giảm dần bằng min()
        int producibleQuantity = Integer.MAX_VALUE;

        for (Map.Entry<Long, Integer> e : materialQuantities.entrySet()) {
            long materialId = e.getKey();
            int requiredQty = e.getValue() != null ? e.getValue() : 0;

            // Bảo vệ: requiredQty phải >= 1, nếu <=0 thì coi như không thể sản xuất
            if (requiredQty <= 0) {
                producibleQuantity = 0;
                // vẫn cố gắng cộng cost nếu muốn (ở đây bỏ qua)
                continue;
            }

            // Lấy giá nguyên liệu (BigDecimal) — nếu null thì coi là 0
            BigDecimal materialCost = materialDAO.getCostPrice(materialId);
            if (materialCost == null) materialCost = BigDecimal.ZERO;
            totalCostPrice = totalCostPrice.add(materialCost.multiply(BigDecimal.valueOf(requiredQty)));

            // Lấy tồn kho nguyên liệu
            Integer materialStockObj = inventoryDAO.getTotalQuantityByMaterialId(materialId);
            int materialStock = materialStockObj != null ? materialStockObj : 0;

            // Số sản phẩm có thể làm từ nguyên liệu này
            int producibleFromThis = materialStock / requiredQty; // integer division OK

            // nếu any material thiếu -> producibleFromThis sẽ nhỏ -> min sẽ giảm
            if (producibleFromThis < producibleQuantity) {
                producibleQuantity = producibleFromThis;
            }
        }

        // Nếu không có material nào làm thay đổi (vẫn MAX_VALUE) -> đặt 0
        if (producibleQuantity == Integer.MAX_VALUE) {
            producibleQuantity = 0;
        }

        // Cập nhật product
        productDAO.updateCostPrice(productId, totalCostPrice);
//        productDAO.updateQuantity(productId, producibleQuantity);
    }

}
