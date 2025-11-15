package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CartDao;
import dao.CustomerDAO;
import dao.AddressDAO;
import model.Cart;
import model.CartItem;
import model.User;
import model.Address;

/**
 * Servlet điều hướng đến trang thanh toán (checkout.jsp)
 * Kiểm tra giỏ hàng trước khi tiến hành thanh toán.
 * Tự động hiển thị thông tin người nhận (tên, SĐT, địa chỉ mặc định).
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/Checkout"})
public class CheckoutServlet extends HttpServlet {

    private final CartDao cartDao = new CartDao();
    private final CustomerDAO customerDao = new CustomerDAO();
    private final AddressDAO addressDao = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 🔒 Nếu chưa đăng nhập → chuyển hướng đến trang đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // 🩷 Lấy thông tin khách hàng (User) và địa chỉ mặc định
        User customer = customerDao.getCustomerByUserId(user.getId());
        Address defaultAddress = addressDao.getDefaultAddressByUserId(user.getId());

        // 🛒 Lấy giỏ hàng của người dùng
        Cart cart = cartDao.getCartByUserId(user.getId());
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            request.setAttribute("errorMessage", "Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm trước khi thanh toán!");
            request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
            return;
        }

        // ✅ Lấy danh sách sản phẩm được chọn từ checkbox trong form (VD: "12,15,18")
        String selectedParam = request.getParameter("selectedItems");
        List<CartItem> selectedItems = new ArrayList<>();

        if (selectedParam != null && !selectedParam.isEmpty()) {
            String[] selectedIds = selectedParam.split(",");
            for (String idStr : selectedIds) {
                try {
                    long productId = Long.parseLong(idStr.trim());
                    for (CartItem item : cart.getItems()) {
                        if (item.getProductId() == productId) {
                            selectedItems.add(item);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    System.err.println("⚠️ Lỗi định dạng productId: " + idStr);
                }
            }
        }

        // ⚠️ Nếu không có sản phẩm nào được chọn → quay lại giỏ hàng
        if (selectedItems.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
            return;
        }

        // ✅ Tạo giỏ hàng tạm chỉ chứa sản phẩm được chọn
        Cart selectedCart = new Cart();
        selectedCart.setItems(selectedItems);

        // Lưu vào session để dùng ở bước thanh toán (và callback VNPay)
        session.setAttribute("selectedCart", selectedCart);

        // ✅ Gửi thông tin khách hàng sang JSP
        request.setAttribute("cart", selectedCart);
        request.setAttribute("customer", customer);
        request.setAttribute("defaultAddress", defaultAddress);

        // 👉 Chuyển đến trang checkout.jsp
        request.getRequestDispatcher("/Customer/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
