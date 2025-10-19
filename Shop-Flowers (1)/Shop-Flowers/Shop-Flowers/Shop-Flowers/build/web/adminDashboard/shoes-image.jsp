<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Dashboard admin</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="${pageContext.request.contextPath}/assets2/img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="${pageContext.request.contextPath}/assets2/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets2/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <!-- Customized Bootstrap Stylesheet -->
        <link href="${pageContext.request.contextPath}/assets2/css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="${pageContext.request.contextPath}/assets2/css/style.css" rel="stylesheet">
    </head>

    <body>
        <%
    String loginMessage = (String) request.getAttribute("loginMessage");
    if (loginMessage != null) {
        %>
        <script type="text/javascript">
            window.onload = function () {
                alert('<%= loginMessage %>');
            };
        </script>
        <%
            }
        %>
        <div class="container-xxl position-relative bg-white d-flex p-0">
            <!-- Spinner Start -->
            <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>
            <!-- Spinner End -->


            <!-- Sidebar Start -->
            <div class="sidebar pe-4 pb-3">
                <nav class="navbar bg-light navbar-light">

                    <div class="d-flex align-items-center ms-4 mb-4" style="margin-top: 50px">
                        <div class="position-relative">
                            <img class="rounded-circle" src="${pageContext.request.contextPath}/assets2/img/user.jpg" alt="" style="width: 40px; height: 40px;">
                            <div class="bg-success rounded-circle border border-2 border-white position-absolute end-0 bottom-0 p-1"></div>
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">${user.getUser_Name()}</h6>
                            <span>${user.getRole()}</span>
                        </div>
                    </div>
                    <div class="navbar-nav w-100">
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle active" data-bs-toggle="dropdown"><i class=" fas fa-shoe-prints me-2"></i>Shoes</a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="shoes" class="dropdown-item" style="margin-left: 50px">List shoes</a>
                                <a href="shoesimage" class="dropdown-item" style="margin-left: 50px">Image shoes</a>
                                <a href="shoesvariant" class="dropdown-item" style="margin-left: 50px">Variant shoes</a>
                            </div>
                        </div>
                        <a href="brand" class="nav-item nav-link"><i class="fa fa-th me-2"></i>Category</a>
                        <a href="logout" class="nav-item nav-link"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
                        <!--                    <a href="table.html" class="nav-item nav-link"><i class="fa fa-table me-2"></i>Tables</a>
                                            <a href="chart.html" class="nav-item nav-link"><i class="fa fa-chart-bar me-2"></i>Charts</a>-->
                        <!--                    <div class="nav-item dropdown">
                                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown"><i class="far fa-file-alt me-2"></i>Pages</a>
                                                <div class="dropdown-menu bg-transparent border-0">
                                                    <a href="signin.html" class="dropdown-item">Sign In</a>
                                                    <a href="signup.html" class="dropdown-item">Sign Up</a>
                                                    <a href="404.html" class="dropdown-item">404 Error</a>
                                                    <a href="blank.html" class="dropdown-item">Blank Page</a>
                                                </div>
                                            </div>-->
                    </div>
                </nav>
            </div>
            <!-- Sidebar End -->
            <style>
                .thumbnail-container {
                    flex-wrap: wrap;
                    gap: 100px;
                    max-width: 3000px;
                }
                .thumbnail {
                    width: 100px;
                    height: 100px;

                }
                .main-image {
                    width: 323px;
                    height: 200px;
                    margin-bottom: 10px;
                }
            </style>
            <script>
                function changeImage(src, variantId) {
                    document.getElementById("mainImg-" + variantId).src = src;
                }
            </script>
            <!-- Content Start -->
            <div class="content">
                <!-- Recent Sales Start -->
                <div class="container-fluid pt-4 px-4"><div class="row g-4 ">
                        <c:forEach items="${listVariant}" var="listVariant">
                            <div class="col-md-4">
                                <div class="card" style="width: 100%;">
                                    <c:set var="hasMainImage" value="false" />
                                    
                                    <c:forEach items="${listImage}" var="listImage">
                                        <c:if test="${listVariant.getPv_id() == listImage.getPv_id() && hasMainImage == false}">
                                            <img src="${listImage.getImage_url()}" id="mainImg-${listVariant.getPv_id()}" 
                                                 class="card-img-top main-image" alt="Main Image">
                                            <c:set var="hasMainImage" value="true" />
                                        </c:if>
                                    </c:forEach>

                                    
                                    <div class="thumbnail-container" style="display: flex; justify-content: center; gap: 10px;">
                                        <c:forEach items="${listImage}" var="listImage">
                                            <c:if test="${listVariant.getPv_id() == listImage.getPv_id()}">
                                                <c:if test="${listImage.getImage_url() ne 'assets/img/404.jpg'}">
                                                    <img class="thumbnail" src="${listImage.getImage_url()}" 
                                                     onclick="changeImage('${listImage.getImage_url()}', '${listVariant.getPv_id()}')">
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                    <div class="card-body">
                                        <c:forEach items="${listPro}" var="listPro">
                                            <c:if test="${listVariant.getProduct_id() == listPro.getProductID()}">
                                                <h5 class="card-title">Name: ${listPro.getProductName()}</h5>
                                            </c:if>
                                        </c:forEach>
                                        <h5 class="card-title">Color: ${listVariant.getColor()}</h5>

                                        <c:set var="hasValidImage" value="false" />

                                        <c:forEach items="${listImage}" var="listImage">
                                            <c:if test="${listVariant.getPv_id() == listImage.getPv_id()}">
                                                <c:if test="${listImage.getImage_url() ne 'assets/img/404.jpg'}">
                                                    <c:set var="hasValidImage" value="true" />
                                                </c:if>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${hasValidImage}">
                                            <form action="shoesimage" method="post">
                                                <input type="hidden" name="pvid" value="${listVariant.getPv_id()}">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="submit" value="Delete images" class="btn btn-danger">
                                            </form>
                                        </c:if>

                                        <c:if test="${not hasValidImage}">
                                            <button data-pvid="${listVariant.getPv_id()}" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                                                Add images
                                            </button>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        let modal = document.getElementById("exampleModal");
                        modal.addEventListener("show.bs.modal", function (event) {
                            let button = event.relatedTarget;  
                            let pvid = button.getAttribute("data-pvid"); 
                            document.getElementById("pvidInput").value = pvid; 
                        });
                    });
                </script>
                <!-- Recent Sales End -->
                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Add image</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div> 
                            <form action="shoesimage" method="post" enctype="multipart/form-data">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <input type="hidden" id="pvidInput" name="pvid">
                                        <input type="hidden" class="form-control" name="action" value="addimage">
                                        <label for="exampleInputEmail1" class="form-label">Image:</label>
                                        <input type="file" class="form-control" name="imageA" multiple>

                                    </div>

                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <input type="submit" class="btn btn-primary" value="Add">
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
            <!-- Content End -->


            <!-- Back to Top -->
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/easing/easing.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/waypoints/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/tempusdominus/js/moment.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets2/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <!-- Template Javascript -->
        <script src="${pageContext.request.contextPath}/assets2/js/main.js"></script>
    </body>

</html>