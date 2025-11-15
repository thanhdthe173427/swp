package controller.customer;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/CategoryProduct")
public class CategoryProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categorySlug = request.getParameter("category");
        ProductDAO dao = new ProductDAO();
        List<Product> list;

        if (categorySlug != null && !categorySlug.isEmpty()) {
            list = dao.getProductsByCategorySlug(categorySlug);
            request.setAttribute("pageTitle", "Danh mục: " + categorySlug);
        } else {
            list = dao.getAllProducts();
            request.setAttribute("pageTitle", "Flower Shop - Trang Chủ");
        }

        request.setAttribute("productList", list);
        request.getRequestDispatcher("Common/homepage.jsp").forward(request, response);
    }
}
