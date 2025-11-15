/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dao.CategoryDAO;
import dao.MaterialDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Product;
import model.User;

@WebServlet(name="AdminCategoryController", urlPatterns={"/admin-categories"})
public class AdminCategoryController extends HttpServlet {
    
    ProductDAO productDao = new ProductDAO();
    CategoryDAO categoryDao = new CategoryDAO();
    MaterialDAO materialDao = new MaterialDAO();
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminCategoryController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminCategoryController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        List<Category> categories = categoryDao.getAll();
        String search = request.getParameter("search");
        if(search != null){
            String keySearch = search.toLowerCase();
            categories = categories.stream().filter(p ->
                (p.getName() != null && p.getName().toLowerCase().contains(keySearch)) ||
                (p.getDescription() != null && p.getDescription().toLowerCase().contains(keySearch))  
            ).toList();
        }
        request.setAttribute("search", search);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("admin/categories-view.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if("delete".equalsIgnoreCase(action)){
            String idStr = request.getParameter("deleteId");
            Long id = Long.parseLong(idStr);
            this.delete(request, response, id);
            return;
        } else if("update".equalsIgnoreCase(action)){
            String idStr = request.getParameter("productId");
            Long id = Long.parseLong(idStr);
            this.update(request, response, id);
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description").trim();
        Category c = new Category();
        c.setName(name);
        c.setDescription(description);
        c.setSlug(categoryDao.createSlug(name));
        categoryDao.add(c);
        this.doGet(request, response);
    }
    
    protected void delete(HttpServletRequest request, HttpServletResponse respone, Long id) throws ServletException, IOException {
        categoryDao.delete(id);
        this.doGet(request, respone);
    }
    
    protected void update(HttpServletRequest request, HttpServletResponse respone, Long id) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description").trim();

        Category c = categoryDao.getById(id);
        c.setName(name);
        c.setSlug(categoryDao.createSlug(name));
        c.setDescription(description);
        if(c.getParentId() == null){
            c.setParentId(null);
        }
        categoryDao.update(c);
        this.doGet(request, respone);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
