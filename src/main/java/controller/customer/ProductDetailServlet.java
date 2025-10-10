package controller.customer;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

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

            // ✅ Forward đúng đường dẫn tuyệt đối bên trong webapp/Common/
            request.getRequestDispatcher("/Common/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("Homepage");
        }
    }
}
