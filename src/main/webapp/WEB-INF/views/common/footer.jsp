<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Footer -->
<footer class="bg-light py-4 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>CGMS - Hệ thống quản lý phòng tập</h5>
                <p class="text-muted">Giải pháp quản lý phòng tập chuyên nghiệp</p>
            </div>
            <div class="col-md-3">
                <h5>Liên kết</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/member-packages-controller" class="text-decoration-none">Gói tập</a></li>
                    <li><a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Đăng nhập</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Liên hệ</h5>
                <address>
                    <strong>CGMS</strong><br>
                    123 Đường ABC, Quận XYZ<br>
                    TP. Hồ Chí Minh, Việt Nam<br>
                    <abbr title="Điện thoại">Điện thoại:</abbr> (123) 456-7890
                </address>
            </div>
        </div>
        <hr>
        <div class="text-center">
            <p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> CGMS. All rights reserved.</p>
        </div>
    </div>
</footer>
<!-- End Footer --> 