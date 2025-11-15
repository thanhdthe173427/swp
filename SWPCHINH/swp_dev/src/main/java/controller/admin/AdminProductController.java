package controller.admin;

import dao.BatchDAO;
import dao.CategoryDAO;
import dao.MaterialDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Product;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

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

        // Nhận Flash Message từ Session (nếu có)
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");

        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            // Xóa message khỏi session sau khi dùng
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }

        String type = request.getParameter("product_type");
        if (type == null || type.isEmpty()) {
            type = this.ALL_PRODUCTS;
        }

        // LẤY TẤT CẢ SẢN PHẨM (BAO GỒM SẢN PHẨM ẨN)
        List<Product> products = productDao.getAll();

        // ... (Phần code filter giữ nguyên) ...
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
        request.getRequestDispatcher("admin/product-view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("deleteId");
            Long id = Long.parseLong(idStr);

            Product p = productDao.getById(id);
            if (p == null) {
                session.setAttribute("message", "Lỗi: Không tìm thấy sản phẩm.");
                session.setAttribute("messageType", "error");
            } else {
                // KIỂM TRA ĐIỀU KIỆN: ĐÃ CÓ NGƯỜI MUA HOẶC CÓ TRONG GIỎ HÀNG
                boolean isInUse = productDao.isProductInUse(id); // <-- GỌI HÀM MỚI

                if (isInUse) {
                    // Nếu đang được dùng (trong đơn hàng HOẶC giỏ hàng)
                    if (p.isIsActive()) {
                        // Chỉ cho phép XÓA MỀM (Ẩn đi)
                        productDao.softDelete(id);
                        session.setAttribute("message", "Sản phẩm '" + p.getName() + "' đang có trong giỏ hàng/đơn hàng. Đã chuyển sang trạng thái Ẩn.");
                        session.setAttribute("messageType", "success");
                    } else {
                        // Nếu đã bị ẩn, KHÔNG cho xóa cứng
                        session.setAttribute("message", "Không thể xóa vĩnh viễn sản phẩm '" + p.getName() + "' vì còn trong lịch sử đơn hàng/giỏ hàng.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    // NẾU KHÔNG AI DÙNG -> Xóa thoải mái
                    if (p.isIsActive()) {
                        // Lần 1: Xóa mềm (ẩn đi)
                        productDao.softDelete(id);
                        session.setAttribute("message", "Đã ẩn sản phẩm '" + p.getName() + "'.");
                        session.setAttribute("messageType", "success");
                    } else {
                        // Lần 2: Xóa cứng (đã bị ẩn và không ai dùng)
                        productDao.delete(id); // Xóa cứng
                        session.setAttribute("message", "Đã xóa vĩnh viễn sản phẩm '" + p.getName() + "'.");
                        session.setAttribute("messageType", "success");
                    }
                }
            }
            // Chuyển hướng về trang admin-product (PRG Pattern)
            response.sendRedirect("admin-product");
            return; // Dừng xử lý
        } else if ("restore".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("restoreId");
            Long id = Long.parseLong(idStr);

            productDao.restore(id); // Gọi hàm DAO

            session.setAttribute("message", "Đã khôi phục sản phẩm thành công.");
            session.setAttribute("messageType", "success");
            response.sendRedirect("admin-product");
            return;

        } else if ("update".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("productId");
            Long id = Long.parseLong(idStr);
            this.update(request, response, id); // Gọi hàm update

            session.setAttribute("message", "Cập nhật sản phẩm thành công!");
            session.setAttribute("messageType", "success");
            response.sendRedirect("admin-product"); // Chuyển hướng
            return;

        } else if ("add".equalsIgnoreCase(action)) {
            // Logic của "add"
            String typeCreate = request.getParameter("product_type_create");
            String cid = request.getParameter("categoryId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String basePriceStr = request.getParameter("basePrice");
            String costPriceStr = request.getParameter("costPrice");
            String quantity = request.getParameter("quantity");
            String url = request.getParameter("url"); // ✅ THÊM MỚI: Lấy URL ảnh

            BigDecimal basePrice = (basePriceStr != null && !basePriceStr.isEmpty())
                    ? new BigDecimal(basePriceStr) : BigDecimal.ZERO;
            BigDecimal costPrice = (costPriceStr != null && !costPriceStr.isEmpty())
                    ? new BigDecimal(costPriceStr) : BigDecimal.ZERO;
            int quantityInt = Integer.parseInt(quantity);

            Long cateId = Long.parseLong(cid);

            Product p = new Product();
            p.setBasePrice(basePrice);
            p.setCostPrice(costPrice);
            p.setName(name);
            p.setDescription(description);
            p.setCategoryId(cateId);
            p.setSku("SKU-" + System.currentTimeMillis());
            p.setSlug(name.toLowerCase().replaceAll("\\s+", "-"));
            p.setUnit(request.getParameter("unit"));
            p.setQuantity(quantityInt);
            p.setIsActive(true); 
            p.setUrl(url); // ✅ THÊM MỚI: Set URL cho sản phẩm

            if ("accessory".equals(typeCreate)) {
                p.setIsAccessory(true);
            } else if ("flowers".equals(typeCreate)) {
                p.setIsAccessory(false);
            }

            productDao.add(p);
            session.setAttribute("message", "Thêm sản phẩm mới thành công!");
            session.setAttribute("messageType", "success");
            response.sendRedirect("admin-product"); // Chuyển hướng
            return;
        }
    }

    // Phương thức update (KHÔNG GỌI doGet VÀ KHÔNG REDIRECT)
    protected void update(HttpServletRequest request, HttpServletResponse respone, Long id) throws ServletException, IOException {
        String typeUpdate = request.getParameter("product_type_update");
        String cid = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String basePriceStr = request.getParameter("basePrice");
        String costPriceStr = request.getParameter("costPrice");
        String quantity = request.getParameter("quantity");
        String url = request.getParameter("url");

        BigDecimal basePrice = (basePriceStr != null && !basePriceStr.isEmpty())
                ? new BigDecimal(basePriceStr) : BigDecimal.ZERO;
        BigDecimal costPrice = (costPriceStr != null && !costPriceStr.isEmpty())
                ? new BigDecimal(costPriceStr) : BigDecimal.ZERO;
        int quantityInt = Integer.parseInt(quantity);


        Long cateId = Long.parseLong(cid);

        Product p = productDao.getById(id);
        p.setBasePrice(basePrice);
        p.setCostPrice(costPrice);
        p.setName(name);
        p.setDescription(description);
        p.setUnit(request.getParameter("unit"));
        p.setCategoryId(cateId);
        p.setQuantity(quantityInt);
        p.setUrl(url);
        // KHÔNG THAY ĐỔI is_active KHI UPDATE, giữ nguyên trạng thái cũ
        // p.setIsActive(true); // DÒNG NÀY SẼ KÍCH HOẠT LẠI SẢN PHẨM ĐÃ ẨN, BỎ ĐI

        if ("accessory".equals(typeUpdate)) {
            p.setIsAccessory(true);
        } else if ("flowers".equals(typeUpdate)) {
            p.setIsAccessory(false);
        }

        productDao.update(p);
        // Không gọi doGet, không redirect ở đây
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}