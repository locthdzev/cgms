<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Services.StatsService" %>
<%@ page import="Services.UserService" %>
<%@ page import="DAOs.PackageDAO" %>
<%@ page import="Models.Package" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.stream.Collectors" %>
<%
    StatsService statsService = new StatsService();
    int activeMembersCount = statsService.getActiveMembersCount();
    int activeTrainersCount = statsService.getActiveTrainersCount();
    int activePackagesCount = statsService.getActivePackagesCount();

    // Lấy danh sách gói tập đang hoạt động cho Guest
    PackageDAO packageDAO = new PackageDAO();
    List<Package> activePackages = packageDAO.getAllActivePackages();
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    // Lấy danh sách Personal Trainers cho Guest
    UserService userService = new UserService();
    List<User> allUsers = userService.getAllUsers();
    List<User> activeTrainers = allUsers.stream()
            .filter(user -> "Personal Trainer".equals(user.getRole()) && "Active".equals(user.getStatus()))
            .collect(Collectors.toList());
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8"/>
    <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <link
            rel="apple-touch-icon"
            sizes="76x76"
            href="assets/img/icons8-gym-96.png"
    />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png"/>
    <title>CORE-FIT GYM</title>
    <!-- Fonts and icons -->
    <link
            href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800"
            rel="stylesheet"
    />
    <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap"
            rel="stylesheet"
    />
    <link href="assets/css/nucleo-icons.css" rel="stylesheet"/>
    <link href="assets/css/nucleo-svg.css" rel="stylesheet"/>
    <script
            src="https://kit.fontawesome.com/42d5adcbca.js"
            crossorigin="anonymous"
    ></script>
    <!-- CSS Files -->
    <link
            id="pagestyle"
            href="assets/css/soft-design-system.css"
            rel="stylesheet"
    />
</head>
<body class="presentation-page">
<!-- Navbar -->
<div class="container position-sticky z-index-sticky top-0">
    <div class="row">
        <div class="col-12">
            <nav
                    class="navbar navbar-expand-lg blur blur-rounded top-0 z-index-fixed shadow position-absolute my-3 py-2 start-0 end-0 mx-4"
            >
                <div class="container-fluid px-0">
                    <a
                            class="navbar-brand font-weight-bolder ms-sm-3"
                            href="http://localhost:8080/"
                            rel="tooltip"
                            title="Designed and Coded by SWP391_07"
                            data-placement="bottom"
                            target="_blank"
                    >
                        CORE-FIT GYM
                    </a>
                    <button
                            class="navbar-toggler shadow-none ms-2"
                            type="button"
                            data-bs-toggle="collapse"
                            data-bs-target="#navigation"
                            aria-controls="navigation"
                            aria-expanded="false"
                            aria-label="Toggle navigation"
                    >
                <span class="navbar-toggler-icon mt-2">
                  <span class="navbar-toggler-bar bar1"></span>
                  <span class="navbar-toggler-bar bar2"></span>
                  <span class="navbar-toggler-bar bar3"></span>
                </span>
                    </button>
                    <div
                            class="collapse navbar-collapse pt-3 pb-2 py-lg-0 w-100"
                            id="navigation"
                    >
                        <ul class="navbar-nav navbar-nav-hover ms-lg-12 ps-lg-5 w-100">
                            <li class="nav-item mx-2">
                                <a class="nav-link ps-2 cursor-pointer" href="#schedule-section">
                                    Lịch hoạt động
                                </a>
                            </li>
                            <li class="nav-item mx-2">
                                <a class="nav-link ps-2 cursor-pointer" href="#packages-section">
                                    Gói tập
                                </a>
                            </li>
                            <li class="nav-item mx-2">
                                <a class="nav-link ps-2 cursor-pointer" href="#trainers-section">
                                    Huấn luyện viên
                                </a>
                            </li>
                            <li class="nav-item mx-2">
                                <a class="nav-link ps-2 cursor-pointer" href="#equipment-section">
                                    Thiết bị
                                </a>
                            </li>
                            <li class="nav-item mx-2">
                                <a class="nav-link ps-2 cursor-pointer" href="#footer">
                                    Liên hệ
                                </a>
                            </li>
                            <li class="nav-item ms-lg-auto">
                                <!-- Đã xóa nút Github -->
                            </li>
                            <li class="nav-item my-auto ms-3 ms-lg-0">
                                <a
                                        href="/login"
                                        class="btn btn-sm btn-outline-dark btn-round mb-0 me-1 mt-2 mt-md-0"
                                >Đăng nhập</a
                                >
                            </li>
                            <li class="nav-item my-auto ms-3 ms-lg-0">
                                <a
                                        href="/register"
                                        class="btn btn-sm text-white bg-dark btn-round mb-0 me-1 mt-2 mt-md-0"
                                >Đăng ký</a
                                >
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            <!-- End Navbar -->
        </div>
    </div>
</div>
<header class="header-2">
    <div
            class="page-header min-vh-75 relative"
            style="
          background-image: url('https://images.pexels.com/photos/16513600/pexels-photo-16513600/free-photo-of-phong-th-d-c-thi-t-b-t-p-th-d-c-ren-luy-n-s-c-m-nh-trung-tam-th-d-c.jpeg?q=80&w=2973&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
        "
    >
        <div class="container">
            <div class="row">
                <div class="col-lg-7 text-center mx-auto">
                    <h1 class="text-white pt-3 mt-n5"
                        style="font-family: 'Poppins', sans-serif; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.3);">
                        CORE-FIT GYM</h1>
                    <p class="lead text-white mt-3"
                       style="font-family: 'Inter', sans-serif; font-weight: 300; letter-spacing: 0.5px; line-height: 1.8;">
                        Nâng cao sức khỏe, thay đổi ngoại hình và cải thiện cuộc sống.<br/>
                        <span style="font-style: italic;">Hãy để chúng tôi đồng hành cùng bạn trên hành trình chinh phục bản thân.</span>
                    </p>
                    <a href="/register" class="btn btn-lg btn-white mt-3"
                       style="font-weight: 600; border-radius: 8px; padding: 12px 35px; box-shadow: 0 4px 15px rgba(255, 255, 255, 0.2); transition: all 0.3s ease;">Bắt
                        đầu ngay</a>
                </div>
            </div>
        </div>
        <div class="position-absolute w-100 z-index-1 bottom-0">
            <svg
                    class="waves"
                    xmlns="http://www.w3.org/2000/svg"
                    xmlns:xlink="http://www.w3.org/1999/xlink"
                    viewBox="0 24 150 40"
                    preserveAspectRatio="none"
                    shape-rendering="auto"
            >
                <defs>
                    <path
                            id="gentle-wave"
                            d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"
                    />
                </defs>
                <g class="moving-waves">
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="-1"
                            fill="rgba(255,255,255,0.40"
                    />
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="3"
                            fill="rgba(255,255,255,0.35)"
                    />
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="5"
                            fill="rgba(255,255,255,0.25)"
                    />
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="8"
                            fill="rgba(255,255,255,0.20)"
                    />
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="13"
                            fill="rgba(255,255,255,0.15)"
                    />
                    <use
                            xlink:href="#gentle-wave"
                            x="48"
                            y="16"
                            fill="rgba(255,255,255,0.95"
                    />
                </g>
            </svg>
        </div>
    </div>
</header>
<section class="pt-3 pb-4" id="count-stats">
    <div class="container">
        <div class="row">
            <div
                    class="col-lg-9 z-index-2 border-radius-xl mt-n10 mx-auto py-3 blur shadow-blur"
            >
                <div class="row">
                    <div class="col-md-4 position-relative">
                        <div class="p-3 text-center">
                            <h1 class="text-gradient text-dark">
                                <span id="state1" countTo="<%= activeMembersCount %>">0</span>+
                            </h1>
                            <h5 class="mt-3">Thành viên tích cực</h5>
                            <p class="text-sm">
                                Hơn <%= activeMembersCount %> thành viên đang tập luyện và đạt được mục tiêu sức khỏe
                                cùng chúng tôi.
                            </p>
                        </div>
                        <hr class="vertical dark"/>
                    </div>
                    <div class="col-md-4 position-relative">
                        <div class="p-3 text-center">
                            <h1 class="text-gradient text-dark">
                                <span id="state2" countTo="<%= activeTrainersCount %>">0</span>+
                            </h1>
                            <h5 class="mt-3">Huấn luyện viên chuyên nghiệp</h5>
                            <p class="text-sm">
                                Đội ngũ PT giàu kinh nghiệm, được đào tạo bài bản và sẵn sàng hỗ trợ bạn.
                            </p>
                        </div>
                        <hr class="vertical dark"/>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 text-center">
                            <h1 class="text-gradient text-dark" id="state3" countTo="<%= activePackagesCount %>">
                                0
                            </h1>
                            <h5 class="mt-3">Gói tập đa dạng</h5>
                            <p class="text-sm">
                                Từ tập luyện cá nhân đến các lớp nhóm sôi động, chúng tôi có đầy đủ các gói phù hợp với
                                nhu cầu của bạn.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Schedule Section -->
<section class="my-5 py-5" id="schedule-section"
         style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); position: relative; overflow: hidden;">
    <!-- Background decoration -->
    <div class="position-absolute w-100 h-100" style="top: 0; left: 0; opacity: 0.1;">
        <div style="position: absolute; top: 15%; left: 8%; width: 120px; height: 120px; border: 3px solid rgba(255,255,255,0.6); border-radius: 50%; transform: rotate(45deg);"></div>
        <div style="position: absolute; top: 50%; right: 5%; width: 100px; height: 100px; border: 3px solid rgba(255,255,255,0.6); border-radius: 50%;"></div>
        <div style="position: absolute; bottom: 15%; left: 20%; width: 80px; height: 80px; border: 3px solid rgba(255,255,255,0.6); transform: rotate(45deg);"></div>
        <div style="position: absolute; top: 25%; right: 25%; width: 60px; height: 60px; background: rgba(255,255,255,0.1); border-radius: 50%;"></div>
    </div>

    <div class="container position-relative">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-8">
                <div class="mb-4">
                    <div style="display: inline-block; padding: 15px 35px; background: rgba(255,255,255,0.3); border-radius: 60px; backdrop-filter: blur(15px); border: 2px solid rgba(255,255,255,0.4); box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                        <i class="fas fa-clock" style="color: #2d3748; font-size: 2.8rem;"></i>
                    </div>
                </div>
                <h2 class="text-dark mb-0" style="font-weight: 800; letter-spacing: 1px; font-size: 2.5rem;">Lịch hoạt
                    động</h2>
                <h3 class="text-dark mb-4" style="font-weight: 300; opacity: 0.7; font-size: 1.3rem;">CoreFit Gym luôn
                    sẵn sàng phục vụ bạn</h3>
                <p class="lead text-dark" style="opacity: 0.6; line-height: 1.8; font-size: 1.1rem;">
                    Chúng tôi mở cửa 6 ngày trong tuần với thời gian linh hoạt,
                    giúp bạn dễ dàng sắp xếp lịch tập phù hợp với cuộc sống bận rộn.
                </p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-12">
                <!-- Weekdays in a horizontal scrollable layout -->
                <div class="schedule-container"
                     style="background: rgba(255,255,255,0.4); border-radius: 30px; padding: 40px; backdrop-filter: blur(20px); border: 2px solid rgba(255,255,255,0.5); box-shadow: 0 25px 70px rgba(0,0,0,0.1);">
                    <div class="row g-4">
                        <!-- Monday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #42e695 0%, #3bb2b8 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(66, 230, 149, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-white mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ
                                        HAI</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-white mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(255,255,255,0.4); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Tuesday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-white mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ BA</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-white mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(255,255,255,0.4); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Wednesday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(240, 147, 251, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-white mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ TƯ</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-white mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(255,255,255,0.4); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Thursday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(79, 172, 254, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-white mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ
                                        NĂM</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-white mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(255,255,255,0.4); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Friday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(250, 112, 154, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-white mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ
                                        SÁU</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-white mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(255,255,255,0.4); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Saturday -->
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="day-card text-center"
                                 style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); border-radius: 25px; padding: 30px 20px; box-shadow: 0 15px 40px rgba(168, 237, 234, 0.4); transition: all 0.4s ease; position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.2);">
                                <div class="day-bg"
                                     style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-3"
                                         style="width: 50px; height: 50px; background: rgba(255,255,255,0.2); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-dark" style="font-size: 1.2rem;"></i>
                                    </div>
                                    <h6 class="text-dark mb-2" style="font-weight: 700; font-size: 0.9rem;">THỨ BẢY</h6>
                                    <div class="time-badge"
                                         style="background: rgba(255,255,255,0.3); border-radius: 20px; padding: 8px 15px; margin-bottom: 10px;">
                                        <p class="text-dark mb-0" style="font-size: 0.85rem; font-weight: 600;">7:00 -
                                            22:00</p>
                                    </div>
                                    <div style="width: 30px; height: 3px; background: rgba(0,0,0,0.2); border-radius: 2px; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sunday Special Card -->
                    <div class="row justify-content-center mt-4">
                        <div class="col-lg-4 col-md-6">
                            <div class="sunday-card text-center"
                                 style="background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%); border-radius: 25px; padding: 40px 30px; box-shadow: 0 20px 50px rgba(210, 153, 194, 0.4); position: relative; overflow: hidden; border: 3px solid rgba(255,255,255,0.3);">
                                <div class="day-bg"
                                     style="position: absolute; top: -40px; right: -40px; width: 120px; height: 120px; background: rgba(255,255,255,0.1); border-radius: 50%; opacity: 0.6;"></div>
                                <div style="position: relative; z-index: 2;">
                                    <div class="day-icon mb-4"
                                         style="width: 70px; height: 70px; background: rgba(255,255,255,0.3); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-bed text-dark" style="font-size: 2rem;"></i>
                                    </div>
                                    <h4 class="text-dark mb-3" style="font-weight: 700;">CHỦ NHẬT</h4>
                                    <div class="closed-badge"
                                         style="background: rgba(255,255,255,0.4); border-radius: 25px; padding: 12px 25px; margin-bottom: 15px; display: inline-block;">
                                        <p class="text-dark mb-0" style="font-size: 1.1rem; font-weight: 700;">NGHỈ</p>
                                    </div>
                                    <p class="text-dark mb-0" style="font-size: 0.9rem; opacity: 0.7;">Thời gian nghỉ
                                        ngơi để phục hồi</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
    #schedule-section .day-card:hover {
        transform: translateY(-15px) scale(1.08);
        box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25) !important;
    }

    #schedule-section .sunday-card:hover {
        transform: translateY(-10px) scale(1.05);
        box-shadow: 0 30px 70px rgba(210, 153, 194, 0.6) !important;
    }

    #schedule-section .day-icon {
        transition: all 0.3s ease;
    }

    #schedule-section .day-card:hover .day-icon {
        transform: scale(1.2) rotate(15deg);
    }

    #schedule-section .sunday-card:hover .day-icon {
        transform: scale(1.1) rotate(-10deg);
    }

    #schedule-section .time-badge {
        transition: all 0.3s ease;
    }

    #schedule-section .day-card:hover .time-badge {
        background: rgba(255, 255, 255, 0.5) !important;
        transform: scale(1.05);
    }

    /* Responsive grid for mobile */
    @media (max-width: 1200px) {
        #schedule-section .col-lg-2 {
            flex: 0 0 auto;
            width: 33.33333333%;
        }
    }

    @media (max-width: 992px) {
        #schedule-section .col-lg-2 {
            flex: 0 0 auto;
            width: 50%;
        }

        #schedule-section .day-card {
            padding: 25px 15px !important;
        }

        #schedule-section .schedule-container {
            padding: 30px !important;
        }

        #schedule-section h2 {
            font-size: 2rem !important;
        }
    }

    @media (max-width: 768px) {
        #schedule-section .col-lg-2 {
            flex: 0 0 auto;
            width: 50%;
        }

        #schedule-section .day-card {
            padding: 20px 12px !important;
        }

        #schedule-section .schedule-container {
            padding: 25px !important;
        }

        #schedule-section h2 {
            font-size: 1.8rem !important;
        }

        #schedule-section h3 {
            font-size: 1.1rem !important;
        }

        #schedule-section .lead {
            font-size: 1rem !important;
        }

        #schedule-section .day-icon {
            width: 40px !important;
            height: 40px !important;
        }

        #schedule-section .day-icon i {
            font-size: 1rem !important;
        }
    }

    @media (max-width: 576px) {
        #schedule-section .col-lg-2 {
            flex: 0 0 auto;
            width: 100%;
            margin-bottom: 15px;
        }

        #schedule-section .day-card {
            padding: 25px 20px !important;
        }

        #schedule-section .schedule-container {
            padding: 20px !important;
        }

        #schedule-section h2 {
            font-size: 1.6rem !important;
        }

        #schedule-section .sunday-card {
            padding: 30px 25px !important;
        }

        #schedule-section .col-lg-4 {
            flex: 0 0 auto;
            width: 100%;
        }
    }

    /* Animation for schedule cards */
    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(50px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes bounceIn {
        0% {
            opacity: 0;
            transform: scale(0.3);
        }
        50% {
            opacity: 1;
            transform: scale(1.1);
        }
        100% {
            opacity: 1;
            transform: scale(1);
        }
    }

    #schedule-section .day-card {
        animation: slideInUp 0.6s ease forwards;
    }

    #schedule-section .day-card:nth-child(1) {
        animation-delay: 0.1s;
    }

    #schedule-section .day-card:nth-child(2) {
        animation-delay: 0.2s;
    }

    #schedule-section .day-card:nth-child(3) {
        animation-delay: 0.3s;
    }

    #schedule-section .day-card:nth-child(4) {
        animation-delay: 0.4s;
    }

    #schedule-section .day-card:nth-child(5) {
        animation-delay: 0.5s;
    }

    #schedule-section .day-card:nth-child(6) {
        animation-delay: 0.6s;
    }

    #schedule-section .sunday-card {
        animation: bounceIn 0.8s ease forwards;
        animation-delay: 0.8s;
    }

    /* Glass morphism effect */
    #schedule-section .schedule-container {
        backdrop-filter: blur(25px);
        -webkit-backdrop-filter: blur(25px);
    }

    #schedule-section .day-card {
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
    }

    /* Pulse animation for Sunday card */
    #schedule-section .sunday-card .day-icon {
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
        100% {
            transform: scale(1);
        }
    }
</style>

<!-- Packages Section for Guests -->
<section class="my-5 py-5" id="packages-section">
    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-8">
                <h2 class="text-dark mb-0">Các gói tập của chúng tôi</h2>
                <h2 class="text-primary text-gradient">Lựa chọn phù hợp cho mọi nhu cầu</h2>
                <p class="lead">
                    Khám phá các gói tập đa dạng được thiết kế đặc biệt để đáp ứng mục tiêu và ngân sách của bạn.
                    Từ gói cơ bản đến gói cao cấp, chúng tôi có tất cả những gì bạn cần.
                </p>
            </div>
        </div>

        <div class="row">
            <%
                if (activePackages != null && !activePackages.isEmpty()) {
                    for (Package pkg : activePackages) {
            %>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card shadow-lg h-100 package-card"
                     style="transition: all 0.3s ease; border: none; border-radius: 20px; overflow: hidden; position: relative;">
                    <% if ("Premium".equals(pkg.getName()) || pkg.getName().toLowerCase().contains("premium") || pkg.getName().toLowerCase().contains("vip")) { %>
                    <div class="position-absolute" style="top: 15px; right: 15px; z-index: 10;">
                  <span class="badge text-dark"
                        style="background: linear-gradient(135deg, #FFD700, #FFA500); padding: 8px 16px; border-radius: 25px; font-weight: 600; font-size: 0.75rem; box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);">
                    <i class="fas fa-crown me-1"></i>Premium
                  </span>
                    </div>
                    <% } %>

                    <div class="card-header text-center position-relative"
                         style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 2.5rem 2rem; border: none;">
                        <h3 class="text-white mb-3 font-weight-bold" style="letter-spacing: 1px;"><%= pkg.getName() %>
                        </h3>
                        <div class="price-section">
                            <h1 class="text-white font-weight-bolder mb-0"
                                style="font-size: 2.5rem; text-shadow: 0 2px 10px rgba(0,0,0,0.3);">
                                <%= currencyFormat.format(pkg.getPrice()) %>
                            </h1>
                            <p class="text-white opacity-9 mb-0" style="font-size: 1rem; margin-top: 8px;">
                                <i class="fas fa-calendar-alt me-1"></i><%= pkg.getDuration() %> ngày
                            </p>
                        </div>
                    </div>

                    <div class="card-body d-flex flex-column" style="padding: 2rem;">
                        <div class="flex-grow-1">
                            <div class="features-list">
                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-clock text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">Thời hạn sử dụng</span>
                                        <p class="mb-0 text-secondary"
                                           style="font-size: 0.9rem;"><%= pkg.getDuration() %> ngày</p>
                                    </div>
                                </div>

                                <% if (pkg.getSessions() != null && pkg.getSessions() > 0) { %>
                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-dumbbell text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">Số buổi tập</span>
                                        <p class="mb-0 text-secondary"
                                           style="font-size: 0.9rem;"><%= pkg.getSessions() %> buổi</p>
                                    </div>
                                </div>
                                <% } %>

                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-tools text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">Thiết bị tập luyện</span>
                                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Sử dụng đầy đủ thiết
                                            bị hiện đại</p>
                                    </div>
                                </div>

                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-user-tie text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">Hỗ trợ chuyên nghiệp</span>
                                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Tư vấn chương trình
                                            tập phù hợp</p>
                                    </div>
                                </div>

                                <% if ("Premium".equals(pkg.getName()) || pkg.getName().toLowerCase().contains("premium") || pkg.getName().toLowerCase().contains("vip")) { %>
                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.1)); border-radius: 12px; border-left: 4px solid #FFD700;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #FFD700, #FFA500); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-user-graduate text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">PT cá nhân</span>
                                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Huấn luyện viên riêng
                                            1-1</p>
                                    </div>
                                </div>

                                <div class="feature-item mb-3"
                                     style="display: flex; align-items: center; padding: 12px; background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.1)); border-radius: 12px; border-left: 4px solid #FFD700;">
                                    <div class="feature-icon me-3"
                                         style="width: 40px; height: 40px; background: linear-gradient(135deg, #FFD700, #FFA500); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-apple-alt text-white" style="font-size: 0.9rem;"></i>
                                    </div>
                                    <div>
                                        <span class="font-weight-bold text-dark">Chế độ dinh dưỡng</span>
                                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Kế hoạch dinh dưỡng cá
                                            nhân</p>
                                    </div>
                                </div>
                                <% } %>
                            </div>

                            <% if (pkg.getDescription() != null && !pkg.getDescription().trim().isEmpty()) { %>
                            <div class="mt-4 p-3"
                                 style="background: rgba(0,0,0,0.05); border-radius: 12px; border-left: 4px solid #667eea;">
                                <h6 class="text-dark mb-2" style="font-weight: 600;">
                                    <i class="fas fa-info-circle me-2 text-primary"></i>Mô tả gói tập
                                </h6>
                                <p class="text-secondary mb-0"
                                   style="font-size: 0.9rem; line-height: 1.6;"><%= pkg.getDescription() %>
                                </p>
                            </div>
                            <% } %>
                        </div>

                        <div class="mt-4">
                            <a href="/register" class="btn btn-lg w-100"
                               style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); border: none; border-radius: 15px; padding: 15px; font-weight: 700; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4); transition: all 0.3s ease; color: white !important;">
                                <i class="fas fa-rocket me-2"></i>Đăng ký ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <%
                }
            } else {
            %>
            <div class="col-12">
                <div class="alert text-center"
                     style="background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1)); border: none; border-radius: 20px; padding: 3rem;">
                    <div class="mb-3">
                        <i class="fas fa-exclamation-circle" style="font-size: 3rem; color: #667eea;"></i>
                    </div>
                    <h4 class="text-dark mb-3">Hiện tại chưa có gói tập nào!</h4>
                    <p class="text-secondary mb-0" style="font-size: 1.1rem;">Chúng tôi đang cập nhật các gói tập mới.
                        Vui lòng quay lại sau hoặc liên hệ để được tư vấn.</p>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<style>
    .package-card:hover {
        transform: translateY(-10px) scale(1.02);
        box-shadow: 0 25px 50px rgba(102, 126, 234, 0.2) !important;
    }

    #packages-section .card {
        border: none;
        border-radius: 20px;
        overflow: hidden;
        background: white;
        position: relative;
    }

    #packages-section .card-header {
        border: none;
        position: relative;
        overflow: hidden;
    }

    #packages-section .card-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        opacity: 0.3;
    }

    #packages-section .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 30px rgba(40, 167, 69, 0.5) !important;
        background: linear-gradient(135deg, #218838 0%, #1e7e34 100%) !important;
    }

    #packages-section .feature-item {
        transition: all 0.3s ease;
    }

    #packages-section .feature-item:hover {
        transform: translateX(5px);
        background: rgba(102, 126, 234, 0.15) !important;
    }

    #packages-section .price-section h1 {
        position: relative;
        z-index: 2;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        #packages-section .card {
            margin-bottom: 2rem;
        }

        #packages-section .card-header {
            padding: 2rem 1.5rem !important;
        }

        #packages-section .price-section h1 {
            font-size: 2rem !important;
        }

        #packages-section .card-body {
            padding: 1.5rem !important;
        }

        #packages-section .feature-item {
            padding: 10px !important;
        }

        #packages-section .feature-icon {
            width: 35px !important;
            height: 35px !important;
        }
    }

    @media (max-width: 576px) {
        #packages-section .col-lg-4 {
            margin-bottom: 1.5rem;
        }

        #packages-section .card-header h3 {
            font-size: 1.3rem;
        }

        #packages-section .price-section h1 {
            font-size: 1.8rem !important;
        }

        #packages-section .btn {
            font-size: 1rem !important;
            padding: 12px !important;
        }
    }

    /* Animation for loading */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    #packages-section .package-card {
        animation: fadeInUp 0.6s ease forwards;
    }

    #packages-section .package-card:nth-child(1) {
        animation-delay: 0.1s;
    }

    #packages-section .package-card:nth-child(2) {
        animation-delay: 0.2s;
    }

    #packages-section .package-card:nth-child(3) {
        animation-delay: 0.3s;
    }

    /* Gradient text effect */
    #packages-section .text-gradient {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
</style>

<!-- Personal Trainers Section for Guests -->
<section class="my-5 py-5" id="trainers-section" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);">
    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-8">
                <h2 class="text-dark mb-0">Đội ngũ huấn luyện viên</h2>
                <h2 class="text-primary text-gradient">Chuyên nghiệp và tận tâm</h2>
                <p class="lead">
                    Gặp gỡ đội ngũ Personal Trainer giàu kinh nghiệm của chúng tôi.
                    Họ sẵn sàng hỗ trợ bạn đạt được mục tiêu sức khỏe và thể hình một cách hiệu quả nhất.
                </p>
            </div>
        </div>

        <div class="row">
            <%
                if (activeTrainers != null && !activeTrainers.isEmpty()) {
                    for (User trainer : activeTrainers) {
            %>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card trainer-card h-100"
                     style="border: none; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); transition: all 0.3s ease;">
                    <div class="card-header text-center position-relative p-0"
                         style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); height: 180px; display: flex; align-items: center; justify-content: center;">
                        <div class="trainer-avatar"
                             style="width: 120px; height: 120px; border-radius: 50%; overflow: hidden; border: 5px solid rgba(255,255,255,0.3); box-shadow: 0 8px 25px rgba(0,0,0,0.2);">
                            <% if (trainer.getGender() != null && trainer.getGender().equalsIgnoreCase("Nữ")) { %>
                            <img src="assets/img/pt-nu.jpg" alt="<%= trainer.getFullName() %>"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                            <img src="assets/img/pt-nam.jpg" alt="<%= trainer.getFullName() %>"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                            <% } %>
                        </div>

                        <div class="position-absolute" style="top: 15px; right: 15px;">
                  <span class="badge text-dark"
                        style="background: rgba(255,255,255,0.9); padding: 8px 15px; border-radius: 25px; font-weight: 700; font-size: 0.75rem; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    <i class="fas fa-dumbbell me-1" style="color: #4facfe;"></i>PERSONAL TRAINER
                  </span>
                        </div>
                    </div>

                    <div class="card-body" style="padding: 2.5rem 2rem;">
                        <div class="text-center mb-4">
                            <h4 class="text-dark mb-2 font-weight-bold"
                                style="font-size: 1.4rem; color: #2d3748 !important;"><%= trainer.getFullName() %>
                            </h4>
                            <% if (trainer.getGender() != null && !trainer.getGender().trim().isEmpty()) { %>
                            <span class="badge"
                                  style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 6px 15px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;">
                    <%= trainer.getGender() %>
                  </span>
                            <% } %>
                        </div>

                        <div class="trainer-info mb-4">
                            <% if (trainer.getExperience() != null && !trainer.getExperience().trim().isEmpty()) { %>
                            <div class="info-item mb-3"
                                 style="display: flex; align-items: center; padding: 12px 16px; background: linear-gradient(135deg, #ffeaa7 0%, #fab1a0 100%); border-radius: 15px; box-shadow: 0 4px 15px rgba(250, 177, 160, 0.3);">
                                <div class="icon-wrapper me-3"
                                     style="width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <i class="fas fa-award" style="color: #d63031; font-size: 1.2rem;"></i>
                                </div>
                                <div>
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.85rem; color: #2d3748 !important;">Kinh nghiệm
                                    </div>
                                    <div class="text-dark"
                                         style="font-size: 0.9rem; color: #4a5568 !important;"><%= trainer.getExperience() %>
                                    </div>
                                </div>
                            </div>
                            <% } %>

                            <% if (trainer.getPhoneNumber() != null && !trainer.getPhoneNumber().trim().isEmpty()) { %>
                            <div class="info-item mb-3"
                                 style="display: flex; align-items: center; padding: 12px 16px; background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); border-radius: 15px; box-shadow: 0 4px 15px rgba(168, 237, 234, 0.3);">
                                <div class="icon-wrapper me-3"
                                     style="width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <img src="assets/svg/icons8-phone.svg" alt="Phone"
                                         style="width: 20px; height: 20px;">
                                </div>
                                <div>
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.85rem; color: #2d3748 !important;">Số điện thoại
                                    </div>
                                    <a href="tel:<%= trainer.getPhoneNumber() %>"
                                       class="text-dark text-decoration-none font-weight-bold"
                                       style="font-size: 0.95rem; color: #4a5568 !important;">
                                        <%= trainer.getPhoneNumber() %>
                                    </a>
                                </div>
                            </div>
                            <% } %>

                            <% if (trainer.getEmail() != null && !trainer.getEmail().trim().isEmpty()) { %>
                            <div class="info-item mb-3"
                                 style="display: flex; align-items: center; padding: 12px 16px; background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); border-radius: 15px; box-shadow: 0 4px 15px rgba(252, 182, 159, 0.3);">
                                <div class="icon-wrapper me-3"
                                     style="width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <img src="assets/svg/icons8-gmail.svg" alt="Gmail"
                                         style="width: 20px; height: 20px;">
                                </div>
                                <div style="flex: 1;">
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.85rem; color: #2d3748 !important;">Email
                                    </div>
                                    <div class="text-dark"
                                         style="font-size: 0.85rem; color: #4a5568 !important; word-break: break-all;"><%= trainer.getEmail() %>
                                    </div>
                                </div>
                            </div>
                            <% } %>

                            <% if (trainer.getZalo() != null && !trainer.getZalo().trim().isEmpty()) { %>
                            <div class="info-item mb-3"
                                 style="display: flex; align-items: center; padding: 12px 16px; background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%); border-radius: 15px; box-shadow: 0 4px 15px rgba(210, 153, 194, 0.3);">
                                <div class="icon-wrapper me-3"
                                     style="width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <img src="assets/svg/icons8-zalo.svg" alt="Zalo" style="width: 20px; height: 20px;">
                                </div>
                                <div>
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.85rem; color: #2d3748 !important;">Zalo
                                    </div>
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.95rem; color: #4a5568 !important;"><%= trainer.getZalo() %>
                                    </div>
                                </div>
                            </div>
                            <% } %>

                            <% if (trainer.getFacebook() != null && !trainer.getFacebook().trim().isEmpty()) { %>
                            <div class="info-item mb-3"
                                 style="display: flex; align-items: center; padding: 12px 16px; background: linear-gradient(135deg, #a8e6cf 0%, #dcedc1 100%); border-radius: 15px; box-shadow: 0 4px 15px rgba(168, 230, 207, 0.3);">
                                <div class="icon-wrapper me-3"
                                     style="width: 40px; height: 40px; background: rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <img src="assets/svg/icons8-facebook.svg" alt="Facebook"
                                         style="width: 20px; height: 20px;">
                                </div>
                                <div>
                                    <div class="text-dark font-weight-bold"
                                         style="font-size: 0.85rem; color: #2d3748 !important;">Facebook
                                    </div>
                                    <a href="<%= trainer.getFacebook().startsWith("http") ? trainer.getFacebook() : "https://facebook.com/" + trainer.getFacebook() %>"
                                       target="_blank" class="text-dark text-decoration-none"
                                       style="font-size: 0.9rem; color: #4a5568 !important; word-break: break-all;"><%= trainer.getFacebook() %>
                                    </a>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <div class="text-center">
                            <div class="dropdown">
                                <button class="btn btn-primary w-100" type="button"
                                        id="contactTrainer<%= trainer.getId() %>" data-bs-toggle="dropdown"
                                        aria-expanded="false"
                                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 25px; padding: 15px 30px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 8px 25px rgba(118, 75, 162, 0.4); transition: all 0.3s ease; font-size: 0.9rem;">
                                    <i class="fas fa-phone me-2"></i>LIÊN HỆ NGAY
                                    <svg width="16px" height="16px" viewBox="0 0 24 24" fill="none"
                                         xmlns="http://www.w3.org/2000/svg" style="margin-left: 8px;">
                                        <path d="M11.8079 14.7695L8.09346 10.3121C7.65924 9.79109 8.02976 9 8.70803 9L15.292 9C15.9702 9 16.3408 9.79108 15.9065 10.3121L12.1921 14.7695C12.0921 14.8895 11.9079 14.8895 11.8079 14.7695Z"
                                              fill="white"/>
                                    </svg>
                                </button>
                                <ul class="dropdown-menu w-100" aria-labelledby="contactTrainer<%= trainer.getId() %>"
                                    style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1); padding: 10px;">
                                    <% if (trainer.getFacebook() != null && !trainer.getFacebook().trim().isEmpty()) { %>
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center"
                                           href="<%= trainer.getFacebook().startsWith("http") ? trainer.getFacebook() : "https://facebook.com/" + trainer.getFacebook() %>"
                                           target="_blank"
                                           style="padding: 15px 20px; border-radius: 15px; margin: 5px 0; background: linear-gradient(135deg, #a8e6cf 0%, #dcedc1 100%); transition: all 0.3s ease;">
                                            <img src="assets/svg/icons8-facebook.svg" alt="Facebook"
                                                 style="width: 24px; height: 24px; margin-right: 12px;">
                                            <span style="font-weight: 600; color: #2d3748;">Liên hệ qua Facebook</span>
                                        </a>
                                    </li>
                                    <% } %>
                                    <% if (trainer.getEmail() != null && !trainer.getEmail().trim().isEmpty()) { %>
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center"
                                           href="https://mail.google.com/mail/?view=cm&fs=1&to=<%= trainer.getEmail() %>"
                                           target="_blank"
                                           style="padding: 15px 20px; border-radius: 15px; margin: 5px 0; background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); transition: all 0.3s ease;">
                                            <img src="assets/svg/icons8-gmail.svg" alt="Gmail"
                                                 style="width: 24px; height: 24px; margin-right: 12px;">
                                            <span style="font-weight: 600; color: #2d3748;">Liên hệ qua Gmail</span>
                                        </a>
                                    </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%
                }
            } else {
            %>
            <div class="col-12">
                <div class="alert text-center"
                     style="background: linear-gradient(135deg, rgba(79, 172, 254, 0.1), rgba(0, 242, 254, 0.1)); border: none; border-radius: 20px; padding: 3rem;">
                    <div class="mb-3">
                        <i class="fas fa-user-tie" style="font-size: 3rem; color: #4facfe;"></i>
                    </div>
                    <h4 class="text-dark mb-3">Hiện tại chưa có huấn luyện viên nào!</h4>
                    <p class="text-secondary mb-0" style="font-size: 1.1rem;">Chúng tôi đang tuyển dụng các PT chuyên
                        nghiệp. Vui lòng quay lại sau hoặc liên hệ để được tư vấn.</p>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<style>
    .trainer-card:hover {
        transform: translateY(-15px);
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2) !important;
    }

    .info-item {
        transition: all 0.3s ease;
    }

    .info-item:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
    }

    .dropdown-menu .dropdown-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1) !important;
    }

    .trainer-card .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 30px rgba(118, 75, 162, 0.6) !important;
    }

    .icon-wrapper {
        transition: all 0.3s ease;
    }

    .info-item:hover .icon-wrapper {
        transform: scale(1.1);
    }

    .trainer-avatar {
        transition: all 0.3s ease;
    }

    .trainer-card:hover .trainer-avatar {
        transform: scale(1.05);
    }

    /* Animation */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .trainer-card {
        animation: fadeInUp 0.6s ease forwards;
    }

    .trainer-card:nth-child(1) {
        animation-delay: 0.1s;
    }

    .trainer-card:nth-child(2) {
        animation-delay: 0.2s;
    }

    .trainer-card:nth-child(3) {
        animation-delay: 0.3s;
    }

    /* Responsive */
    @media (max-width: 768px) {
        #trainers-section .card-body {
            padding: 1.5rem !important;
        }

        #trainers-section .trainer-avatar {
            width: 100px !important;
            height: 100px !important;
        }

        #trainers-section .card-header {
            height: 150px !important;
        }

        #trainers-section .info-item {
            padding: 10px 12px !important;
            margin-bottom: 0.75rem !important;
        }

        #trainers-section .icon-wrapper {
            width: 35px !important;
            height: 35px !important;
        }

        #trainers-section .btn {
            padding: 12px 20px !important;
            font-size: 0.85rem !important;
        }
    }
</style>

<!-- Features Section - Equipment -->
<section class="my-5 py-5" id="equipment-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-8 mx-auto text-center">
                <div class="mb-4">
                    <div style="display: inline-block; padding: 15px 35px; background: rgba(102, 126, 234, 0.1); border-radius: 60px; backdrop-filter: blur(15px); border: 2px solid rgba(102, 126, 234, 0.2);">
                        <i class="fas fa-dumbbell" style="color: #667eea; font-size: 2.8rem;"></i>
                    </div>
                </div>
                <h2 class="text-dark mb-0">Thiết bị tập luyện tại CoreFit Gym</h2>
                <h3 class="text-dark mb-4" style="font-weight: 300; opacity: 0.7; font-size: 1.3rem;">Hiện đại - Chuyên
                    nghiệp - An toàn</h3>
                <p class="lead text-dark" style="opacity: 0.6; line-height: 1.8; font-size: 1.1rem;">
                    Khám phá bộ sưu tập thiết bị tập luyện hiện đại và chuyên nghiệp tại CoreFit Gym,
                    được nhập khẩu từ các thương hiệu hàng đầu thế giới để mang lại trải nghiệm tập luyện tốt nhất.
                </p>
            </div>
        </div>
    </div>
    <div class="container mt-sm-5 mt-3">
        <div class="row">
            <div class="col-lg-3">
                <div
                        class="position-sticky pb-lg-5 pb-3 mt-lg-0 mt-5 ps-2"
                        style="top: 100px"
                >
                    <h4 class="">
                        Thiết Bị
                    </h4>
                    <h6 class="text-secondary">
                        Tìm hiểu về các thiết bị tập luyện hiện đại và chuyên nghiệp tại CoreFit Gym
                    </h6>
                </div>
            </div>
            <div class="col-lg-9">
                <!-- Equipment Grid -->
                <div class="row">
                    <!-- Equipment 1: Treadmill -->
                    <div class="col-md-4 mt-md-0">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/1.Treadmill.jpg"
                                        alt="Treadmill"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Treadmill</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy chạy bộ cho phép người tập đi bộ hoặc chạy tại chỗ. Băng chuyền di chuyển quanh
                                    các con lăn...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy chạy bộ cho phép người tập đi bộ hoặc chạy tại chỗ. Băng chuyền di chuyển quanh
                                    các con lăn,
                                    và người tập đi bộ hoặc chạy trên băng. Mặc dù máy chạy bộ là một trong những lựa
                                    chọn phổ biến
                                    nhất cho việc tập giảm mỡ, chúng cũng có thể được sử dụng cho các phương pháp tập
                                    cardio khác
                                    như tăng sức bền, phục hồi chức năng và kiểm tra mức độ thể lực.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 2: Elliptical -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/2.Elliptical.jpg"
                                        alt="Elliptical"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Elliptical</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy tập elliptical có thể được sử dụng cho nhiều hình thức tập luyện khác nhau...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy tập elliptical có thể được sử dụng cho nhiều hình thức tập luyện khác nhau.
                                    Thông thường, máy elliptical sẽ có hai bàn đạp mà người dùng đứng lên và sử dụng
                                    để di chuyển theo chuyển động tròn hoặc hình elip. Loại chuyển động này thường được
                                    sử dụng để mô phỏng việc đi bộ hoặc chạy mà không có tác động như các hoạt động này
                                    thường có lên các khớp.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 3: Stationary bike -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/3.Stationarybike.jpg"
                                        alt="Stationary bike"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Stationary bike</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xe đạp tĩnh là một loại xe đạp tập thể dục được sử dụng để mô phỏng trải nghiệm đi
                                    xe đạp thật...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xe đạp tĩnh là một loại xe đạp tập thể dục được sử dụng để mô phỏng trải nghiệm
                                    đi xe đạp thật. Ưu điểm chính của xe đạp tĩnh so với xe đạp thông thường là nó có
                                    thể
                                    được sử dụng trong nhà. Ngoài ra, xe đạp tĩnh thường được trang bị các tính năng
                                    cho phép người dùng theo dõi tiến trình và đặt mục tiêu như khoảng cách, tốc độ hoặc
                                    thời gian.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 4: Air resistance bike -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/4.Air resistance bike.jpg"
                                        alt="Air resistance bike"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Air resistance bike</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xe đạp kháng lực khí có quạt ở phía trước tạo ra kháng lực khí...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xe đạp kháng lực khí có quạt ở phía trước tạo ra kháng lực khí, lượng kháng lực
                                    có thể được điều chỉnh bởi người dùng, làm cho nó trở thành một bài tập tuyệt vời
                                    cho mọi người ở mọi mức độ thể lực. Sử dụng máy này để giảm mỡ, tăng cơ bắp chân
                                    trên và sức bền tim mạch.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 5: Recumbent bike -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/5.Recumbent bike.jpg"
                                        alt="Recumbent bike"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Recumbent bike</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xe đạp nằm là một loại xe đạp tĩnh đặt người đi trong tư thế nằm ngửa thoải mái...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xe đạp nằm là một loại xe đạp tĩnh đặt người đi trong tư thế nằm ngửa thoải mái.
                                    Tư thế này được cho là thoải mái và phù hợp với ergonomic hơn so với tư thế đi
                                    thẳng đứng truyền thống. Ngoài ra, xe đạp nằm có xu hướng dễ dàng hơn cho lưng
                                    và các khớp, làm cho chúng trở thành lựa chọn tốt cho những người bị đau mãn tính
                                    hoặc chấn thương.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 6: Spin bike -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/6. Spin bike.jpg"
                                        alt="Spin bike"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Spin bike</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xe đạp Spin là một loại xe đạp tập thể dục thường được sử dụng trong các lớp tập thể
                                    dục nhóm...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xe đạp Spin là một loại xe đạp tập thể dục thường được sử dụng trong các lớp tập thể
                                    dục
                                    nhóm. Nó có bánh đà nặng tạo ra kháng lực, làm cho việc đạp khó hơn. Kháng lực có
                                    thể
                                    được điều chỉnh để làm cho bài tập thử thách hơn hoặc ít hơn. Nhiều xe đạp spin hiện
                                    đại
                                    sử dụng công nghệ kháng lực từ tính ngày nay. Xe đạp spin cũng có bàn đạp đặc biệt
                                    bám vào giày, giúp dễ dàng giữ chân không bị trượt.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 7: Rowing machine -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/7.Rowing machine.jpg"
                                        alt="Rowing machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Rowing machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy chèo thuyền là một loại thiết bị tập thể dục mô phỏng hành động chèo thuyền...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy chèo thuyền là một loại thiết bị tập thể dục mô phỏng hành động chèo thuyền.
                                    Máy chèo được thiết kế để cung cấp một buổi tập toàn thân cho thể lực và sức mạnh.
                                    Chúng có thể được sử dụng cho cả tập thể dục tim mạch và tập sức mạnh. Máy chèo
                                    cung cấp một số lợi ích, bao gồm khả năng tập nhiều nhóm cơ, cải thiện thể lực
                                    aerobic và tăng sức bền tổng thể.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 8: Stair climber -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/8.Stair climber.jpg"
                                        alt="Stair climber"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Stair climber</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy leo cầu thang mô phỏng hành động leo cầu thang...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy leo cầu thang mô phỏng hành động leo cầu thang. Đây là lựa chọn phổ biến
                                    cho những người muốn cải thiện thể lực tim mạch hoặc giảm cân. Máy thường có
                                    hai tay cầm mà người dùng nắm trong khi đi trên một bộ cầu thang xoay và kháng lực
                                    có thể được điều chỉnh để làm cho bài tập khó hơn, tùy thuộc vào mức độ thể lực
                                    của người dùng.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 9: Shoulder press machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/9.Shoulder press machine.jpg"
                                        alt="Shoulder press machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Shoulder press machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy ép vai là máy tập tạ được thiết kế đặc biệt để nhắm vào các cơ vai...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy ép vai là máy tập tạ được thiết kế đặc biệt để nhắm vào các cơ vai. Máy thường
                                    có ghế ngồi và tựa lưng, với một chồng tạ gắn ở phía trước máy. Người dùng ngồi
                                    trên ghế và nắm các tay cầm hoặc thanh gắn với chồng tạ, sau đó đẩy tạ lên trên.
                                    Bài tập này nhắm vào cả ba đầu của vai, cơ delta trước, cũng như cơ delta giữa
                                    và sau.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 10: Dipping station -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/10.Dipping station.jpg"
                                        alt="Dipping station"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Dipping station</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Trạm dipping có thể được sử dụng cho nhiều bài tập khác nhau...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Trạm dipping có thể được sử dụng cho nhiều bài tập khác nhau. Một số bài tập phổ
                                    biến
                                    nhất có thể được thực hiện trên trạm dipping bao gồm dips tam đầu, dips ngực và dips
                                    vai.
                                    Dips là một cách tuyệt vời để xây dựng sức mạnh, phối hợp và cân bằng ở phần thân
                                    trên
                                    và máy trạm dipping là lựa chọn tuyệt vời cho các bài tập với trọng lượng cơ thể.
                                    Một số huấn luyện viên cũng sẽ sử dụng thêm trọng lượng gắn qua thắt lưng để tiến bộ
                                    hơn so với chỉ trọng lượng cơ thể.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 11: Preacher curl machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/11.Preacher curl machine.jpg"
                                        alt="Preacher curl machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Preacher curl machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy preacher curl là một loại thiết bị tập tạ giúp cô lập cơ biceps...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy preacher curl là một loại thiết bị tập tạ giúp cô lập cơ biceps. Bằng cách ngồi
                                    xuống và giữ tạ với khuỷu tay tựa trên tay vịn có đệm, bạn có thể cuộn tạ lên xuống
                                    mà không sử dụng lưng hoặc vai để hỗ trợ. Điều này cho phép bạn tập trung cụ thể
                                    vào việc xây dựng sức mạnh cho cơ biceps của mình.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 12: Pullup bar -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/12.Pullup bar.jpg"
                                        alt="Pullup bar"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Pullup bar</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xà đơn là một thiết bị được sử dụng cho tập sức mạnh...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xà đơn là một thiết bị được sử dụng cho tập sức mạnh. Nó thường được sử dụng để thực
                                    hiện
                                    pullups, chinups và các bài tập khác tác động lên cơ lưng, vai và cánh tay. Pull-ups
                                    là bài tập tập sức mạnh phần thân trên tác động lên cơ lưng. Cơ latissimus dorsi (cơ
                                    lưng)
                                    chịu trách nhiệm cho chuyển động vai xuống dưới và duỗi cánh tay. Pullups cũng tác
                                    động
                                    lên cơ biceps và cơ cẳng tay.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 13: Seated row machine -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/13.Seated row machine.jpg"
                                        alt="Seated row machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Seated row machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy rowing ngồi bao gồm ghế ngồi, chồng tạ và tay cầm...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy rowing ngồi bao gồm ghế ngồi, chồng tạ và tay cầm. Người dùng ngồi trên ghế
                                    và nắm tay cầm. Chân thường được đặt trên giá đỡ. Để tập luyện, người dùng kéo
                                    tay cầm về phía cơ thể, tác động lên cơ lưng và vai.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 14: Lat pulldown machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/14.Lat pulldown machine.jpg"
                                        alt="Lat pulldown machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Lat pulldown machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy lat pulldown được sử dụng để tập nhóm cơ latissimus dorsi...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy lat pulldown được sử dụng để tập nhóm cơ latissimus dorsi. Latissimus dorsi
                                    là một cơ lớn, phẳng kéo dài từ lưng dưới đến cánh tay trên. Máy lat pulldown
                                    cho phép bạn cô lập và nhắm vào nhóm cơ này với nhiều bài tập khác nhau.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 15: Roman chair -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/15.Roman chair (AKA back extension machine or hyperextension bench).jpg"
                                        alt="Roman chair"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Roman chair</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Ghế Roman chủ yếu được sử dụng để tăng cường cơ lưng dưới và cơ bụng...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Ghế Roman chủ yếu được sử dụng để tăng cường cơ lưng dưới và cơ bụng. Nó có thể
                                    được sử dụng cho nhiều bài tập khác nhau, bao gồm sit-ups, nâng chân và duỗi lưng
                                    cũng như được sử dụng để cải thiện tư thế và giảm đau ở lưng dưới. Ghế Roman được
                                    đặt tên theo hoàng đế La Mã, Marcus Aurelius, người nổi tiếng với sức mạnh quân sự
                                    và thể chất.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 16: Chest press machine -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/16.Chest press machine.jpg"
                                        alt="Chest press machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Chest press machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy ép ngực thường có ghế ngồi và chồng tạ...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy ép ngực thường có ghế ngồi và chồng tạ, và người dùng đẩy chống lại kháng lực
                                    của chồng tạ để tập cơ ngực. Máy ép ngực có thể điều chỉnh với các trọng lượng khác
                                    nhau
                                    và có thể được thiết lập cho các bài tập khác nhau, chẳng hạn như ép ngực phẳng,
                                    ép ngực nghiêng hoặc ép ngực nghiêng xuống. Máy ép ngực là cách tốt để tập cơ ngực
                                    mà không cần sử dụng tạ tự do.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 17: Pec deck machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/17.Pec deck machine.jpg"
                                        alt="Pec deck machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Pec deck machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Như tên gọi, máy Pec deck thường được sử dụng để tập cơ ngực...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Như tên gọi, máy Pec deck thường được sử dụng để tập cơ ngực, hay "pecs". Máy thường
                                    bao gồm ghế ngồi, tấm đệm lưng và hai tấm đệm đặt cánh tay ở vị trí cố định.
                                    Tấm tạ và hệ thống ròng rọc được sử dụng để kháng lực. Người dùng ngồi trên ghế
                                    và nắm tay cầm, sau đó ép tay cầm lại với nhau để tập cơ ngực. Đây là bài tập cô
                                    lập,
                                    vì vậy nó tốt cho việc định hình hoặc làm mệt cơ ngực trước, nhưng nếu mục tiêu
                                    xây dựng kích thước và sức mạnh cho cơ ngực là ưu tiên, thì bench press nên là ưu
                                    tiên.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 18: Pec fly machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/18.Pec fly machine.jpg"
                                        alt="Pec fly machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Pec fly machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy Pec fly là một loại máy tạ được sử dụng để tập cơ ngực...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy Pec fly là một loại máy tạ được sử dụng để tập cơ ngực. Máy có hai tay cầm
                                    mà người dùng đẩy lại với nhau để tập cơ. Tay cầm có một số chuyển động để người tập
                                    có thể làm việc với các mức độ vị trí cánh tay khác nhau. Cánh tay nên ở phía trước
                                    cơ thể, ở độ cao ngực với hơi cong ở khuỷu tay. Hầu hết tay cầm máy pec fly có thể
                                    được điều chỉnh để chuyển đổi máy thành reverse fly để nhắm vào cơ delta sau.
                                    Đây là thiết bị tiêu chuẩn của phòng tập thương mại.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 19: Pilates reformer -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/19.Pilates reformer (AKA Pilates machine).jpg"
                                        alt="Pilates reformer"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Pilates reformer</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy Pilates reformer có nhiều kiểu khác nhau...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy Pilates reformer có nhiều kiểu khác nhau. Nói chung, chúng có một tấm đệm khá
                                    lớn
                                    gắn với khung. Tấm đệm có thể trượt tự do dọc theo khung với người dùng ở nhiều vị
                                    trí
                                    khác nhau. Thường có một thanh cứng ở một đầu của khung và tay cầm gắn với hệ thống
                                    ròng rọc ở đầu kia. Người tập có thể sử dụng thanh cứng này để ổn định khi tập các
                                    chuyển động Pilates với tấm đệm di động. Điều tương tự cũng áp dụng cho hệ thống
                                    ròng rọc.
                                    Tuyệt vời cho những người tập quan tâm đến phạm vi chuyển động, tập toàn thân và
                                    Pilates nói chung.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 20: Ab coaster -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/20.Ab coaster.jpg"
                                        alt="Ab coaster"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Ab coaster</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Ab coaster là một thiết bị có ghế ngồi và con lăn có đệm gắn với đường ray...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Ab coaster là một thiết bị có ghế ngồi và con lăn có đệm gắn với đường ray.
                                    Người dùng ngồi trên ghế và đặt chân lên bàn đạp. Sau đó họ đẩy con lăn lên xuống
                                    đường ray do đó "lướt" dọc theo đường đua. Mặc dù thiết bị này được đặt tên là máy
                                    tập cơ bụng, nó có thể được sử dụng cho các nhóm cơ khác nhau như cánh tay, hông và
                                    chân.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 21: Abdominal bench -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/21.Abdominal bench (AKA situp bench).jpg"
                                        alt="Abdominal bench"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Abdominal bench</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Ghế tập bụng có bề mặt có đệm và được đặt ở góc nghiêng xuống...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Ghế tập bụng có bề mặt có đệm và được đặt ở góc nghiêng xuống với các bộ phận cố
                                    định
                                    có đệm để khóa chân dưới vào vị trí. Một số ghế sit up có nhiều cài đặt nghiêng
                                    xuống
                                    khác nhau để phù hợp với người dùng khác nhau. Các bài tập phổ biến nhất được thực
                                    hiện
                                    trên ghế tập bụng là sit-ups và crunches.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 22: Ab roller -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/22.Ab roller (AKA ab wheel).jpg"
                                        alt="Ab roller"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Ab roller</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Con lăn bụng là một thiết bị được sử dụng để giúp săn chắc và tăng cường cơ bụng...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Con lăn bụng là một thiết bị được sử dụng để giúp săn chắc và tăng cường cơ bụng.
                                    Người dùng giữ tay cầm của thiết bị và sau đó lăn nó về phía trước, sử dụng cơ bụng
                                    để kiểm soát chuyển động. Con lăn bụng cũng là một thiết bị tập thể dục di động
                                    tuyệt vời
                                    để sử dụng khi bạn không thể đến phòng tập, và nó cũng tương đối phải chăng.
                                    Có một vài thương hiệu con lăn bụng khác nhau trên thị trường, nhưng tất cả chúng
                                    đều hoạt động theo cách tương tự.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 23: Leg curl machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/23.Leg curl machine.jpg"
                                        alt="Leg curl machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Leg curl machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy leg curl có ghế có đệm để người nằm sấp hoặc ngồi...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy leg curl có ghế có đệm để người nằm sấp hoặc ngồi (tùy thuộc vào thiết kế)
                                    và họ đặt chân dưới thanh có đệm. Sau đó họ cong chân về phía mông và hạ xuống,
                                    do đó cô lập nhóm cơ hamstring ở chân. Hamstring là một cơ lớn kéo dài từ hông
                                    đến đầu gối ở mặt sau của chân. Máy leg curl cho phép bạn cô lập nhóm hamstring
                                    và tập nó độc lập với các nhóm cơ khác ở chân. Điều này có lợi vì nó cho phép
                                    bạn tập trung vào việc phát triển nhóm cơ này mà không phải lo lắng về các cơ
                                    khác ở chân cản trở.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 24: Leg extension machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/24.Leg extension machine.jpg"
                                        alt="Leg extension machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Leg extension machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy duỗi chân là một thiết bị tập thể dục được sử dụng để tăng cường cơ tứ đầu đùi ở
                                    chân...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy duỗi chân là một thiết bị tập thể dục được sử dụng để tăng cường cơ tứ đầu đùi
                                    ở chân. Tứ đầu đùi là một nhóm bốn cơ nằm ở mặt trước của đùi. Những cơ này chịu
                                    trách nhiệm duỗi khớp gối. Máy duỗi chân hoạt động bằng cách cho phép người dùng
                                    ngồi với đầu gối cong và sau đó duỗi chân chống lại kháng lực. Kháng lực này có thể
                                    được cung cấp bởi tạ, lò xo hoặc xi lanh thủy lực.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 25: Hack squat machine -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/25.Hack squat machine.jpg"
                                        alt="Hack squat machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Hack squat machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy hack squat là thiết bị tập sức mạnh tuyệt vời mô phỏng chuyển động squat...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy hack squat là thiết bị tập sức mạnh tuyệt vời mô phỏng chuyển động squat.
                                    Máy bao gồm một nền tảng mà người dùng đứng lên, với hai tay cầm gắn ở phía trước
                                    nền tảng. Người dùng nắm tay cầm và squat xuống, sau đó đứng lên trở lại vị trí
                                    ban đầu. Máy có thể điều chỉnh để người dùng có thể tăng hoặc giảm lượng trọng lượng
                                    được nâng. Máy hack squat là máy leg press nhắm vào phía trước của chân trên nhiều
                                    hơn so với các biến thể leg press khác, nhưng vì nó là chuyển động phức hợp,
                                    nó cũng sẽ có một số tác động đến cơ mông và hamstring.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 26: Hip abduction machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/26.Hip abduction machine (AKA SUS machine).jpg"
                                        alt="Hip abduction machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Hip abduction machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy hip abduction được thiết kế để nhắm vào cơ đùi ngoài...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy hip abduction được thiết kế để nhắm vào cơ đùi ngoài. Nhóm cơ này chịu trách
                                    nhiệm
                                    di chuyển chân ra khỏi cơ thể, và máy Abduction cho phép người dùng tập trung vào
                                    mô hình chuyển động này. Máy thường bao gồm ghế có đệm và hai tay cầm mà người dùng
                                    có thể nắm. Cũng có bàn đạp chân mà người dùng sẽ đặt chân lên. Để sử dụng máy,
                                    người dùng sẽ ngồi trên ghế và nắm tay cầm và sau đó đẩy chân theo chuyển động
                                    ra ngoài. Loại máy này cũng có thể được sử dụng để giúp những người đã phẫu thuật
                                    hông hoặc những người có cơ hông yếu.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 27: Hip adduction machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/27.Hip adduction machine.jpg"
                                        alt="Hip adduction machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Hip adduction machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy hip adduction được sử dụng để nhắm vào cơ chân trên, bên trong...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy hip adduction được sử dụng để nhắm vào cơ chân trên, bên trong. Các cơ adductor
                                    chịu trách nhiệm di chuyển chân về phía đường giữa của cơ thể. Máy hip adduction
                                    trông rất giống và có cùng thiết lập như máy hip abduction, nhưng các tấm đệm được
                                    đặt ở bên trong của chân trên và cơ chế di chuyển theo hướng ngược lại, vì vậy
                                    kháng lực hoạt động chống lại bên trong chân. Có các máy đơn lẻ có sẵn có thể
                                    thực hiện cả chức năng adduction và abduction.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 28: Calf raise machine -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/28.Calf raise machine.jpg"
                                        alt="Calf raise machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Calf raise machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy nâng bắp chân thường có bản chân mà người dùng ấn xuống bằng chân để nâng trọng
                                    lượng...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy nâng bắp chân thường có bản chân mà người dùng ấn xuống bằng chân để nâng trọng
                                    lượng,
                                    và một chồng tạ có thể được điều chỉnh để thêm kháng lực. Có một số phiên bản khác
                                    nhau
                                    của máy nâng bắp chân, đây là thiết lập ngồi hoặc đứng, nhưng cả hai đều làm cùng
                                    công việc.
                                    Nâng bắp chân là bài tập quan trọng để phát triển sức mạnh, sức mạnh, tính linh hoạt
                                    và sức bền chân dưới, và có thể giúp cải thiện hiệu suất thể thao và ngăn ngừa chấn
                                    thương.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 29: Leg press machine -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/29.Leg press machine.jpg"
                                        alt="Leg press machine"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Leg press machine</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Máy leg press nhắm vào cơ tứ đầu đùi ở chân cùng với cơ mông và hamstring...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Máy leg press nhắm vào cơ tứ đầu đùi ở chân cùng với cơ mông và hamstring.
                                    Vì đây là chuyển động phức hợp, nó tốt hơn cho tập sức mạnh so với máy duỗi chân.
                                    Máy bao gồm một xe trượt có trọng lượng được đẩy lên xuống bằng chân. Leg press
                                    có thể được thực hiện với một chân hoặc hai chân. Leg press có thể là bài tập hữu
                                    ích
                                    cho những người muốn tăng sức mạnh chân và khối lượng cơ. Một số người tập thấy
                                    những máy này khó khăn cho đầu gối. Nếu đây là trường hợp, được khuyến nghị sử dụng
                                    máy duỗi chân để xây dựng sức mạnh trước khi tiến tới bất kỳ chuyển động leg press
                                    nào.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 30: Dragging sled -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/30.Dragging sled.jpg"
                                        alt="Dragging sled"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Dragging sled</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Xe trượt kéo thường được nạp tạ và sau đó được kéo hoặc đẩy trên sàn hoặc bề mặt
                                    khác...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Xe trượt kéo thường được nạp tạ và sau đó được kéo hoặc đẩy trên sàn hoặc bề mặt
                                    khác.
                                    Phương pháp tập kháng lực này có thể giúp cải thiện sức mạnh, sức mạnh và sức bền.
                                    Xe trượt kéo phổ biến với những người tập chơi thể thao cạnh tranh như bóng đá hoặc
                                    bóng bầu dục.
                                    Chúng không tuyệt vời nếu bạn đang sử dụng phòng tập tại nhà vì chúng cần rất nhiều
                                    không gian và một khu vực lớn để sử dụng hiệu quả.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <!-- Equipment 31: Flat bench -->
                    <div class="col-md-4 mt-md-0 mt-3">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/31.Flat bench.jpg"
                                        alt="Flat bench"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Flat bench</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Ghế phẳng là ghế tập tạ nằm ngang, trái ngược với việc được góc nghiêng lên hoặc
                                    nghiêng xuống...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Ghế phẳng là ghế tập tạ nằm ngang, trái ngược với việc được góc nghiêng lên hoặc
                                    nghiêng xuống.
                                    Loại ghế này thường được sử dụng cho chest press và các bài tập khác tác động lên cơ
                                    ở ngực và thân trên, nhưng nó là một trong những thiết bị phòng tập đa năng hơn có
                                    nhiều
                                    chức năng khả thi khác. Chúng được tìm thấy trong các phòng tập thương mại ở khắp
                                    mọi nơi.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Equipment 32: Decline bench -->
                    <div class="col-md-4 mt-md-0 mt-4">
                        <div class="card shadow-lg move-on-hover equipment-card">
                            <div class="equipment-image-container">
                                <img
                                        class="equipment-image"
                                        src="./assets/img/equipments/32.Decline bench.jpg"
                                        alt="Decline bench"
                                />
                            </div>
                        </div>
                        <div class="mt-3 ms-2">
                            <h6 class="mb-2 text-primary">Decline bench</h6>
                            <div class="equipment-description">
                                <p class="text-secondary text-sm description-short">
                                    Ghế nghiêng xuống là ghế tập tạ có cài đặt nghiêng xuống...
                                </p>
                                <p class="text-secondary text-sm description-full" style="display: none;">
                                    Ghế nghiêng xuống là ghế tập tạ có cài đặt nghiêng xuống, vì vậy phần tựa lưng trên
                                    hạ xuống sàn. Ghế nghiêng xuống được sử dụng phổ biến nhất cho decline bench press
                                    để nhắm vào ngực dưới. Chúng có thể được sử dụng cho tập bụng nếu chúng cũng có
                                    chỗ để chân. Đây là một thiết bị cho phép hơi duỗi quá mức của lưng khi tập cơ bụng,
                                    để cung cấp phạm vi chuyển động thêm. Nhiều ghế điều chỉnh tốt cũng có cài đặt
                                    nghiêng xuống,
                                    vì vậy đầu tư vào một ghế di chuyển cả nghiêng lên và nghiêng xuống là lựa chọn tốt
                                    hơn.
                                </p>
                                <a href="#" class="read-more-btn text-primary text-decoration-none"
                                   style="font-size: 0.85rem; font-weight: 600;">
                                    <i class="fas fa-chevron-down me-1"></i>Đọc thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="footer pt-5 mt-5" id="footer">
    <hr class="horizontal dark mb-5"/>
    <div class="container">
        <div class="row">
            <div class="col-md-3 mb-4 ms-auto">
                <div>
                    <h6 class="text-gradient text-primary font-weight-bolder">
                        Corefit Gym
                    </h6>
                    <p class="text-sm mt-3 mb-4">
                        Nâng cao sức khỏe, thay đổi ngoại hình và cải thiện cuộc sống. 
                        Hãy để chúng tôi đồng hành cùng bạn trên hành trình chinh phục bản thân.
                    </p>
                </div>
                <div>
                    <h6 class="mt-3 mb-2 opacity-8">Mạng xã hội</h6>
                    <ul class="d-flex flex-row ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://www.facebook.com/corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-facebook.svg" alt="Facebook" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://www.instagram.com/corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-insta.svg" alt="Instagram" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://www.tiktok.com/@corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-tiktok.svg" alt="TikTok" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://t.me/corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-telegram.svg" alt="Telegram" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://t.me/corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-zalo.svg" alt="Zalo" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://t.me/corefitgym"
                                    target="_blank"
                            >
                                <img src="./assets/svg/icons8-youtube.svg" alt="Youtube" width="20" height="20" class="opacity-8">
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Thông tin</h6>
                    <ul class="flex-column ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="#"
                            >
                                Về chúng tôi
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="#"
                            >
                                Gói tập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="#"
                            >
                                Huấn luyện viên
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="#"
                            >
                                Thiết bị
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm ps-0">Liên hệ</h6>
                    <ul class="flex-column nav">
                        <li class="nav-item">
                            <div class="nav-link d-flex align-items-start ps-0">
                                <div class="me-3 mt-1" style="min-width: 20px;">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16px" height="16px" fill="currentColor">
                                        <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                                    </svg>
                                </div>
                                <div style="flex: 1;">
                                    <span style="font-size: 0.8rem; line-height: 1.4; word-wrap: break-word;">
                                        600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ
                                    </span>
                                </div>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link d-flex align-items-center ps-0" href="tel:+84292383333">
                                <div class="me-3" style="min-width: 20px;">
                                    <img src="./assets/svg/icons8-phone.svg" alt="Phone" width="16" height="16">
                                </div>
                                <span style="font-size: 0.8rem;">+84 292 383 333</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link d-flex align-items-center ps-0" href="mailto:info@corefitgym.com">
                                <div class="me-3" style="min-width: 20px;">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="16px" height="16px">
                                        <path fill="#4caf50" d="M45,16.2l-5,2.75l-5,4.75L35,40h7c1.657,0,3-1.343,3-3V16.2z"/>
                                        <path fill="#1e88e5" d="M3,16.2l3.614,1.71L13,23.7V40H6c-1.657,0-3-1.343-3-3V16.2z"/>
                                        <polygon fill="#e53935" points="35,11.2 24,19.45 13,11.2 12,17 13,23.7 24,31.95 35,23.7 36,17"/>
                                        <path fill="#c62828" d="M3,12.298V16.2l10,7.5V11.2L9.876,8.859C9.132,8.301,8.228,8,7.298,8h0C4.924,8,3,9.924,3,12.298z"/>
                                        <path fill="#fbc02d" d="M45,12.298V16.2l-10,7.5V11.2l3.124-2.341C38.868,8.301,39.772,8,40.702,8h0 C43.076,8,45,9.924,45,12.298z"/>
                                    </svg>
                                </div>
                                <span style="font-size: 0.8rem;">info@corefitgym.com</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm ps-0">Giờ hoạt động</h6>
                    <ul class="flex-column nav">
                        <li class="nav-item">
                            <div class="nav-link ps-0">
                                <strong style="font-size: 0.8rem;">Thứ 2 - Thứ 7:</strong><br>
                                <span style="font-size: 0.8rem;">7:00 - 22:00</span>
                            </div>
                        </li>
                        <li class="nav-item">
                            <div class="nav-link ps-0">
                                <strong style="font-size: 0.8rem;">Chủ nhật:</strong><br>
                                <span style="font-size: 0.8rem;">Nghỉ</span>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4 me-auto">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Bản đồ</h6>
                    <div class="mt-3">
                        <iframe 
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3928.6409837889733!2d105.7295125!3d10.0135881!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a0882139720a77%3A0x3916a227d0b95a64!2sFPT+University!5e0!3m2!1svi!2s!4v1699123456789!5m2!1svi!2s" 
                            width="100%" 
                            height="120" 
                            style="border:0; border-radius: 8px;" 
                            allowfullscreen="" 
                            loading="lazy" 
                            referrerpolicy="no-referrer-when-downgrade">
                        </iframe>
                    </div>
                    <a class="btn btn-primary btn-sm mt-2 w-100" 
                       href="https://www.google.com/maps/place/FPT+University/@10.0135881,105.7295125,19.25z/data=!4m6!3m5!1s0x31a0882139720a77:0x3916a227d0b95a64!8m2!3d10.0124518!4d105.7324316!16s%2Fg%2F11c6w2mjqm"
                       target="_blank"
                       style="border-radius: 8px; font-size: 0.75rem; padding: 6px 12px;">
                        <i class="fas fa-directions me-1"></i>
                        Chỉ đường
                    </a>
                </div>
            </div>
            <div class="col-12">
                <div class="text-center">
                    <p class="my-4 text-sm">
                        All rights reserved. Copyright ©
                        <script>
                            document.write(new Date().getFullYear());
                        </script>
                        Corefit Gym by SWP391_07.
                    </p>
                </div>
            </div>
        </div>
    </div>
</footer> 
<!--   Core JS Files   -->
<script
        src="./assets/js/core/popper.min.js"
        type="text/javascript"
></script>
<script
        src="./assets/js/core/bootstrap.min.js"
        type="text/javascript"
></script>
<script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
<!--  Plugin for TypedJS, full documentation here: https://github.com/inorganik/CountUp.js -->
<script src="./assets/js/plugins/countup.min.js"></script>
<!--  Plugin for Parallax, full documentation here: https://github.com/dixonandmoe/rellax -->
<script src="./assets/js/plugins/rellax.min.js"></script>
<!--  Plugin for TiltJS, full documentation here: https://gijsroge.github.io/tilt.js/ -->
<script src="./assets/js/plugins/tilt.min.js"></script>
<!--  Plugin for Selectpicker - ChoicesJS, full documentation here: https://github.com/jshjohnson/Choices -->
<script src="./assets/js/plugins/choices.min.js"></script>
<!--  Plugin for Parallax, full documentation here: https://github.com/wagerfield/parallax  -->
<script src="./assets/js/plugins/parallax.min.js"></script>
<!-- Control Center for Soft UI Kit: parallax effects, scripts for the example pages etc -->
<!--  Google Maps Plugin    -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDTTfWur0PDbZWPr7Pmq8K3jiDp0_xUziI"></script>
<script
        src="./assets/js/soft-design-system.min.js?v=1.1.0"
        type="text/javascript"
></script>
<script type="text/javascript">
    if (document.getElementById("state1")) {
        const countUp = new CountUp(
            "state1",
            document.getElementById("state1").getAttribute("countTo")
        );
        if (!countUp.error) {
            countUp.start();
        } else {
            console.error(countUp.error);
        }
    }
    if (document.getElementById("state2")) {
        const countUp1 = new CountUp(
            "state2",
            document.getElementById("state2").getAttribute("countTo")
        );
        if (!countUp1.error) {
            countUp1.start();
        } else {
            console.error(countUp1.error);
        }
    }
    if (document.getElementById("state3")) {
        const countUp2 = new CountUp(
            "state3",
            document.getElementById("state3").getAttribute("countTo")
        );
        if (!countUp2.error) {
            countUp2.start();
        } else {
            console.error(countUp2.error);
        }
    }
</script>

<!-- CSS cho equipment section -->
<style>
    /* Equipment Cards Styling */
    .equipment-card {
        border-radius: 15px;
        overflow: hidden;
        transition: all 0.3s ease;
        border: none;
    }

    .equipment-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15) !important;
    }

    .equipment-image-container {
        width: 100%;
        height: 220px;
        overflow: hidden;
        position: relative;
        background: #f8f9fa;
        border-radius: 15px 15px 0 0;
    }

    .equipment-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
        transition: transform 0.3s ease;
    }

    .equipment-card:hover .equipment-image {
        transform: scale(1.05);
    }

    /* Equipment Description Styling */
    .equipment-description {
        position: relative;
    }

    .description-short {
        display: block;
        margin-bottom: 0.5rem;
    }

    .description-full {
        display: none;
        margin-bottom: 0.5rem;
    }

    .description-full.show {
        display: block;
    }

    .description-short.hide {
        display: none;
    }

    .read-more-btn {
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        font-weight: 600;
        color: #667eea !important;
    }

    .read-more-btn:hover {
        color: #764ba2 !important;
        text-decoration: none !important;
        transform: translateX(3px);
    }

    .read-more-btn i {
        transition: transform 0.3s ease;
    }

    .read-more-btn.expanded i {
        transform: rotate(180deg);
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .equipment-image-container {
            height: 200px;
        }

        .equipment-card {
            margin-bottom: 1.5rem;
        }
    }

    @media (max-width: 576px) {
        .equipment-image-container {
            height: 180px;
        }

        .col-md-4 {
            margin-bottom: 2rem;
        }
    }

    /* Animation for smooth transitions */
    .equipment-description p {
        transition: all 0.3s ease;
    }

    /* Hover effects for better UX */
    .equipment-card {
        position: relative;
        overflow: hidden;
    }

    .equipment-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: left 0.5s;
        z-index: 1;
    }

    .equipment-card:hover::before {
        left: 100%;
    }
</style>

<!-- JavaScript cho read more functionality -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Read more functionality
        const readMoreBtns = document.querySelectorAll('.read-more-btn');

        readMoreBtns.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();

                const equipmentDesc = this.closest('.equipment-description');
                const shortDesc = equipmentDesc.querySelector('.description-short');
                const fullDesc = equipmentDesc.querySelector('.description-full');

                if (fullDesc.style.display === 'none' || !fullDesc.classList.contains('show')) {
                    // Show full description
                    shortDesc.classList.add('hide');
                    fullDesc.classList.add('show');
                    fullDesc.style.display = 'block';
                    this.innerHTML = '<i class="fas fa-chevron-up me-1"></i>Thu gọn';
                    this.classList.add('expanded');
                } else {
                    // Show short description
                    shortDesc.classList.remove('hide');
                    fullDesc.classList.remove('show');
                    fullDesc.style.display = 'none';
                    this.innerHTML = '<i class="fas fa-chevron-down me-1"></i>Đọc thêm';
                    this.classList.remove('expanded');
                }
            });
        });
    });
</script>

<!-- JavaScript for smooth scrolling menu -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Smooth scrolling for navigation links
        const navLinks = document.querySelectorAll('a[href^="#"]');
        
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                const targetSection = document.querySelector(targetId);
                
                if (targetSection) {
                    const headerOffset = 100; // Offset for fixed navbar
                    const elementPosition = targetSection.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Highlight active menu item based on scroll position
        window.addEventListener('scroll', function() {
            const sections = [
                { id: 'schedule-section', href: '#schedule-section' },
                { id: 'packages-section', href: '#packages-section' },
                { id: 'trainers-section', href: '#trainers-section' },
                { id: 'equipment-section', href: '#equipment-section' },
                { id: 'footer', href: '#footer' }
            ];
            const navLinks = document.querySelectorAll('.navbar-nav .nav-link[href^="#"]');
            
            let current = '';
            
            sections.forEach(section => {
                const element = document.getElementById(section.id);
                if (element) {
                    const sectionTop = element.offsetTop - 150;
                    const sectionHeight = element.offsetHeight;
                    
                    if (window.pageYOffset >= sectionTop && window.pageYOffset < sectionTop + sectionHeight) {
                        current = section.href;
                    }
                }
            });
            
            // Special handling for footer - if we're near the bottom of the page
            const footer = document.getElementById('footer');
            if (footer) {
                const footerTop = footer.offsetTop - 300; // Larger offset for footer
                if (window.pageYOffset >= footerTop) {
                    current = '#footer';
                }
            }
            
            // Remove active class from all links and add to current
            navLinks.forEach(link => {
                link.classList.remove('active');
                const href = link.getAttribute('href');
                if (href === current) {
                    link.classList.add('active');
                }
            });
        });
    });
</script>

<!-- CSS for active menu state -->
<style>
    .navbar-nav .nav-link {
        transition: all 0.3s ease;
        font-weight: 500;
        position: relative;
    }
    
    .navbar-nav .nav-link:hover {
        color: #667eea !important;
        transform: translateY(-2px);
    }
    
    .navbar-nav .nav-link.active {
        color: #667eea !important;
        font-weight: 700;
    }
    
    .navbar-nav .nav-link.active::after {
        content: '';
        position: absolute;
        bottom: -5px;
        left: 50%;
        transform: translateX(-50%);
        width: 30px;
        height: 3px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 2px;
    }
    
    /* Responsive adjustments */
    @media (max-width: 991px) {
        .navbar-nav .nav-link.active::after {
            display: none;
        }
        
        .navbar-nav .nav-link.active {
            background: rgba(102, 126, 234, 0.1);
            border-radius: 8px;
            padding: 8px 16px !important;
        }
    }
</style>
</body>
</html>
