/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BatchDAO;
import dao.CategoryDAO;
import dao.MaterialDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Material;
import model.Product;

/**
 *
 * @author minhs
 */
@WebServlet(name = "AdminProductController", urlPatterns = {"/admin-product"})
public class AdminProductController extends HttpServlet {

    ProductDAO productDao = new ProductDAO();
    CategoryDAO categoryDao = new CategoryDAO();
    MaterialDAO materialDao = new MaterialDAO();
    BatchDAO batchDao = new BatchDAO();

    public final String ALL_PRODUCTS = "all";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("product_type");
        if (type == null || type.isEmpty()) {
            type = this.ALL_PRODUCTS;
        }

        List<Product> products = productDao.getAll();

        for (Product p : products) {
            int totalQty = batchDao.getTotalQtyByProductId(p.getId());
            int totalBatches = batchDao.getTotalBatchesByProductId(p.getId());
            List<String> warehouseNames = batchDao.getWarehouseNamesByProductId(p.getId());

            p.setTotalQty(totalQty); // thêm field totalQty trong Product
            p.setTotalBatches(totalBatches); // thêm field totalBatches trong Product
            p.setWarehouses(String.join(", ", warehouseNames)); // thêm field warehouses trong Product
        }

        if ("accessory".equals(type)) {
            products = products.stream()
                    .filter(Product::isIsAccessory)
                    .toList();
        } else if ("flowers".equals(type)) {
            products = products.stream()
                    .filter(p -> !p.isIsAccessory())
                    .toList();
        }

        List<Category> categories = categoryDao.getAll();
        String search = request.getParameter("search");
        if (search != null) {
            String keySearch = search.toLowerCase();
            products = products.stream().filter(p
                    -> (p.getName() != null && p.getName().toLowerCase().contains(keySearch))
                    || (p.getDescription() != null && p.getDescription().toLowerCase().contains(keySearch))
                    || (p.getSku() != null && p.getSku().toLowerCase().contains(keySearch))
            ).toList();
        }
        request.setAttribute("type", type);
        request.setAttribute("search", search);
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.getRequestDispatcher("adminDashboard/product-view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeCreate = request.getParameter("product_type_create");

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("deleteId");
            Long id = Long.parseLong(idStr);
            this.delete(request, response, id);
            return;
        } else if ("update".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("productId");
            Long id = Long.parseLong(idStr);
            this.update(request, response, id);
            return;
        }

        String cid = request.getParameter("categoryId");
        String name = request.getParameter("name");
//        String materialName = request.getParameter("material");
        String description = request.getParameter("description");
        String basePriceStr = request.getParameter("basePrice");
        String costPriceStr = request.getParameter("costPrice");
//        String mid = request.getParameter("materialId");

        BigDecimal basePrice = (basePriceStr != null && !basePriceStr.isEmpty())
                ? new BigDecimal(basePriceStr) : BigDecimal.ZERO;
        BigDecimal costPrice = (costPriceStr != null && !costPriceStr.isEmpty())
                ? new BigDecimal(costPriceStr) : BigDecimal.ZERO;

        Long cateId = Long.parseLong(cid);

        Product p = new Product();
        p.setBasePrice(basePrice);
        p.setCostPrice(costPrice);
        p.setName(name);
        p.setDescription(description);
        p.setCategoryId(cateId);
        p.setSku("SKU-" + System.currentTimeMillis());  // hoặc dùng logic generate khác
        p.setSlug(name.toLowerCase().replaceAll("\\s+", "-"));
        p.setUnit(request.getParameter("unit"));
        p.setIsActive(true);

        if ("accessory".equals(typeCreate)) {
            p.setIsAccessory(true);
        } else if ("flowers".equals(typeCreate)) {
            p.setIsAccessory(false);
        }

        productDao.add(p);
        this.doGet(request, response);
    }

    protected void delete(HttpServletRequest request, HttpServletResponse respone, Long id) throws ServletException, IOException {
        productDao.delete(id);
        this.doGet(request, respone);
    }

    protected void update(HttpServletRequest request, HttpServletResponse respone, Long id) throws ServletException, IOException {
        String typeUpdate = request.getParameter("product_type_update");
        String cid = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String basePriceStr = request.getParameter("basePrice");
        String costPriceStr = request.getParameter("costPrice");

        BigDecimal basePrice = (basePriceStr != null && !basePriceStr.isEmpty())
                ? new BigDecimal(basePriceStr) : BigDecimal.ZERO;
        BigDecimal costPrice = (costPriceStr != null && !costPriceStr.isEmpty())
                ? new BigDecimal(costPriceStr) : BigDecimal.ZERO;

        Long cateId = Long.parseLong(cid);

        Product p = productDao.getById(id);
        p.setBasePrice(basePrice);
        p.setCostPrice(costPrice);
        p.setName(name);
        p.setDescription(description);
        p.setUnit(request.getParameter("unit"));
        p.setCategoryId(cateId);
        boolean isAccessory = true;
        if ("accessory".equals(typeUpdate)) {
            p.setIsAccessory(true);
        } else if ("flowers".equals(typeUpdate)) {
            p.setIsAccessory(false);
            isAccessory = false;
        }

        productDao.update(p);
        request.setAttribute("product_type_update", isAccessory);
        this.doGet(request, respone);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
