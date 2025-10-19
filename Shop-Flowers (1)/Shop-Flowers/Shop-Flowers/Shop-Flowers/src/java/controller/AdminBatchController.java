package controller;

import dao.BatchDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.SupplierInvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Batch;
import model.Product;
import model.Warehouse;
import model.SupplierInvoice;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


@WebServlet(name = "BatchController", urlPatterns = {"/admin-batches"})
public class AdminBatchController extends HttpServlet {

    private BatchDAO batchDAO = new BatchDAO();
    private ProductDAO productDAO = new ProductDAO();
    private WarehouseDAO warehouseDAO = new WarehouseDAO();
    private SupplierInvoiceDAO supplierInvoiceDAO = new SupplierInvoiceDAO();

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
        
        // <CHANGE> Load all products, warehouses, and supplier invoices for dropdowns
        List<Product> products = productDAO.getAll();
        List<Warehouse> warehouses = warehouseDAO.getAll();
        List<SupplierInvoice> supplierInvoices = supplierInvoiceDAO.getAll();
        
        request.setAttribute("batches", batches);
        request.setAttribute("products", products);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("supplierInvoices", supplierInvoices);
        request.getRequestDispatcher("adminDashboard/batch-views.jsp").forward(request, response);
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

    private void handleAdd(HttpServletRequest request) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        Batch batch = new Batch();
        batch.setProductId(Long.parseLong(request.getParameter("productId")));
        
        // <CHANGE> Handle nullable warehouseId and supplierInvoiceId
        String warehouseId = request.getParameter("warehouseId");
        if (warehouseId != null && !warehouseId.trim().isEmpty() && !warehouseId.equals("null")) {
            batch.setWarehouseId(Long.parseLong(warehouseId));
        }
        
        String supplierInvoiceId = request.getParameter("supplierInvoiceId");
        if (supplierInvoiceId != null && !supplierInvoiceId.trim().isEmpty() && !supplierInvoiceId.equals("null")) {
            batch.setSupplierInvoiceId(Long.parseLong(supplierInvoiceId));
        }
        
        batch.setBatchCode(request.getParameter("batchCode"));
        batch.setMfgDate(sdf.parse(request.getParameter("mfgDate")));
        batch.setExpiryDate(sdf.parse(request.getParameter("expiryDate")));
        batch.setQtyOnHand(Integer.parseInt(request.getParameter("qtyOnHand")));
        batch.setQtyReserved(Integer.parseInt(request.getParameter("qtyReserved")));
        
        batchDAO.add(batch);
    }

    private void handleUpdate(HttpServletRequest request) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        Batch batch = new Batch();
        batch.setId(Long.parseLong(request.getParameter("batchId")));
        batch.setProductId(Long.parseLong(request.getParameter("productId")));
        
        // <CHANGE> Handle nullable warehouseId and supplierInvoiceId
        String warehouseId = request.getParameter("warehouseId");
        if (warehouseId != null && !warehouseId.trim().isEmpty() && !warehouseId.equals("null")) {
            batch.setWarehouseId(Long.parseLong(warehouseId));
        }
        
        String supplierInvoiceId = request.getParameter("supplierInvoiceId");
        if (supplierInvoiceId != null && !supplierInvoiceId.trim().isEmpty() && !supplierInvoiceId.equals("null")) {
            batch.setSupplierInvoiceId(Long.parseLong(supplierInvoiceId));
        }
        
        batch.setBatchCode(request.getParameter("batchCode"));
        batch.setMfgDate(sdf.parse(request.getParameter("mfgDate")));
        batch.setExpiryDate(sdf.parse(request.getParameter("expiryDate")));
        batch.setQtyOnHand(Integer.parseInt(request.getParameter("qtyOnHand")));
        batch.setQtyReserved(Integer.parseInt(request.getParameter("qtyReserved")));
        
        batchDAO.update(batch);
    }

    private void handleDelete(HttpServletRequest request) {
        long id = Long.parseLong(request.getParameter("deleteId"));
        batchDAO.delete(id);
    }
}