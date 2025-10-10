package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    private final DBContext db;

    public CustomerDAO() {
        db = new DBContext();
    }

    /** ✅ Cho phép lấy connection cho DAO khác */
    public Connection getConnection() {
        return db.getConnection();
    }

    /** ✅ Helper: Chuyển ResultSet → User */
    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setFullName(rs.getString("full_name"));
        u.setDob(rs.getDate("dob"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }

    /** ✅ Lấy tất cả khách hàng */
    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, email, phone, full_name, dob, role, status, created_at, updated_at "
                   + "FROM users WHERE role = 'customer' "
                   + "ORDER BY id ASC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractUser(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error in getAllCustomers(): " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /** ✅ Lấy khách hàng theo ID */
    public User getCustomerById(Long id) {
        String sql = "SELECT id, email, phone, full_name, dob, role, status, created_at, updated_at "
                   + "FROM users WHERE id = ? AND role = 'customer'";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error in getCustomerById(): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /** ✅ Cập nhật thông tin khách hàng */
    public void updateCustomer(User user) {
        String sql = "UPDATE users "
                   + "SET full_name=?, email=?, phone=?, dob=?, status=?, updated_at=NOW() "
                   + "WHERE id=?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());

            if (user.getDob() != null) {
                ps.setDate(4, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            ps.setString(5, user.getStatus());
            ps.setLong(6, user.getId());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error in updateCustomer(): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** ✅ Đổi trạng thái khách hàng */
    public void changeStatus(Long id, String status) {
        String sql = "UPDATE users SET status=?, updated_at=NOW() WHERE id=?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setLong(2, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error in changeStatus(): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** ✅ Tìm kiếm theo tên + lọc theo trạng thái */
    public List<User> searchCustomersByNameAndStatus(String name, String status) {
        List<User> list = new ArrayList<>();

        // Chuẩn hóa input
        name = (name == null) ? "" : name.trim();
        status = (status == null || status.trim().isEmpty()) ? "all" : status.trim().toLowerCase();

        // Debug log
        System.out.println("=== SEARCH DEBUG ===");
        System.out.println("Search name: [" + name + "] (length: " + name.length() + ")");
        System.out.println("Status filter: [" + status + "]");

        // Base query
        StringBuilder sql = new StringBuilder("SELECT id, email, phone, full_name, dob, role, status, created_at, updated_at "
                                            + "FROM users WHERE role = 'customer'");

        boolean hasNameFilter = !name.isEmpty();
        boolean hasStatusFilter = !"all".equalsIgnoreCase(status);

        System.out.println("Has name filter: " + hasNameFilter);
        System.out.println("Has status filter: " + hasStatusFilter);

        // Thêm điều kiện lọc
        if (hasNameFilter) {
            sql.append(" AND full_name LIKE ?");
        }
        if (hasStatusFilter) {
            sql.append(" AND status = ?");
        }

        sql.append(" ORDER BY id DESC");

        System.out.println("SQL Query: " + sql.toString());

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (hasNameFilter) {
                String searchParam = "%" + name + "%";
                ps.setString(paramIndex++, searchParam);
                System.out.println("Param " + (paramIndex - 1) + ": " + searchParam);
            }

            if (hasStatusFilter) {
                ps.setString(paramIndex++, status);
                System.out.println("Param " + (paramIndex - 1) + ": " + status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = extractUser(rs);
                    list.add(user);
                    System.out.println("  - Found: " + user.getFullName() + " (" + user.getStatus() + ")");
                }
            }

            System.out.println("Total found: " + list.size() + " customers");
            System.out.println("===================");

        } catch (SQLException e) {
            System.err.println("❌ Error in searchCustomersByNameAndStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
}
