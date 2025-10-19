package controller.customer;

import dao.WishlistDao;
import dao.ProductDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/Wishlist")
public class WishlistServlet extends HttpServlet {
    private WishlistDao wishlistDao = new WishlistDao();
    private ProductDAO productDao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        List<WishlistItem> wishlist = wishlistDao.getWishlistByUser(user.getId());
        request.setAttribute("wishlist", wishlist);
        request.getRequestDispatcher("/Customer/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        long productId = Long.parseLong(request.getParameter("productId"));

        // Nếu sản phẩm đã có thì xóa, ngược lại thì thêm
        if (wishlistDao.isInWishlist(user.getId(), productId)) {
            wishlistDao.removeFromWishlist(user.getId(), productId);
        } else {
            wishlistDao.addToWishlist(user.getId(), productId);
        }

        response.sendRedirect(request.getContextPath() + "/Wishlist");
    }
}
