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

        // Lấy danh sách sản phẩm từ DAO
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getAllProducts();
        System.out.println(productList.size()+"Hello");
        System.out.println("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");

        // Gửi dữ liệu sang JSP
        request.setAttribute("shopName", "FlowerShop");
        request.setAttribute("pageTitle", "Trang Chủ - FlowerShop");
        request.setAttribute("productList", productList);

        // Forward đến giao diện JSP
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
        return "Homepage Servlet - Hiển thị danh sách sản phẩm FlowerShop";
    }

}
