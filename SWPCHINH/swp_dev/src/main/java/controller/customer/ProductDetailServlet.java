package controller.customer;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    // ✅ Chỉ hiển thị thông tin sản phẩm
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("Homepage");
            return;
        }

        try {
            long id = Long.parseLong(idParam);
            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductById(id);

            if (product == null) {
                request.setAttribute("error", "Không tìm thấy sản phẩm!");
                request.getRequestDispatcher("/Common/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("product", product);
            request.getRequestDispatcher("/Common/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("Homepage");
        }
    }

    // ❌ Không xử lý thêm giỏ hàng tại đây nữa
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu ai đó gửi POST tới /product-detail (như form cũ),
        // thì chuyển hướng luôn sang Cart servlet để xử lý.
        response.sendRedirect(request.getContextPath() + "/Cart");
    }
}
