<%-- 
    Document   : pt-feedback-detail
    Created on : Jun 16, 2025, 10:39:38 PM
    Author     : maile
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phản hồi | CoreFit Gym</title>
    <link href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet">
</head>
<body class="g-sidenav-show bg-gray-100">
    <main class="container mt-5">
        <h2 class="mb-4">Chi tiết phản hồi</h2>
        <c:if test="${not empty feedback}">
            <ul class="list-group">
                <li class="list-group-item"><strong>Email khách:</strong> ${feedback.guestEmail}</li>
                <li class="list-group-item"><strong>Nội dung:</strong> ${feedback.content}</li>
                <li class="list-group-item"><strong>Trạng thái:</strong> ${feedback.status}</li>
                <li class="list-group-item"><strong>Phản hồi từ PT:</strong> ${feedback.response}</li>
                <li class="list-group-item"><strong>Ngày gửi:</strong> ${feedback.createdAt}</li>
                <li class="list-group-item"><strong>Ngày phản hồi:</strong> ${feedback.respondedAt}</li>
            </ul>
        </c:if>
        <div class="mt-3">
            <a href="pt-feedback" class="btn btn-secondary">← Quay lại danh sách</a>
        </div>
    </main>
</body>
</html>
