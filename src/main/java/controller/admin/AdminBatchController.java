package controller.admin;

import dao.BatchDAO;
import dao.MaterialDAO;
import dao.WarehouseDAO;
import dao.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Batch;
import model.Warehouse;
import model.Supplier;
import model.Material;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "BatchController", urlPatterns = {"/admin-batches"})
public class AdminBatchController extends HttpServlet {

    private final BatchDAO batchDAO = new BatchDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String search = request.getParameter("search");
    List<Batch> batches;

    if (search != null && !search.trim().isEmpty()) {
        batches = batchDAO.searchByBatchCode(search);
        request.setAttribute("search", search);
    } else {
        batches = batchDAO.getAll();
    }

    // Giữ nguyên tên biến "products"
    List<Material> products = new ArrayList<>();
    try {
        products = materialDAO.getAll();
    } catch (SQLException ex) {
        Logger.getLogger(AdminBatchController.class.getName()).log(Level.SEVERE, null, ex);
    }

    // Lấy danh sách warehouse và supplier
    List<Warehouse> warehouses = warehouseDAO.getAll();
    List<Supplier> suppliers = supplierDAO.getAll();

    // Gán tên nguyên liệu và tên nhà cung cấp cho từng batch
    for (Batch b : batches) {
        try {
            if (b.getMaterialId() != 0) {
                Material m = materialDAO.getById(b.getMaterialId());
                if (m != null) b.setMaterialName(m.getName());
            }

            if (b.getSupplierId() != 0) {
                for (Supplier s : suppliers) {
                    if (s.getId() == b.getSupplierId()) {
                        b.setSupplierName(s.getName());
                        break;
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminBatchController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Gửi dữ liệu sang JSP
    request.setAttribute("batches", batches);
    request.setAttribute("products", products);
    request.setAttribute("warehouses", warehouses);
    request.setAttribute("suppliers", suppliers);

    request.getRequestDispatcher("admin/batch-views.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                handleDelete(request);
            } else if ("update".equals(action)) {
                handleUpdate(request);
            } else {
                handleAdd(request);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-batches");
    }

    // -------------------- ADD --------------------
    private void handleAdd(HttpServletRequest request) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // Lấy danh sách productId (mảng)
        String[] productIds = request.getParameterValues("productId");
        if (productIds == null || productIds.length == 0) {
            throw new Exception("Không có sản phẩm nào được chọn.");
        }

        String warehouseId = request.getParameter("warehouseId");
        String supplierId = request.getParameter("supplierId");
        String batchCode = request.getParameter("batchCode");
        Date mfgDate = sdf.parse(request.getParameter("mfgDate"));
        int qtyReserved = Integer.parseInt(request.getParameter("qtyReserved"));

        // Duyệt từng productId và tạo batch tương ứng
        for (String pid : productIds) {
            if (pid == null || pid.trim().isEmpty()) continue;

            Batch batch = new Batch();
            batch.setMaterialId(Long.parseLong(pid));

            if (warehouseId != null && !warehouseId.trim().isEmpty() && !warehouseId.equals("null")) {
                batch.setWarehouseId(Long.parseLong(warehouseId));
            }

            if (supplierId != null && !supplierId.trim().isEmpty() && !supplierId.equals("null")) {
                batch.setSupplierId(Long.parseLong(supplierId));
            }

            batch.setBatchCode(batchCode);
            batch.setMfgDate(mfgDate);
            batch.setQtyReserved(qtyReserved);

            batchDAO.add(batch);
        }
    }


    // -------------------- UPDATE --------------------
    private void handleUpdate(HttpServletRequest request) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // Lấy danh sách productId (nhiều)
        String[] productIds = request.getParameterValues("productId");
        if (productIds == null || productIds.length == 0) {
            throw new Exception("Không có sản phẩm nào được chọn để cập nhật.");
        }

        // Các thông tin chung
        String warehouseId = request.getParameter("warehouseId");
        String supplierId = request.getParameter("supplierId");
        String batchCode = request.getParameter("batchCode");
        Date mfgDate = sdf.parse(request.getParameter("mfgDate"));
        int qtyReserved = Integer.parseInt(request.getParameter("qtyReserved"));

        // ID batch (nếu có, ví dụ đang update batch chung)
        String batchIdStr = request.getParameter("batchId");

        for (String pid : productIds) {
            if (pid == null || pid.trim().isEmpty()) continue;

            Batch batch = new Batch();

            // Nếu có batchId (chỉ update 1 batch cụ thể)
            if (batchIdStr != null && !batchIdStr.trim().isEmpty()) {
                batch.setId(Long.parseLong(batchIdStr));
            }

            batch.setMaterialId(Long.parseLong(pid));

            if (warehouseId != null && !warehouseId.trim().isEmpty() && !warehouseId.equals("null")) {
                batch.setWarehouseId(Long.parseLong(warehouseId));
            }

            if (supplierId != null && !supplierId.trim().isEmpty() && !supplierId.equals("null")) {
                batch.setSupplierId(Long.parseLong(supplierId));
            }

            batch.setBatchCode(batchCode);
            batch.setMfgDate(mfgDate);
            batch.setQtyReserved(qtyReserved);

            batchDAO.update(batch);
        }
    }


    // -------------------- DELETE --------------------
    private void handleDelete(HttpServletRequest request) {
        long id = Long.parseLong(request.getParameter("deleteId"));
        batchDAO.delete(id);
    }
}
