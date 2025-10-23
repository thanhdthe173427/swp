<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .sidebar {
        width: 250px;
        background-color: #fff;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
        padding: 25px 0;
        border: 1px solid #ffcce0;
    }
    .sidebar h3 {
        color: #e60073;
        font-size: 18px;
        padding: 0 25px;
        border-bottom: 1px solid #ffe6f2;
        padding-bottom: 10px;
        margin-top: 0;
    }
    .sidebar ul {
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .sidebar li a {
        display: block;
        padding: 12px 25px;
        text-decoration: none;
        color: #555;
        font-size: 14px;
        transition: 0.3s;
    }
    .sidebar li a:hover {
        background-color: #fff0f5;
        color: #e60073;
        border-left: 3px solid #e60073;
    }
</style>

<aside class="sidebar">

    <h3>Danh mục sản phẩm</h3>
    <ul>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=bouquet">Hoa bó</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=birthday">Hoa sinh nhật</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=funeral">Hoa chia buồn</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=opening">Hoa khai trương</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=congrats">Hoa chúc mừng</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=love">Hoa tình yêu</a></li>
        <li><a href="<%= request.getContextPath()%>/CategoryProduct?category=graduation">Hoa tốt nghiệp</a></li>
    </ul>

</ul>
</aside>
