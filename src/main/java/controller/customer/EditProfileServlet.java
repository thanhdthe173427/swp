package controller.customer;

import dao.UserDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/EditProfile")
@MultipartConfig(maxFileSize = 16177215) // ~16MB
public class EditProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dob");

            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
            }

            // Xử lý file ảnh (nếu có)
            Part filePart = request.getPart("avatar");
            String avatarUrl = sessionUser.getAvatar();

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = new File(filePart.getSubmittedFileName()).getName();
                String uploadPath = request.getServletContext().getRealPath("/uploads");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                // Gán đường dẫn ảnh (truy cập qua URL)
                avatarUrl = request.getContextPath() + "/uploads/" + fileName;
            }

            // Cập nhật dữ liệu user
            sessionUser.setFullName(fullName);
            sessionUser.setPhone(phone);
            sessionUser.setDob(dob);
            sessionUser.setAvatar(avatarUrl);

            userDao.updateUser(sessionUser);

            // Cập nhật lại session
            session.setAttribute("user", sessionUser);

            // Chuyển hướng về ViewProfile
            response.sendRedirect(request.getContextPath() + "/ViewProfile");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Cập nhật hồ sơ thất bại: " + e.getMessage());
            request.getRequestDispatcher("/Customer/editProfile.jsp").forward(request, response);
        }
    }
}
