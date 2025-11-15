package controller.admin;

import dao.InventoryDAO;
import dao.MaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Inventory;
import model.Material;
import model.User;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "InventoryController", urlPatterns = {"/inventory"})
public class InventoryController extends HttpServlet {

    private final InventoryDAO inventoryDao = new InventoryDAO();
    MaterialDAO materialDao = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String warehouseIdParam = request.getParameter("warehouseId");
        String genReport = request.getParameter("report"); // dùng để trigger modal

        if (warehouseIdParam == null || warehouseIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing warehouse id");
            return;
        }

        try {
            long warehouseId = Long.parseLong(warehouseIdParam);
            List<Inventory> inventoryList = inventoryDao.getByWarehouse(warehouseId);

            for (Inventory inventory : inventoryList) {
                Material m = materialDao.getById(inventory.getMaterialId());
                inventory.setMaterialName(inventory.getMaterialName());
                System.out.println(inventory.getMaterialId());
                System.out.println(inventory.getMaterialName());
            }

            // 🔹 Tạo danh sách hàng sắp hết
            List<Inventory> lowStockList = inventoryList.stream()
                    .filter(i -> i.getQuantity() < 15)
                    .collect(Collectors.toList());

            request.setAttribute("inventoryList", inventoryList);
            request.setAttribute("lowStockList", lowStockList);
            request.setAttribute("warehouseId", warehouseId);

            // Nếu người dùng bấm nút "Report" thì gửi cờ để JSP bật modal
            if (genReport != null) {
                request.setAttribute("showReportModal", true);
            }

            request.getRequestDispatcher("admin/inventory-by-warehouse.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid warehouse id format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String action = request.getParameter("action");

        if ("updateQuantity".equals(action)) {
            try {
                Long materialId = Long.parseLong(request.getParameter("materialId"));
                String whId = request.getParameter("warehouseId");
                Long warehouseId = (whId != null && !whId.isEmpty()) ? Long.parseLong(whId) : null;
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                inventoryDao.updateQuantity(materialId, warehouseId, quantity);
                // Sau khi cập nhật, redirect lại để tránh resubmission form
                String redirectUrl = "inventory?warehouseId=" + (warehouseId != null ? warehouseId : "");
                response.sendRedirect(redirectUrl);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input format");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }


    @Override
    public String getServletInfo() {
        return "Controller hiển thị tồn kho và danh sách hàng sắp hết cho warehouse";
    }
}
