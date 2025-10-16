package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    private DBContext db;

    public CustomerDAO() {
        db = new DBContext();
    }

    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getLong("id"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setFullName(rs.getString("full_name"));
                u.setDob(rs.getDate("dob"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getCustomerById(Long id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getLong("id"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setFullName(rs.getString("full_name"));
                u.setDob(rs.getDate("dob"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                return u;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateCustomer(User user) {
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, dob=?, status=? WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            if (user.getDob() != null) {
                ps.setDate(4, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setString(5, user.getStatus());
            ps.setLong(6, user.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void changeStatus(Long id, String status) {
        String sql = "UPDATE users SET status=? WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setLong(2, id);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
