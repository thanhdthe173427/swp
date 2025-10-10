package dao;

import model.Address;
import java.sql.*;
import java.util.*;

public class AddressDAO {

    private Connection conn;

    public AddressDAO(Connection conn) {
        this.conn = conn;
    }

    // ✅ Hàm lấy địa chỉ mặc định của user (trả về 1 Address)
    public Address getDefaultAddressByUserId(long userId) {
        Address address = null;
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_default = TRUE LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                address = extractAddressFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu user chưa có địa chỉ mặc định → lấy địa chỉ đầu tiên
        if (address == null) {
            String fallbackSql = "SELECT * FROM addresses WHERE user_id = ? LIMIT 1";
            try (PreparedStatement ps2 = conn.prepareStatement(fallbackSql)) {
                ps2.setLong(1, userId);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) {
                    address = extractAddressFromResultSet(rs2);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return address;
    }

    // ✅ Hàm chỉ lấy chuỗi địa chỉ (dành cho hiển thị nhanh)
    public String getFullAddressByUserId(long userId) {
        String fullAddress = null;
        String sql = "SELECT full_address FROM addresses WHERE user_id = ? AND is_default = TRUE LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fullAddress = rs.getString("full_address");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu không có địa chỉ mặc định → lấy bất kỳ địa chỉ nào
        if (fullAddress == null) {
            String fallbackSql = "SELECT full_address FROM addresses WHERE user_id = ? LIMIT 1";
            try (PreparedStatement ps2 = conn.prepareStatement(fallbackSql)) {
                ps2.setLong(1, userId);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) {
                    fullAddress = rs2.getString("full_address");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return fullAddress;
    }

    // ✅ Lấy danh sách tất cả địa chỉ của 1 user
    public List<Address> getAddressesByUserId(long userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAddressFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy 1 địa chỉ theo ID
    public Address getAddressById(long id) {
        Address a = null;
        String sql = "SELECT * FROM addresses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = extractAddressFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }

    // ✅ Cập nhật địa chỉ
    public void updateAddress(Address a) {
        String sql = "UPDATE addresses SET full_address=?, recipient_name=?, phone=?, is_default=?, updated_at=NOW() WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullAddress());
            ps.setString(2, a.getRecipientName());
            ps.setString(3, a.getPhone());
            ps.setBoolean(4, a.isDefault());
            ps.setLong(5, a.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ================== Helper method ==================
    private Address extractAddressFromResultSet(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setId(rs.getLong("id"));
        a.setUserId(rs.getLong("user_id"));
        a.setFullAddress(rs.getString("full_address"));
        a.setRecipientName(rs.getString("recipient_name"));
        a.setPhone(rs.getString("phone"));
        a.setDefault(rs.getBoolean("is_default"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        return a;
    }
}
