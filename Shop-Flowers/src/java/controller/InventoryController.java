package controller;

import dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import model.Inventory;

@WebServlet(name = "InventoryController", urlPatterns = {"/inventory"})
public class InventoryController extends HttpServlet {

    private final InventoryDAO inventoryDao = new InventoryDAO();

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

            request.getRequestDispatcher("adminDashboard/inventory-by-warehouse.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid warehouse id format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controller hiển thị tồn kho và danh sách hàng sắp hết cho warehouse";
    }
}
