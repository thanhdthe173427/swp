package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ✅ UserDAO - xử lý CRUD cho bảng `users`
 * Có hỗ trợ cột avatar
 */
public class UserDao extends DBContext {

    /** ✅ Lấy toàn bộ người dùng */
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, email, phone, password_hash, full_name, dob, role, status, avatar, created_at, updated_at FROM users";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = extractUser(rs);
                list.add(u);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi getAllUsers(): " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /** ✅ Lấy user theo ID */
    public User getUserById(long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi getUserById(): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /** ✅ Thêm mới user (có avatar) */
    public void insertUser(User user) {
        String sql = "INSERT INTO users (email, phone, password_hash, full_name, dob, role, status, avatar, created_at, updated_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName());

            if (user.getDob() != null) {
                ps.setDate(5, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, user.getRole());
            ps.setString(7, user.getStatus());
            ps.setString(8, user.getAvatar());

            ps.executeUpdate();
            System.out.println("✅ Thêm user thành công!");

        } catch (SQLException e) {
            System.err.println("❌ Lỗi insertUser(): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** ✅ Cập nhật thông tin user (bao gồm avatar) */
    public void updateUser(User user) {
        String sql = "UPDATE users "
                   + "SET email=?, phone=?, password_hash=?, full_name=?, dob=?, role=?, status=?, avatar=?, updated_at=NOW() "
                   + "WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName());

            if (user.getDob() != null) {
                ps.setDate(5, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, user.getRole());
            ps.setString(7, user.getStatus());
            ps.setString(8, user.getAvatar());
            ps.setLong(9, user.getId());

            ps.executeUpdate();
            System.out.println("✅ Cập nhật user thành công!");

        } catch (SQLException e) {
            System.err.println("❌ Lỗi updateUser(): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** ✅ Xóa user */
    public void deleteUser(long id) {
        String sql = "DELETE FROM users WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();
            System.out.println("🗑️ Xóa user thành công!");

        } catch (SQLException e) {
            System.err.println("❌ Lỗi deleteUser(): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** ✅ Tìm user theo email */
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi findByEmail(): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /** ✅ Đăng nhập (email + password) */
    public User getUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password); // nếu có mã hóa thì dùng BCrypt.checkpw()

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi getUserByEmailAndPassword(): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /** 🧩 Hàm helper chuyển ResultSet → User model (có avatar) */
    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setDob(rs.getDate("dob"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setAvatar(rs.getString("avatar"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
