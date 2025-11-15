package controller.common;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet(name = "RecommendServlet", urlPatterns = {"/Recommend"})
public class RecommendServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String occasion = request.getParameter("occasion");
        if (occasion == null || occasion.isEmpty()) {
            occasion = "birthday";
        }

        List<Product> products = productDAO.getProductsByOccasion(occasion);

        request.setAttribute("occasion", occasion);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/Common/recommend.jsp").forward(request, response);
    }
}

