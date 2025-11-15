package controller.customer;

import dao.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

@WebServlet(name = "Homepage", urlPatterns = {"/Homepage"})
public class Homepage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int productsPerPage = 18;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getProductsByPage(page, productsPerPage);
        int totalProducts = dao.countAllProducts();

        request.setAttribute("shopName", "FlowerShop");
        request.setAttribute("pageTitle", "Trang Chủ - FlowerShop");
        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalProducts", totalProducts);

        RequestDispatcher dispatcher = request.getRequestDispatcher("Common/homepage.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Homepage Servlet - Hiển thị danh sách sản phẩm FlowerShop (có phân trang)";
    }
}
