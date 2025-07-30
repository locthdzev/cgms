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
                        Corefit Gym
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
                            <li class="nav-item dropdown dropdown-hover mx-2">
                                <a
                                        class="nav-link ps-2 d-flex justify-content-between cursor-pointer align-items-center"
                                        href="javascript:;"
                                        id="dropdownMenuPages"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false"
                                >
                                    Pages
                                    <img
                                            src="./assets/img/down-arrow-dark.svg"
                                            alt="down-arrow"
                                            class="arrow ms-1"
                                    />
                                </a>
                                <div
                                        class="dropdown-menu dropdown-menu-animation dropdown-md p-3 border-radius-lg mt-0 mt-lg-3"
                                        aria-labelledby="dropdownMenuPages"
                                >
                                    <div class="d-none d-lg-block">
                                        <div
                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center px-0"
                                        >
                                            <div class="d-inline-block">
                                                <div
                                                        class="icon icon-shape icon-xs border-radius-md bg-primary text-center me-2 d-flex align-items-center justify-content-center"
                                                >
                                                    <svg
                                                            width="12px"
                                                            height="12px"
                                                            viewBox="0 0 45 40"
                                                            version="1.1"
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            xmlns:xlink="http://www.w3.org/1999/xlink"
                                                    >
                                                        <title>shop</title>
                                                        <g
                                                                stroke="none"
                                                                stroke-width="1"
                                                                fill="none"
                                                                fill-rule="evenodd"
                                                        >
                                                            <g
                                                                    transform="translate(-1716.000000, -439.000000)"
                                                                    fill="#FFFFFF"
                                                                    fill-rule="nonzero"
                                                            >
                                                                <g
                                                                        transform="translate(1716.000000, 291.000000)"
                                                                >
                                                                    <g
                                                                            transform="translate(0.000000, 148.000000)"
                                                                    >
                                                                        <path
                                                                                d="M46.7199583,10.7414583 L40.8449583,0.949791667 C40.4909749,0.360605034 39.8540131,0 39.1666667,0 L7.83333333,0 C7.1459869,0 6.50902508,0.360605034 6.15504167,0.949791667 L0.280041667,10.7414583 C0.0969176761,11.0460037 -1.23209662e-05,11.3946378 -1.23209662e-05,11.75 C-0.00758042603,16.0663731 3.48367543,19.5725301 7.80004167,19.5833333 L7.81570833,19.5833333 C9.75003686,19.5882688 11.6168794,18.8726691 13.0522917,17.5760417 C16.0171492,20.2556967 20.5292675,20.2556967 23.494125,17.5760417 C26.4604562,20.2616016 30.9794188,20.2616016 33.94575,17.5760417 C36.2421905,19.6477597 39.5441143,20.1708521 42.3684437,18.9103691 C45.1927731,17.649886 47.0084685,14.8428276 47.0000295,11.75 C47.0000295,11.3946378 46.9030823,11.0460037 46.7199583,10.7414583 Z"
                                                                                opacity="0.598981585"
                                                                        ></path>
                                                                        <path
                                                                                d="M39.198,22.4912623 C37.3776246,22.4928106 35.5817531,22.0149171 33.951625,21.0951667 L33.92225,21.1107282 C31.1430221,22.6838032 27.9255001,22.9318916 24.9844167,21.7998837 C24.4750389,21.605469 23.9777983,21.3722567 23.4960833,21.1018359 L23.4745417,21.1129513 C20.6961809,22.6871153 17.4786145,22.9344611 14.5386667,21.7998837 C14.029926,21.6054643 13.533337,21.3722507 13.0522917,21.1018359 C11.4250962,22.0190609 9.63246555,22.4947009 7.81570833,22.4912623 C7.16510551,22.4842162 6.51607673,22.4173045 5.875,22.2911849 L5.875,44.7220845 C5.875,45.9498589 6.7517757,46.9451667 7.83333333,46.9451667 L19.5833333,46.9451667 L19.5833333,33.6066734 L27.4166667,33.6066734 L27.4166667,46.9451667 L39.1666667,46.9451667 C40.2482243,46.9451667 41.125,45.9498589 41.125,44.7220845 L41.125,22.2822926 C40.4887822,22.4116582 39.8442868,22.4815492 39.198,22.4912623 Z"
                                                                        ></path>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                        </g>
                                                    </svg>
                                                </div>
                                            </div>
                                            Landing Pages
                                        </div>
                                        <a
                                                href="./pages/about-us.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">About Us</span>
                                        </a>
                                        <a
                                                href="./pages/contact-us.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Contact Us</span>
                                        </a>
                                        <a
                                                href="./pages/author.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Author</span>
                                        </a>
                                        <div
                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center px-0 mt-3"
                                        >
                                            <div class="d-inline-block">
                                                <div
                                                        class="icon icon-shape icon-xs border-radius-md bg-primary text-center me-2 d-flex align-items-center justify-content-center ps-0"
                                                >
                                                    <svg
                                                            width="12px"
                                                            height="12px"
                                                            viewBox="0 0 42 42"
                                                            version="1.1"
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            xmlns:xlink="http://www.w3.org/1999/xlink"
                                                    >
                                                        <title>office</title>
                                                        <g
                                                                stroke="none"
                                                                stroke-width="1"
                                                                fill="none"
                                                                fill-rule="evenodd"
                                                        >
                                                            <g
                                                                    transform="translate(-1869.000000, -293.000000)"
                                                                    fill="#FFFFFF"
                                                                    fill-rule="nonzero"
                                                            >
                                                                <g
                                                                        transform="translate(1716.000000, 291.000000)"
                                                                >
                                                                    <g
                                                                            transform="translate(153.000000, 2.000000)"
                                                                    >
                                                                        <path
                                                                                d="M12.25,17.5 L8.75,17.5 L8.75,1.75 C8.75,0.78225 9.53225,0 10.5,0 L31.5,0 C32.46775,0 33.25,0.78225 33.25,1.75 L33.25,12.25 L29.75,12.25 L29.75,3.5 L12.25,3.5 L12.25,17.5 Z"
                                                                                opacity="0.6"
                                                                        ></path>
                                                                        <path
                                                                                d="M40.25,14 L24.5,14 C23.53225,14 22.75,14.78225 22.75,15.75 L22.75,38.5 L19.25,38.5 L19.25,22.75 C19.25,21.78225 18.46775,21 17.5,21 L1.75,21 C0.78225,21 0,21.78225 0,22.75 L0,40.25 C0,41.21775 0.78225,42 1.75,42 L40.25,42 C41.21775,42 42,41.21775 42,40.25 L42,15.75 C42,14.78225 41.21775,14 40.25,14 Z M12.25,36.75 L7,36.75 L7,33.25 L12.25,33.25 L12.25,36.75 Z M12.25,29.75 L7,29.75 L7,26.25 L12.25,26.25 L12.25,29.75 Z M35,36.75 L29.75,36.75 L29.75,33.25 L35,33.25 L35,36.75 Z M35,29.75 L29.75,29.75 L29.75,26.25 L35,26.25 L35,29.75 Z M35,22.75 L29.75,22.75 L29.75,19.25 L35,19.25 L35,22.75 Z"
                                                                        ></path>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                        </g>
                                                    </svg>
                                                </div>
                                            </div>
                                            Account
                                        </div>
                                        <a
                                                href="./pages/sign-in.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Sign In</span>
                                        </a>
                                    </div>
                                    <div class="d-lg-none">
                                        <div
                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center px-0"
                                        >
                                            <div class="d-inline-block">
                                                <div
                                                        class="icon icon-shape icon-xs border-radius-md bg-primary text-center me-2 d-flex align-items-center justify-content-center"
                                                >
                                                    <svg
                                                            width="12px"
                                                            height="12px"
                                                            viewBox="0 0 45 40"
                                                            version="1.1"
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            xmlns:xlink="http://www.w3.org/1999/xlink"
                                                    >
                                                        <title>shop</title>
                                                        <g
                                                                stroke="none"
                                                                stroke-width="1"
                                                                fill="none"
                                                                fill-rule="evenodd"
                                                        >
                                                            <g
                                                                    transform="translate(-1716.000000, -439.000000)"
                                                                    fill="#FFFFFF"
                                                                    fill-rule="nonzero"
                                                            >
                                                                <g
                                                                        transform="translate(1716.000000, 291.000000)"
                                                                >
                                                                    <g
                                                                            transform="translate(0.000000, 148.000000)"
                                                                    >
                                                                        <path
                                                                                d="M46.7199583,10.7414583 L40.8449583,0.949791667 C40.4909749,0.360605034 39.8540131,0 39.1666667,0 L7.83333333,0 C7.1459869,0 6.50902508,0.360605034 6.15504167,0.949791667 L0.280041667,10.7414583 C0.0969176761,11.0460037 -1.23209662e-05,11.3946378 -1.23209662e-05,11.75 C-0.00758042603,16.0663731 3.48367543,19.5725301 7.80004167,19.5833333 L7.81570833,19.5833333 C9.75003686,19.5882688 11.6168794,18.8726691 13.0522917,17.5760417 C16.0171492,20.2556967 20.5292675,20.2556967 23.494125,17.5760417 C26.4604562,20.2616016 30.9794188,20.2616016 33.94575,17.5760417 C36.2421905,19.6477597 39.5441143,20.1708521 42.3684437,18.9103691 C45.1927731,17.649886 47.0084685,14.8428276 47.0000295,11.75 C47.0000295,11.3946378 46.9030823,11.0460037 46.7199583,10.7414583 Z"
                                                                                opacity="0.598981585"
                                                                        ></path>
                                                                        <path
                                                                                d="M39.198,22.4912623 C37.3776246,22.4928106 35.5817531,22.0149171 33.951625,21.0951667 L33.92225,21.1107282 C31.1430221,22.6838032 27.9255001,22.9318916 24.9844167,21.7998837 C24.4750389,21.605469 23.9777983,21.3722567 23.4960833,21.1018359 L23.4745417,21.1129513 C20.6961809,22.6871153 17.4786145,22.9344611 14.5386667,21.7998837 C14.029926,21.6054643 13.533337,21.3722507 13.0522917,21.1018359 C11.4250962,22.0190609 9.63246555,22.4947009 7.81570833,22.4912623 C7.16510551,22.4842162 6.51607673,22.4173045 5.875,22.2911849 L5.875,44.7220845 C5.875,45.9498589 6.7517757,46.9451667 7.83333333,46.9451667 L19.5833333,46.9451667 L19.5833333,33.6066734 L27.4166667,33.6066734 L27.4166667,46.9451667 L39.1666667,46.9451667 C40.2482243,46.9451667 41.125,45.9498589 41.125,44.7220845 L41.125,22.2822926 C40.4887822,22.4116582 39.8442868,22.4815492 39.198,22.4912623 Z"
                                                                        ></path>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                        </g>
                                                    </svg>
                                                </div>
                                            </div>
                                            Landing Pages
                                        </div>
                                        <a
                                                href="./pages/about-us.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">About Us</span>
                                        </a>
                                        <a
                                                href="./pages/contact-us.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Contact Us</span>
                                        </a>
                                        <a
                                                href="./pages/author.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Author</span>
                                        </a>
                                        <div
                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center px-0 mt-3"
                                        >
                                            <div class="d-inline-block">
                                                <div
                                                        class="icon icon-shape icon-xs border-radius-md bg-primary text-center me-2 d-flex align-items-center justify-content-center ps-0"
                                                >
                                                    <svg
                                                            width="12px"
                                                            height="12px"
                                                            viewBox="0 0 42 42"
                                                            version="1.1"
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            xmlns:xlink="http://www.w3.org/1999/xlink"
                                                    >
                                                        <title>office</title>
                                                        <g
                                                                stroke="none"
                                                                stroke-width="1"
                                                                fill="none"
                                                                fill-rule="evenodd"
                                                        >
                                                            <g
                                                                    transform="translate(-1869.000000, -293.000000)"
                                                                    fill="#FFFFFF"
                                                                    fill-rule="nonzero"
                                                            >
                                                                <g
                                                                        transform="translate(1716.000000, 291.000000)"
                                                                >
                                                                    <g
                                                                            transform="translate(153.000000, 2.000000)"
                                                                    >
                                                                        <path
                                                                                d="M12.25,17.5 L8.75,17.5 L8.75,1.75 C8.75,0.78225 9.53225,0 10.5,0 L31.5,0 C32.46775,0 33.25,0.78225 33.25,1.75 L33.25,12.25 L29.75,12.25 L29.75,3.5 L12.25,3.5 L12.25,17.5 Z"
                                                                                opacity="0.6"
                                                                        ></path>
                                                                        <path
                                                                                d="M40.25,14 L24.5,14 C23.53225,14 22.75,14.78225 22.75,15.75 L22.75,38.5 L19.25,38.5 L19.25,22.75 C19.25,21.78225 18.46775,21 17.5,21 L1.75,21 C0.78225,21 0,21.78225 0,22.75 L0,40.25 C0,41.21775 0.78225,42 1.75,42 L40.25,42 C41.21775,42 42,41.21775 42,40.25 L42,15.75 C42,14.78225 41.21775,14 40.25,14 Z M12.25,36.75 L7,36.75 L7,33.25 L12.25,33.25 L12.25,36.75 Z M12.25,29.75 L7,29.75 L7,26.25 L12.25,26.25 L12.25,29.75 Z M35,36.75 L29.75,36.75 L29.75,33.25 L35,33.25 L35,36.75 Z M35,29.75 L29.75,29.75 L29.75,26.25 L35,26.25 L35,29.75 Z M35,22.75 L29.75,22.75 L29.75,19.25 L35,19.25 L35,22.75 Z"
                                                                        ></path>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                        </g>
                                                    </svg>
                                                </div>
                                            </div>
                                            Account
                                        </div>
                                        <a
                                                href="./pages/sign-in.html"
                                                class="dropdown-item border-radius-md"
                                        >
                                            <span class="ps-3">Sign In</span>
                                        </a>
                                    </div>
                                </div>
                            </li>
                            <li class="nav-item dropdown dropdown-hover mx-2">
                                <a
                                        class="nav-link ps-2 d-flex justify-content-between cursor-pointer align-items-center"
                                        href="javascript:;"
                                        id="dropdownMenuBlocks"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false"
                                >
                                    Blocks
                                    <img
                                            src="./assets/img/down-arrow-dark.svg"
                                            alt="down-arrow"
                                            class="arrow ms-1"
                                    />
                                </a>
                                <ul
                                        class="dropdown-menu dropdown-menu-animation dropdown-lg dropdown-lg-responsive p-3 border-radius-lg mt-0 mt-lg-3"
                                        aria-labelledby="dropdownMenuBlocks"
                                >
                                    <div class="d-none d-lg-block">
                                        <li
                                                class="nav-item dropdown dropdown-hover dropdown-subitem"
                                        >
                                            <a
                                                    class="dropdown-item py-2 ps-3 border-radius-md"
                                                    href="./presentation.html"
                                            >
                                                <div class="d-flex">
                                                    <div class="icon h-10 me-3 d-flex mt-1">
                                                        <i
                                                                class="ni ni-single-copy-04 text-gradient text-primary"
                                                        ></i>
                                                    </div>
                                                    <div
                                                            class="w-100 d-flex align-items-center justify-content-between"
                                                    >
                                                        <div>
                                                            <h6
                                                                    class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                            >
                                                                Page Sections
                                                            </h6>
                                                            <span class="text-sm">See all sections</span>
                                                        </div>
                                                        <img
                                                                src="./assets/img/down-arrow.svg"
                                                                alt="down-arrow"
                                                                class="arrow"
                                                        />
                                                    </div>
                                                </div>
                                            </a>
                                            <div class="dropdown-menu mt-0 py-3 px-2 mt-3">
                                                <a
                                                        class="dropdown-item ps-3 border-radius-md mb-1"
                                                        href="./sections/page-sections/hero-sections.html"
                                                >
                                                    Page Headers
                                                </a>
                                                <a
                                                        class="dropdown-item ps-3 border-radius-md mb-1"
                                                        href="./sections/page-sections/features.html"
                                                >
                                                    Features
                                                </a>
                                            </div>
                                        </li>
                                        <li
                                                class="nav-item dropdown dropdown-hover dropdown-subitem"
                                        >
                                            <a
                                                    class="dropdown-item py-2 ps-3 border-radius-md"
                                                    href="./presentation.html"
                                            >
                                                <div class="d-flex">
                                                    <div class="icon h-10 me-3 d-flex mt-1">
                                                        <i
                                                                class="ni ni-laptop text-gradient text-primary"
                                                        ></i>
                                                    </div>
                                                    <div
                                                            class="w-100 d-flex align-items-center justify-content-between"
                                                    >
                                                        <div>
                                                            <h6
                                                                    class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                            >
                                                                Navigation
                                                            </h6>
                                                            <span class="text-sm"
                                                            >See all navigations</span
                                                            >
                                                        </div>
                                                        <img
                                                                src="./assets/img/down-arrow.svg"
                                                                alt="down-arrow"
                                                                class="arrow"
                                                        />
                                                    </div>
                                                </div>
                                            </a>
                                            <div class="dropdown-menu mt-0 py-3 px-2 mt-3">
                                                <a
                                                        class="dropdown-item ps-3 border-radius-md mb-1"
                                                        href="./sections/navigation/navbars.html"
                                                >
                                                    Navbars
                                                </a>
                                                <a
                                                        class="dropdown-item ps-3 border-radius-md mb-1"
                                                        href="./sections/navigation/nav-tabs.html"
                                                >
                                                    Nav Tabs
                                                </a>
                                                <a
                                                        class="dropdown-item ps-3 border-radius-md mb-1"
                                                        href="./sections/navigation/pagination.html"
                                                >
                                                    Pagination
                                                </a>
                                            </div>
                                        </li>
                                    </div>
                                    <div class="row d-lg-none">
                                        <div class="col-md-12">
                                            <div class="d-flex mb-2">
                                                <div class="icon h-10 me-3 d-flex mt-1">
                                                    <i
                                                            class="ni ni-single-copy-04 text-gradient text-primary"
                                                    ></i>
                                                </div>
                                                <div
                                                        class="w-100 d-flex align-items-center justify-content-between"
                                                >
                                                    <div>
                                                        <h6
                                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                        >
                                                            Page Sections
                                                        </h6>
                                                    </div>
                                                </div>
                                            </div>
                                            <a
                                                    class="dropdown-item ps-3 border-radius-md mb-1"
                                                    href="./sections/page-sections/hero-sections.html"
                                            >
                                                Page Headers
                                            </a>
                                            <a
                                                    class="dropdown-item ps-3 border-radius-md mb-1"
                                                    href="./sections/page-sections/features.html"
                                            >
                                                Features
                                            </a>
                                            <div class="d-flex mb-2 mt-3">
                                                <div class="icon h-10 me-3 d-flex mt-1">
                                                    <i
                                                            class="ni ni-laptop text-gradient text-primary"
                                                    ></i>
                                                </div>
                                                <div
                                                        class="w-100 d-flex align-items-center justify-content-between"
                                                >
                                                    <div>
                                                        <h6
                                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                        >
                                                            Navigation
                                                        </h6>
                                                    </div>
                                                </div>
                                            </div>
                                            <a
                                                    class="dropdown-item ps-3 border-radius-md mb-1"
                                                    href="./sections/navigation/navbars.html"
                                            >
                                                Navbars
                                            </a>
                                            <a
                                                    class="dropdown-item ps-3 border-radius-md mb-1"
                                                    href="./sections/navigation/nav-tabs.html"
                                            >
                                                Nav Tabs
                                            </a>
                                            <a
                                                    class="dropdown-item ps-3 border-radius-md mb-1"
                                                    href="./sections/navigation/pagination.html"
                                            >
                                                Pagination
                                            </a>
                                        </div>
                                    </div>
                                </ul>
                            </li>
                            <li class="nav-item dropdown dropdown-hover mx-2">
                                <a
                                        class="nav-link ps-2 d-flex justify-content-between cursor-pointer align-items-center"
                                        href="javascript:;"
                                        id="dropdownMenuDocs"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false"
                                >
                                    Docs
                                    <img
                                            src="./assets/img/down-arrow-dark.svg"
                                            alt="down-arrow"
                                            class="arrow ms-1"
                                    />
                                </a>
                                <div
                                        class="dropdown-menu dropdown-menu-animation dropdown-lg mt-0 mt-lg-3 p-3 border-radius-lg"
                                        aria-labelledby="dropdownMenuDocs"
                                >
                                    <div class="d-none d-lg-block">
                                        <ul class="list-group">
                                            <li class="nav-item list-group-item border-0 p-0">
                                                <a
                                                        class="dropdown-item py-2 ps-3 border-radius-md"
                                                        href=" https://www.creative-tim.com/learning-lab/bootstrap/license/soft-ui-design-system "
                                                >
                                                    <div class="d-flex">
                                                        <div class="icon h-10 me-3 d-flex mt-1">
                                                            <svg
                                                                    class="text-secondary"
                                                                    width="16px"
                                                                    height="16px"
                                                                    viewBox="0 0 40 40"
                                                                    version="1.1"
                                                                    xmlns="http://www.w3.org/2000/svg"
                                                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                                                            >
                                                                <title>spaceship</title>
                                                                <g
                                                                        stroke="none"
                                                                        stroke-width="1"
                                                                        fill="none"
                                                                        fill-rule="evenodd"
                                                                >
                                                                    <g
                                                                            transform="translate(-1720.000000, -592.000000)"
                                                                            fill="#FFFFFF"
                                                                            fill-rule="nonzero"
                                                                    >
                                                                        <g
                                                                                transform="translate(1716.000000, 291.000000)"
                                                                        >
                                                                            <g
                                                                                    transform="translate(4.000000, 301.000000)"
                                                                            >
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M39.3,0.706666667 C38.9660984,0.370464027 38.5048767,0.192278529 38.0316667,0.216666667 C14.6516667,1.43666667 6.015,22.2633333 5.93166667,22.4733333 C5.68236407,23.0926189 5.82664679,23.8009159 6.29833333,24.2733333 L15.7266667,33.7016667 C16.2013871,34.1756798 16.9140329,34.3188658 17.535,34.065 C17.7433333,33.98 38.4583333,25.2466667 39.7816667,1.97666667 C39.8087196,1.50414529 39.6335979,1.04240574 39.3,0.706666667 Z M25.69,19.0233333 C24.7367525,19.9768687 23.3029475,20.2622391 22.0572426,19.7463614 C20.8115377,19.2304837 19.9992882,18.0149658 19.9992882,16.6666667 C19.9992882,15.3183676 20.8115377,14.1028496 22.0572426,13.5869719 C23.3029475,13.0710943 24.7367525,13.3564646 25.69,14.31 C26.9912731,15.6116662 26.9912731,17.7216672 25.69,19.0233333 L25.69,19.0233333 Z"
                                                                                ></path>
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M1.855,31.4066667 C3.05106558,30.2024182 4.79973884,29.7296005 6.43969145,30.1670277 C8.07964407,30.6044549 9.36054508,31.8853559 9.7979723,33.5253085 C10.2353995,35.1652612 9.76258177,36.9139344 8.55833333,38.11 C6.70666667,39.9616667 0,40 0,40 C0,40 0,33.2566667 1.855,31.4066667 Z"
                                                                                ></path>
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M17.2616667,3.90166667 C12.4943643,3.07192755 7.62174065,4.61673894 4.20333333,8.04166667 C3.31200265,8.94126033 2.53706177,9.94913142 1.89666667,11.0416667 C1.5109569,11.6966059 1.61721591,12.5295394 2.155,13.0666667 L5.47,16.3833333 C8.55036617,11.4946947 12.5559074,7.25476565 17.2616667,3.90166667 L17.2616667,3.90166667 Z"
                                                                                        opacity="0.598539807"
                                                                                ></path>
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M36.0983333,22.7383333 C36.9280725,27.5056357 35.3832611,32.3782594 31.9583333,35.7966667 C31.0587397,36.6879974 30.0508686,37.4629382 28.9583333,38.1033333 C28.3033941,38.4890431 27.4704606,38.3827841 26.9333333,37.845 L23.6166667,34.53 C28.5053053,31.4496338 32.7452344,27.4440926 36.0983333,22.7383333 L36.0983333,22.7383333 Z"
                                                                                        opacity="0.598539807"
                                                                                ></path>
                                                                            </g>
                                                                        </g>
                                                                    </g>
                                                                </g>
                                                            </svg>
                                                        </div>
                                                        <div>
                                                            <h6
                                                                    class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                            >
                                                                Getting Started
                                                            </h6>
                                                            <span class="text-sm"
                                                            >All about overview, quick start, license
                                    and contents</span
                                                            >
                                                        </div>
                                                    </div>
                                                </a>
                                            </li>
                                            <li class="nav-item list-group-item border-0 p-0">
                                                <a
                                                        class="dropdown-item py-2 ps-3 border-radius-md"
                                                        href=""
                                                >
                                                    <div class="d-flex">
                                                        <div class="icon h-10 me-3 d-flex mt-1">
                                                            <svg
                                                                    class="text-secondary"
                                                                    width="16px"
                                                                    height="16px"
                                                                    viewBox="0 0 40 44"
                                                                    version="1.1"
                                                                    xmlns="http://www.w3.org/2000/svg"
                                                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                                                            >
                                                                <title>document</title>
                                                                <g
                                                                        stroke="none"
                                                                        stroke-width="1"
                                                                        fill="none"
                                                                        fill-rule="evenodd"
                                                                >
                                                                    <g
                                                                            transform="translate(-1870.000000, -591.000000)"
                                                                            fill="#FFFFFF"
                                                                            fill-rule="nonzero"
                                                                    >
                                                                        <g
                                                                                transform="translate(1716.000000, 291.000000)"
                                                                        >
                                                                            <g
                                                                                    transform="translate(154.000000, 300.000000)"
                                                                            >
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M40,40 L36.3636364,40 L36.3636364,3.63636364 L5.45454545,3.63636364 L5.45454545,0 L38.1818182,0 C39.1854545,0 40,0.814545455 40,1.81818182 L40,40 Z"
                                                                                        opacity="0.603585379"
                                                                                ></path>
                                                                                <path
                                                                                        class="color-background"
                                                                                        d="M30.9090909,7.27272727 L1.81818182,7.27272727 C0.814545455,7.27272727 0,8.08727273 0,9.09090909 L0,41.8181818 C0,42.8218182 0.814545455,43.6363636 1.81818182,43.6363636 L30.9090909,43.6363636 C31.9127273,43.6363636 32.7272727,42.8218182 32.7272727,41.8181818 L32.7272727,9.09090909 C32.7272727,8.08727273 31.9127273,7.27272727 30.9090909,7.27272727 Z M18.1818182,34.5454545 L7.27272727,34.5454545 L7.27272727,30.9090909 L18.1818182,30.9090909 L18.1818182,34.5454545 Z M25.4545455,27.2727273 L7.27272727,27.2727273 L7.27272727,23.6363636 L25.4545455,23.6363636 L25.4545455,27.2727273 Z M25.4545455,20 L7.27272727,20 L7.27272727,16.3636364 L25.4545455,16.3636364 L25.4545455,20 Z"
                                                                                ></path>
                                                                            </g>
                                                                        </g>
                                                                    </g>
                                                                </g>
                                                            </svg>
                                                        </div>
                                                        <div>
                                                            <h6
                                                                    class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                            >
                                                                Foundation
                                                            </h6>
                                                            <span class="text-sm"
                                                            >See our colors, icons and typography</span
                                                            >
                                                        </div>
                                                    </div>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="row d-lg-none">
                                        <div class="col-md-12 g-0">
                                            <a
                                                    class="dropdown-item py-2 ps-3 border-radius-md"
                                                    href="./pages/about-us.html"
                                            >
                                                <div class="d-flex">
                                                    <div class="icon h-10 me-3 d-flex mt-1">
                                                        <svg
                                                                class="text-secondary"
                                                                width="16px"
                                                                height="16px"
                                                                viewBox="0 0 40 40"
                                                                version="1.1"
                                                                xmlns="http://www.w3.org/2000/svg"
                                                                xmlns:xlink="http://www.w3.org/1999/xlink"
                                                        >
                                                            <title>spaceship</title>
                                                            <g
                                                                    stroke="none"
                                                                    stroke-width="1"
                                                                    fill="none"
                                                                    fill-rule="evenodd"
                                                            >
                                                                <g
                                                                        transform="translate(-1720.000000, -592.000000)"
                                                                        fill="#FFFFFF"
                                                                        fill-rule="nonzero"
                                                                >
                                                                    <g
                                                                            transform="translate(1716.000000, 291.000000)"
                                                                    >
                                                                        <g
                                                                                transform="translate(4.000000, 301.000000)"
                                                                        >
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M39.3,0.706666667 C38.9660984,0.370464027 38.5048767,0.192278529 38.0316667,0.216666667 C14.6516667,1.43666667 6.015,22.2633333 5.93166667,22.4733333 C5.68236407,23.0926189 5.82664679,23.8009159 6.29833333,24.2733333 L15.7266667,33.7016667 C16.2013871,34.1756798 16.9140329,34.3188658 17.535,34.065 C17.7433333,33.98 38.4583333,25.2466667 39.7816667,1.97666667 C39.8087196,1.50414529 39.6335979,1.04240574 39.3,0.706666667 Z M25.69,19.0233333 C24.7367525,19.9768687 23.3029475,20.2622391 22.0572426,19.7463614 C20.8115377,19.2304837 19.9992882,18.0149658 19.9992882,16.6666667 C19.9992882,15.3183676 20.8115377,14.1028496 22.0572426,13.5869719 C23.3029475,13.0710943 24.7367525,13.3564646 25.69,14.31 C26.9912731,15.6116662 26.9912731,17.7216672 25.69,19.0233333 L25.69,19.0233333 Z"
                                                                            ></path>
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M1.855,31.4066667 C3.05106558,30.2024182 4.79973884,29.7296005 6.43969145,30.1670277 C8.07964407,30.6044549 9.36054508,31.8853559 9.7979723,33.5253085 C10.2353995,35.1652612 9.76258177,36.9139344 8.55833333,38.11 C6.70666667,39.9616667 0,40 0,40 C0,40 0,33.2566667 1.855,31.4066667 Z"
                                                                            ></path>
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M17.2616667,3.90166667 C12.4943643,3.07192755 7.62174065,4.61673894 4.20333333,8.04166667 C3.31200265,8.94126033 2.53706177,9.94913142 1.89666667,11.0416667 C1.5109569,11.6966059 1.61721591,12.5295394 2.155,13.0666667 L5.47,16.3833333 C8.55036617,11.4946947 12.5559074,7.25476565 17.2616667,3.90166667 L17.2616667,3.90166667 Z"
                                                                                    opacity="0.598539807"
                                                                            ></path>
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M36.0983333,22.7383333 C36.9280725,27.5056357 35.3832611,32.3782594 31.9583333,35.7966667 C31.0587397,36.6879974 30.0508686,37.4629382 28.9583333,38.1033333 C28.3033941,38.4890431 27.4704606,38.3827841 26.9333333,37.845 L23.6166667,34.53 C28.5053053,31.4496338 32.7452344,27.4440926 36.0983333,22.7383333 L36.0983333,22.7383333 Z"
                                                                                    opacity="0.598539807"
                                                                            ></path>
                                                                        </g>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                            </g>
                                                        </svg>
                                                    </div>
                                                    <div>
                                                        <h6
                                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                        >
                                                            Getting Started
                                                        </h6>
                                                        <span class="text-sm"
                                                        >All about overview, quick start, license and
                                  contents</span
                                                        >
                                                    </div>
                                                </div>
                                            </a>
                                            <a
                                                    class="dropdown-item py-2 ps-3 border-radius-md"
                                                    href="./pages/about-us.html"
                                            >
                                                <div class="d-flex">
                                                    <div class="icon h-10 me-3 d-flex mt-1">
                                                        <svg
                                                                class="text-secondary"
                                                                width="16px"
                                                                height="16px"
                                                                viewBox="0 0 40 44"
                                                                version="1.1"
                                                                xmlns="http://www.w3.org/2000/svg"
                                                                xmlns:xlink="http://www.w3.org/1999/xlink"
                                                        >
                                                            <title>document</title>
                                                            <g
                                                                    stroke="none"
                                                                    stroke-width="1"
                                                                    fill="none"
                                                                    fill-rule="evenodd"
                                                            >
                                                                <g
                                                                        transform="translate(-1870.000000, -591.000000)"
                                                                        fill="#FFFFFF"
                                                                        fill-rule="nonzero"
                                                                >
                                                                    <g
                                                                            transform="translate(1716.000000, 291.000000)"
                                                                    >
                                                                        <g
                                                                                transform="translate(154.000000, 300.000000)"
                                                                        >
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M40,40 L36.3636364,40 L36.3636364,3.63636364 L5.45454545,3.63636364 L5.45454545,0 L38.1818182,0 C39.1854545,0 40,0.814545455 40,1.81818182 L40,40 Z"
                                                                                    opacity="0.603585379"
                                                                            ></path>
                                                                            <path
                                                                                    class="color-background"
                                                                                    d="M30.9090909,7.27272727 L1.81818182,7.27272727 C0.814545455,7.27272727 0,8.08727273 0,9.09090909 L0,41.8181818 C0,42.8218182 0.814545455,43.6363636 1.81818182,43.6363636 L30.9090909,43.6363636 C31.9127273,43.6363636 32.7272727,42.8218182 32.7272727,41.8181818 L32.7272727,9.09090909 C32.7272727,8.08727273 31.9127273,7.27272727 30.9090909,7.27272727 Z M18.1818182,34.5454545 L7.27272727,34.5454545 L7.27272727,30.9090909 L18.1818182,30.9090909 L18.1818182,34.5454545 Z M25.4545455,27.2727273 L7.27272727,27.2727273 L7.27272727,23.6363636 L25.4545455,23.6363636 L25.4545455,27.2727273 Z M25.4545455,20 L7.27272727,20 L7.27272727,16.3636364 L25.4545455,16.3636364 L25.4545455,20 Z"
                                                                            ></path>
                                                                        </g>
                                                                    </g>
                                                                </g>
                                                            </g>
                                                            </g>
                                                        </svg>
                                                    </div>
                                                    <div>
                                                        <h6
                                                                class="dropdown-header text-dark font-weight-bolder d-flex justify-content-cente align-items-center p-0"
                                                        >
                                                            Foundation
                                                        </h6>
                                                        <span class="text-sm"
                                                        >See our colors, icons and typography</span
                                                        >
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
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
                        COREFIT GYM</h1>
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

<section class="my-5 py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 ms-auto">
                <div class="row justify-content-start">
                    <div class="col-md-6">
                        <div class="info">
                            <div class="icon icon-sm">
                                <svg
                                        class="text-dark"
                                        width="25px"
                                        height="25px"
                                        viewBox="0 0 40 44"
                                        version="1.1"
                                        xmlns="http://www.w3.org/2000/svg"
                                        xmlns:xlink="http://www.w3.org/1999/xlink"
                                >
                                    <title>document</title>
                                    <g
                                            stroke="none"
                                            stroke-width="1"
                                            fill="none"
                                            fill-rule="evenodd"
                                    >
                                        <g
                                                transform="translate(-1870.000000, -591.000000)"
                                                fill="#FFFFFF"
                                                fill-rule="nonzero"
                                        >
                                            <g transform="translate(1716.000000, 291.000000)">
                                                <g transform="translate(154.000000, 300.000000)">
                                                    <path
                                                            class="color-background"
                                                            d="M40,40 L36.3636364,40 L36.3636364,3.63636364 L5.45454545,3.63636364 L5.45454545,0 L38.1818182,0 C39.1854545,0 40,0.814545455 40,1.81818182 L40,40 Z"
                                                            opacity="0.603585379"
                                                    ></path>
                                                    <path
                                                            class="color-background"
                                                            d="M30.9090909,7.27272727 L1.81818182,7.27272727 C0.814545455,7.27272727 0,8.08727273 0,9.09090909 L0,41.8181818 C0,42.8218182 0.814545455,43.6363636 1.81818182,43.6363636 L30.9090909,43.6363636 C31.9127273,43.6363636 32.7272727,42.8218182 32.7272727,41.8181818 L32.7272727,9.09090909 C32.7272727,8.08727273 31.9127273,7.27272727 30.9090909,7.27272727 Z M18.1818182,34.5454545 L7.27272727,34.5454545 L7.27272727,30.9090909 L18.1818182,30.9090909 L18.1818182,34.5454545 Z M25.4545455,27.2727273 L7.27272727,27.2727273 L7.27272727,23.6363636 L25.4545455,23.6363636 L25.4545455,27.2727273 Z M25.4545455,20 L7.27272727,20 L7.27272727,16.3636364 L25.4545455,16.3636364 L25.4545455,20 Z"
                                                    ></path>
                                                </g>
                                            </g>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <h5 class="font-weight-bolder mt-3">Thiết bị hiện đại</h5>
                            <p class="pe-5">
                                Phòng tập được trang bị các thiết bị tập luyện tiên tiến nhất, đảm bảo hiệu quả và an
                                toàn cho mọi thành viên.
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info">
                            <div class="icon icon-sm">
                                <svg
                                        class="text-dark"
                                        width="25px"
                                        height="25px"
                                        viewBox="0 0 45 40"
                                        version="1.1"
                                        xmlns="http://www.w3.org/2000/svg"
                                        xmlns:xlink="http://www.w3.org/1999/xlink"
                                >
                                    <title>shop</title>
                                    <g
                                            stroke="none"
                                            stroke-width="1"
                                            fill="none"
                                            fill-rule="evenodd"
                                    >
                                        <g
                                                transform="translate(-1716.000000, -439.000000)"
                                                fill="#FFFFFF"
                                                fill-rule="nonzero"
                                        >
                                            <g transform="translate(1716.000000, 291.000000)">
                                                <g
                                                        id="shop-"
                                                        transform="translate(0.000000, 148.000000)"
                                                >
                                                    <path
                                                            class="color-background"
                                                            d="M46.7199583,10.7414583 L40.8449583,0.949791667 C40.4909749,0.360605034 39.8540131,0 39.1666667,0 L7.83333333,0 C7.1459869,0 6.50902508,0.360605034 6.15504167,0.949791667 L0.280041667,10.7414583 C0.0969176761,11.0460037 -1.23209662e-05,11.3946378 -1.23209662e-05,11.75 C-0.00758042603,16.0663731 3.48367543,19.5725301 7.80004167,19.5833333 L7.81570833,19.5833333 C9.75003686,19.5882688 11.6168794,18.8726691 13.0522917,17.5760417 C16.0171492,20.2556967 20.5292675,20.2556967 23.494125,17.5760417 C26.4604562,20.2616016 30.9794188,20.2616016 33.94575,17.5760417 C36.2421905,19.6477597 39.5441143,20.1708521 42.3684437,18.9103691 C45.1927731,17.649886 47.0084685,14.8428276 47.0000295,11.75 C47.0000295,11.3946378 46.9030823,11.0460037 46.7199583,10.7414583 Z"
                                                            opacity="0.598981585"
                                                    ></path>
                                                    <path
                                                            class="color-background"
                                                            d="M39.198,22.4912623 C37.3776246,22.4928106 35.5817531,22.0149171 33.951625,21.0951667 L33.92225,21.1107282 C31.1430221,22.6838032 27.9255001,22.9318916 24.9844167,21.7998837 C24.4750389,21.605469 23.9777983,21.3722567 23.4960833,21.1018359 L23.4745417,21.1129513 C20.6961809,22.6871153 17.4786145,22.9344611 14.5386667,21.7998837 C14.029926,21.6054643 13.533337,21.3722507 13.0522917,21.1018359 C11.4250962,22.0190609 9.63246555,22.4947009 7.81570833,22.4912623 C7.16510551,22.4842162 6.51607673,22.4173045 5.875,22.2911849 L5.875,44.7220845 C5.875,45.9498589 6.7517757,46.9451667 7.83333333,46.9451667 L19.5833333,46.9451667 L19.5833333,33.6066734 L27.4166667,33.6066734 L27.4166667,46.9451667 L39.1666667,46.9451667 C40.2482243,46.9451667 41.125,45.9498589 41.125,44.7220845 L41.125,22.2822926 C40.4887822,22.4116582 39.8442868,22.4815492 39.198,22.4912623 Z"
                                                    ></path>
                                                </g>
                                            </g>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <h5 class="font-weight-bolder mt-3">Không gian rộng rãi</h5>
                            <p class="pe-3">
                                Phòng tập được thiết kế rộng rãi, thoáng mát với nhiều khu vực chức năng riêng biệt cho
                                từng loại bài tập.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-start mt-5">
                    <div class="col-md-6 mt-3">
                        <div class="info">
                            <div class="icon icon-sm">
                                <svg
                                        class="text-dark"
                                        width="25px"
                                        height="25px"
                                        viewBox="0 0 42 44"
                                        version="1.1"
                                        xmlns="http://www.w3.org/2000/svg"
                                        xmlns:xlink="http://www.w3.org/1999/xlink"
                                >
                                    <title>time-alarm</title>
                                    <g
                                            stroke="none"
                                            stroke-width="1"
                                            fill="none"
                                            fill-rule="evenodd"
                                    >
                                        <g
                                                transform="translate(-2319.000000, -440.000000)"
                                                fill="#923DFA"
                                                fill-rule="nonzero"
                                        >
                                            <g transform="translate(1716.000000, 291.000000)">
                                                <g
                                                        id="time-alarm"
                                                        transform="translate(603.000000, 149.000000)"
                                                >
                                                    <path
                                                            class="color-background"
                                                            d="M18.8086957,4.70034783 C15.3814926,0.343541521 9.0713063,-0.410050841 4.7145,3.01715217 C0.357693695,6.44435519 -0.395898667,12.7545415 3.03130435,17.1113478 C5.53738466,10.3360568 11.6337901,5.54042955 18.8086957,4.70034783 L18.8086957,4.70034783 Z"
                                                            opacity="0.6"
                                                    ></path>
                                                    <path
                                                            class="color-background"
                                                            d="M38.9686957,17.1113478 C42.3958987,12.7545415 41.6423063,6.44435519 37.2855,3.01715217 C32.9286937,-0.410050841 26.6185074,0.343541521 23.1913043,4.70034783 C30.3662099,5.54042955 36.4626153,10.3360568 38.9686957,17.1113478 Z"
                                                            opacity="0.6"
                                                    ></path>
                                                    <path
                                                            class="color-background"
                                                            d="M34.3815652,34.7668696 C40.2057958,27.7073059 39.5440671,17.3375603 32.869743,11.0755718 C26.1954189,4.81358341 15.8045811,4.81358341 9.13025701,11.0755718 C2.45593289,17.3375603 1.79420418,27.7073059 7.61843478,34.7668696 L3.9753913,40.0506522 C3.58549114,40.5871271 3.51710058,41.2928217 3.79673036,41.8941824 C4.07636014,42.4955431 4.66004722,42.8980248 5.32153275,42.9456105 C5.98301828,42.9931963 6.61830436,42.6784048 6.98113043,42.1232609 L10.2744783,37.3434783 C16.5555112,42.3298213 25.4444888,42.3298213 31.7255217,37.3434783 L35.0188696,42.1196087 C35.6014207,42.9211577 36.7169135,43.1118605 37.53266,42.5493622 C38.3484064,41.9868639 38.5667083,40.8764423 38.0246087,40.047 L34.3815652,34.7668696 Z M30.1304348,25.5652174 L21,25.5652174 C20.49574,25.5652174 20.0869565,25.1564339 20.0869565,24.6521739 L20.0869565,15.5217391 C20.0869565,15.0174791 20.49574,14.6086957 21,14.6086957 C21.50426,14.6086957 21.9130435,15.0174791 21.9130435,15.5217391 L21.9130435,23.7391304 L30.1304348,23.7391304 C30.6346948,23.7391304 31.0434783,24.1479139 31.0434783,24.6521739 C31.0434783,25.1564339 30.6346948,25.5652174 30.1304348,25.5652174 Z"
                                                    ></path>
                                                </g>
                                            </g>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <h5 class="font-weight-bolder mt-3">Lịch tập linh hoạt</h5>
                            <p class="pe-5">
                                Phòng tập mở cửa từ sáng sớm đến tối muộn, giúp bạn dễ dàng sắp xếp thời gian tập luyện
                                phù hợp với lịch trình bận rộn.
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6 mt-3">
                        <div class="info">
                            <div class="icon icon-sm">
                                <svg
                                        class="text-dark"
                                        width="25px"
                                        height="25px"
                                        viewBox="0 0 42 42"
                                        version="1.1"
                                        xmlns="http://www.w3.org/2000/svg"
                                        xmlns:xlink="http://www.w3.org/1999/xlink"
                                >
                                    <title>office</title>
                                    <g
                                            stroke="none"
                                            stroke-width="1"
                                            fill="none"
                                            fill-rule="evenodd"
                                    >
                                        <g
                                                transform="translate(-1869.000000, -293.000000)"
                                                fill="#FFFFFF"
                                                fill-rule="nonzero"
                                        >
                                            <g transform="translate(1716.000000, 291.000000)">
                                                <g
                                                        id="office"
                                                        transform="translate(153.000000, 2.000000)"
                                                >
                                                    <path
                                                            class="color-background"
                                                            d="M12.25,17.5 L8.75,17.5 L8.75,1.75 C8.75,0.78225 9.53225,0 10.5,0 L31.5,0 C32.46775,0 33.25,0.78225 33.25,1.75 L33.25,12.25 L29.75,12.25 L29.75,3.5 L12.25,3.5 L12.25,17.5 Z"
                                                            opacity="0.6"
                                                    ></path>
                                                    <path
                                                            class="color-background"
                                                            d="M40.25,14 L24.5,14 C23.53225,14 22.75,14.78225 22.75,15.75 L22.75,38.5 L19.25,38.5 L19.25,22.75 C19.25,21.78225 18.46775,21 17.5,21 L1.75,21 C0.78225,21 0,21.78225 0,22.75 L0,40.25 C0,41.21775 0.78225,42 1.75,42 L40.25,42 C41.21775,42 42,41.21775 42,40.25 L42,15.75 C42,14.78225 41.21775,14 40.25,14 Z M12.25,36.75 L7,36.75 L7,33.25 L12.25,33.25 L12.25,36.75 Z M12.25,29.75 L7,29.75 L7,26.25 L12.25,26.25 L12.25,29.75 Z M35,36.75 L29.75,36.75 L29.75,33.25 L35,33.25 L35,36.75 Z M35,29.75 L29.75,29.75 L29.75,26.25 L35,26.25 L35,29.75 Z M35,22.75 L29.75,22.75 L29.75,19.25 L35,19.25 L35,22.75 Z"
                                                    ></path>
                                                </g>
                                            </g>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <h5 class="font-weight-bolder mt-3">Đa dạng dịch vụ</h5>
                            <p class="pe-3">
                                Từ tập luyện cá nhân, lớp học nhóm đến yoga, pilates và các dịch vụ chăm sóc sức khỏe
                                khác đều có sẵn tại CoreFit Gym.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 ms-auto me-auto p-lg-4 mt-lg-0 mt-4">
                <div
                        class="card card-background card-background-mask-dark tilt"
                        data-tilt
                >
                    <div
                            class="full-background"
                            style="
                  background-image: url('https://images.pexels.com/photos/2247179/pexels-photo-2247179.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
                "
                    ></div>
                    <div class="card-body pt-7 text-center">
                        <div class="icon icon-lg up mb-3 mt-3">
                            <svg
                                    width="50px"
                                    height="50px"
                                    viewBox="0 0 42 42"
                                    version="1.1"
                                    xmlns="http://www.w3.org/2000/svg"
                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                            >
                                <title>box-3d-50</title>
                                <g
                                        stroke="none"
                                        stroke-width="1"
                                        fill="none"
                                        fill-rule="evenodd"
                                >
                                    <g
                                            transform="translate(-2319.000000, -291.000000)"
                                            fill="#FFFFFF"
                                            fill-rule="nonzero"
                                    >
                                        <g transform="translate(1716.000000, 291.000000)">
                                            <g
                                                    id="box-3d-50"
                                                    transform="translate(603.000000, 0.000000)"
                                            >
                                                <path
                                                        d="M22.7597136,19.3090182 L38.8987031,11.2395234 C39.3926816,10.9925342 39.592906,10.3918611 39.3459167,9.89788265 C39.249157,9.70436312 39.0922432,9.5474453 38.8987261,9.45068056 L20.2741875,0.1378125 L20.2741875,0.1378125 C19.905375,-0.04725 19.469625,-0.04725 19.0995,0.1378125 L3.1011696,8.13815822 C2.60720568,8.38517662 2.40701679,8.98586148 2.6540352,9.4798254 C2.75080129,9.67332903 2.90771305,9.83023153 3.10122239,9.9269862 L21.8652864,19.3090182 C22.1468139,19.4497819 22.4781861,19.4497819 22.7597136,19.3090182 Z"
                                                ></path>
                                                <path
                                                        d="M23.625,22.429159 L23.625,39.8805372 C23.625,40.4328219 24.0727153,40.8805372 24.625,40.8805372 C24.7802551,40.8805372 24.9333778,40.8443874 25.0722402,40.7749511 L41.2741875,32.673375 L41.2741875,32.673375 C41.719125,32.4515625 42,31.9974375 42,31.5 L42,14.241659 C42,13.6893742 41.5522847,13.241659 41,13.241659 C40.8447549,13.241659 40.6916418,13.2778041 40.5527864,13.3472318 L24.1777864,21.5347318 C23.8390024,21.7041238 23.625,22.0503869 23.625,22.429159 Z"
                                                        opacity="0.7"
                                                ></path>
                                                <path
                                                        d="M20.4472136,21.5347318 L1.4472136,12.0347318 C0.953235098,11.7877425 0.352562058,11.9879669 0.105572809,12.4819454 C0.0361450918,12.6208008 6.47121774e-16,12.7739139 0,12.929159 L0,30.1875 L0,30.1875 C0,30.6849375 0.280875,31.1390625 0.7258125,31.3621875 L19.5528096,40.7750766 C20.0467945,41.0220531 20.6474623,40.8218132 20.8944388,40.3278283 C20.963859,40.1889789 21,40.0358742 21,39.8806379 L21,22.429159 C21,22.0503869 20.7859976,21.7041238 20.4472136,21.5347318 Z"
                                                        opacity="0.7"
                                                ></path>
                                            </g>
                                        </g>
                                    </g>
                                </g>
                            </svg>
                        </div>
                        <h2 class="text-white up mb-0">
                            Trải nghiệm <br/>
                            CoreFit Gym ngay hôm nay
                        </h2>
                        <a
                                href="/login"
                                target="_blank"
                                class="btn btn-outline-white mt-5 up btn-round"
                        >Đăng nhập ngay</a
                        >
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="my-5 py-5">
    <div class="container">
        <div class="row">
            <div class="row justify-content-center text-center my-sm-5">
                <div class="col-lg-6">
                    <h2 class="text-dark mb-0">Thiết bị tập luyện tại CoreFit Gym</h2>
                    <h2 class="text-primary text-gradient">Hiện đại và đa dạng</h2>
                    <p class="lead">
                        Khám phá bộ sưu tập thiết bị tập luyện hiện đại và chuyên nghiệp tại CoreFit Gym,
                        được thiết kế để đáp ứng mọi nhu cầu tập luyện của bạn.
                    </p>
                </div>
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
                        Giới thiệu các thiết bị
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
<section class="py-5">
    <div class="container">
        <div class="row">
            <div class="row text-center my-sm-5 mt-5">
                <div class="col-lg-6 mx-auto">
                    <h2 class="text-primary text-gradient mb-0">Boost creativity</h2>
                    <h2 class="">With our coded pages</h2>
                    <p class="lead">
                        The easiest way to get started is to use one of our <br/>
                        pre-built example pages.
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8">
                <div class="row mt-4">
                    <div class="col-md-6">
                        <a href="./pages/about-us.html">
                            <div class="card move-on-hover">
                                <img
                                        class="w-100"
                                        src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/section-pages/about-us.jpg"
                                        alt=""
                                />
                            </div>
                            <div class="mt-2 ms-2">
                                <h6 class="mb-0">About Us Page</h6>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6 mt-md-0 mt-5">
                        <a href="./pages/contact-us.html">
                            <div class="card move-on-hover">
                                <img
                                        class="w-100"
                                        src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/section-pages/contact-us.jpg"
                                        alt=""
                                />
                            </div>
                            <div class="mt-2 ms-2">
                                <h6 class="mb-0">Contact Us Page</h6>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6 mt-md-0 mt-6">
                        <a href="./pages/sign-in.html">
                            <div class="card move-on-hover">
                                <img
                                        class="w-100"
                                        src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/section-account/sign-in.jpg"
                                        alt=""
                                />
                            </div>
                            <div class="mt-2 ms-2">
                                <h6 class="mb-0">Sign In Page</h6>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6 mt-md-0 mt-6">
                        <a href="./pages/author.html">
                            <div class="card move-on-hover">
                                <img
                                        class="w-100"
                                        src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/section-pages/author.jpg"
                                        alt=""
                                />
                            </div>
                            <div class="mt-2 ms-2">
                                <h6 class="mb-0">Author Page</h6>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mx-auto mt-md-0 mt-5">
                <div class="position-sticky" style="top: 100px !important">
                    <h4 class="">
                        Presentation Pages for Company, Sign In Page, Author and Contact
                    </h4>
                    <h6 class="text-secondary">
                        These is just a small selection of the multiple possibitilies
                        you have. Focus on the business, not on the design.
                    </h6>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- -------- START Content Presentation Docs ------- -->
<div class="container mt-sm-5">
    <div
            class="page-header min-vh-50 my-sm-3 mb-3 border-radius-xl"
            style="
            background-image: url('https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/assets/img/desktop.jpg');
          "
    >
        <span class="mask bg-gradient-dark"></span>
        <div class="container">
            <div class="row">
                <div class="col-lg-6 ms-lg-5">
                    <h4 class="text-white mb-0">Built by developers</h4>
                    <h1 class="text-white">Complex Documentation</h1>
                    <p class="lead text-white opacity-8">
                        From colors, cards, typography to complex elements, you will
                        find the full documentation. Play with the utility classes and
                        you will create unlimited combinations for our components.
                    </p>
                    <a
                            href="https://www.creative-tim.com/learning-lab/bootstrap/license/soft-ui-design-system"
                            class="text-white icon-move-right"
                    >
                        Read docs
                        <i class="fas fa-arrow-right text-sm ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- -------- END Content Presentation Docs ------- -->
<section class="py-7">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 mx-auto text-center">
                <h2 class="mb-0">Trusted by over</h2>
                <h2 class="text-gradient text-primary mb-3">
                    2,600,000 web developers
                </h2>
                <p class="lead">
                    Many Fortune 500 companies, startups, universities and
                    governmental institutions love Creative Tim's products.
                </p>
            </div>
        </div>

        <hr class="horizontal dark my-5"/>
    </div>
</section>

<!-- START Section Content W/ 2 images aside of icon title description -->
<section class="pt-lg-7 pt-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-5 col-md-8 order-2 order-md-2 order-lg-1">
                <div
                        class="position-relative ms-lg-5 mb-0 mb-md-7 mb-lg-0 d-none d-md-block d-lg-block d-xl-block h-75"
                >
                    <div
                            class="bg-primary w-100 h-100 border-radius-xl position-absolute d-lg-block d-none"
                    ></div>
                    <img
                            src="./assets/img/curved-images/curved11.jpg"
                            class="w-100 border-radius-xl mt-6 ms-lg-5 position-relative z-index-5"
                            alt=""
                    />
                </div>
            </div>
            <div class="col-lg-5 col-md-12 ms-auto order-1 order-md-1 order-lg-1">
                <div class="p-3 pt-0">
                    <div
                            class="icon icon-shape bg-primary rounded-circle shadow text-center mb-4"
                    >
                        <i class="ni ni-building"></i>
                    </div>
                    <h4 class="text-gradient text-primary mb-0">Special Thanks</h4>
                    <h4 class="mb-4">
                        <a
                                href="https://twitter.com/dnyivn"
                                target="blank"
                                rel="nofollow"
                        >3D Images by Danny Ivan</a
                        >
                    </h4>
                    <p>
                        We are more than happy to use the great images made by Danny
                        inside Soft UI Design System. They come with a high level of
                        quality and bright colors, fitting perfect with our product's
                        colors.<br/><br/>
                        Danny is a important designer that is active into the 3D Image
                        space. His war was awarded many times in different categories in
                        Behance, Digital Art or Motion Graphics.
                    </p>
                    <a
                            href="https://www.behance.net/dannyivan"
                            target="blank"
                            rel="nofollow"
                            class="text-dark icon-move-right"
                    >Check Danny's work
                        <i class="fas fa-arrow-right text-sm ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- END Section Content -->
<!-- -------   START PRE-FOOTER 2 - simple social line w/ title & 3 buttons    -------- -->
<div class="pt-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-5 ms-auto">
                <h4 class="mb-1">Thank you for your support!</h4>
                <p class="lead mb-0">We deliver the best web products</p>
            </div>
            <div class="col-lg-5 me-lg-auto my-lg-auto text-lg-end mt-5">
                <a
                        href="https://twitter.com/intent/tweet?text=Check%20Soft%20UI%20Design%20System%20made%20by%20%40CreativeTim%20%23webdesign%20%23designsystem%20%23bootstrap5&url=https%3A%2F%2Fwww.creative-tim.com%2Fproduct%2Fsoft-ui-design-system"
                        class="btn btn-info mb-0 me-2"
                        target="_blank"
                >
                    <i class="fab fa-twitter me-1"></i> Tweet
                </a>
                <a
                        href="https://www.facebook.com/sharer/sharer.php?u=https://www.creative-tim.com/product/soft-ui-design-system"
                        class="btn btn-primary mb-0 me-2"
                        target="_blank"
                >
                    <i class="fab fa-facebook-square me-1"></i> Share
                </a>
                <a
                        href="https://www.pinterest.com/pin/create/button/?url=https://www.creative-tim.com/product/soft-ui-design-system"
                        class="btn btn-dark mb-0 me-2"
                        target="_blank"
                >
                    <i class="fab fa-pinterest me-1"></i> Pin it
                </a>
            </div>
        </div>
    </div>
</div>
<!-- -------   END PRE-FOOTER 2 - simple social line w/ title & 3 buttons    -------- -->
<footer class="footer pt-5 mt-5">
    <hr class="horizontal dark mb-5"/>
    <div class="container">
        <div class="row">
            <div class="col-md-3 mb-4 ms-auto">
                <div>
                    <h6 class="text-gradient text-primary font-weight-bolder">
                        Soft UI Design 3 System
                    </h6>
                </div>
                <div>
                    <h6 class="mt-3 mb-2 opacity-8">Social</h6>
                    <ul class="d-flex flex-row ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://www.facebook.com/CreativeTim/"
                                    target="_blank"
                            >
                                <i class="fab fa-facebook text-lg opacity-8"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://twitter.com/creativetim"
                                    target="_blank"
                            >
                                <i class="fab fa-twitter text-lg opacity-8"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://dribbble.com/creativetim"
                                    target="_blank"
                            >
                                <i class="fab fa-dribbble text-lg opacity-8"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://github.com/creativetimofficial"
                                    target="_blank"
                            >
                                <i class="fab fa-github text-lg opacity-8"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link pe-1"
                                    href="https://www.youtube.com/channel/UCVyTG4sCw-rOvB9oHkzZD1w"
                                    target="_blank"
                            >
                                <i class="fab fa-youtube text-lg opacity-8"></i>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Company</h6>
                    <ul class="flex-column ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/presentation"
                                    target="_blank"
                            >
                                About Us
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/templates/free"
                                    target="_blank"
                            >
                                Freebies
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/templates/premium"
                                    target="_blank"
                            >
                                Premium Tools
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/blog"
                                    target="_blank"
                            >
                                Blog
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Resources</h6>
                    <ul class="flex-column ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://iradesign.io/"
                                    target="_blank"
                            >
                                Illustrations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/bits"
                                    target="_blank"
                            >
                                Bits & Snippets
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/affiliates/new"
                                    target="_blank"
                            >
                                Affiliate Program
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Help & Support</h6>
                    <ul class="flex-column ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/contact-us"
                                    target="_blank"
                            >
                                Contact Us
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/knowledge-center"
                                    target="_blank"
                            >
                                Knowledge Center
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://services.creative-tim.com/?ref=ct-soft-ui-footer"
                                    target="_blank"
                            >
                                Custom Development
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/sponsorships"
                                    target="_blank"
                            >
                                Sponsorships
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-2 col-sm-6 col-6 mb-4 me-auto">
                <div>
                    <h6 class="text-gradient text-primary text-sm">Legal</h6>
                    <ul class="flex-column ms-n3 nav">
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/terms"
                                    target="_blank"
                            >
                                Terms &amp; Conditions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/privacy"
                                    target="_blank"
                            >
                                Privacy Policy
                            </a>
                        </li>
                        <li class="nav-item">
                            <a
                                    class="nav-link"
                                    href="https://www.creative-tim.com/license"
                                    target="_blank"
                            >
                                Licenses (EULA)
                            </a>
                        </li>
                    </ul>
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
</body>
</html>
