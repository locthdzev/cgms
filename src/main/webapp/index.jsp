<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Services.StatsService" %>
<%@ page import="DAOs.PackageDAO" %>
<%@ page import="Models.Package" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
  StatsService statsService = new StatsService();
  int activeMembersCount = statsService.getActiveMembersCount();
  int activeTrainersCount = statsService.getActiveTrainersCount();
  int activePackagesCount = statsService.getActivePackagesCount();
  
  // Lấy danh sách gói tập đang hoạt động cho Guest
  PackageDAO packageDAO = new PackageDAO();
  List<Package> activePackages = packageDAO.getAllActivePackages();
  NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <link
      rel="apple-touch-icon"
      sizes="76x76"
      href="assets/img/weightlifting.png"
    />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Corefit Gym</title>
    <!-- Fonts and icons -->
    <link
      href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
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
              <h1 class="text-white pt-3 mt-n5" style="font-family: 'Poppins', sans-serif; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.3);">COREFIT GYM</h1>
              <p class="lead text-white mt-3" style="font-family: 'Inter', sans-serif; font-weight: 300; letter-spacing: 0.5px; line-height: 1.8;">
                Nâng cao sức khỏe, thay đổi ngoại hình và cải thiện cuộc sống.<br />
                <span style="font-style: italic;">Hãy để chúng tôi đồng hành cùng bạn trên hành trình chinh phục bản thân.</span>
              </p>
              <a href="/register" class="btn btn-lg btn-white mt-3" style="font-weight: 600; border-radius: 8px; padding: 12px 35px; box-shadow: 0 4px 15px rgba(255, 255, 255, 0.2); transition: all 0.3s ease;">Bắt đầu ngay</a>
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
                    Hơn <%= activeMembersCount %> thành viên đang tập luyện và đạt được mục tiêu sức khỏe cùng chúng tôi.
                  </p>
                </div>
                <hr class="vertical dark" />
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
                <hr class="vertical dark" />
              </div>
              <div class="col-md-4">
                <div class="p-3 text-center">
                  <h1 class="text-gradient text-dark" id="state3" countTo="<%= activePackagesCount %>">
                    0
                  </h1>
                  <h5 class="mt-3">Gói tập đa dạng</h5>
                  <p class="text-sm">
                    Từ tập luyện cá nhân đến các lớp nhóm sôi động, chúng tôi có đầy đủ các gói phù hợp với nhu cầu của bạn.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
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
            <div class="card shadow-lg h-100 package-card" style="transition: all 0.3s ease; border: none; border-radius: 20px; overflow: hidden; position: relative;">
              <% if ("Premium".equals(pkg.getName()) || pkg.getName().toLowerCase().contains("premium") || pkg.getName().toLowerCase().contains("vip")) { %>
                <div class="position-absolute" style="top: 15px; right: 15px; z-index: 10;">
                  <span class="badge text-dark" style="background: linear-gradient(135deg, #FFD700, #FFA500); padding: 8px 16px; border-radius: 25px; font-weight: 600; font-size: 0.75rem; box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);">
                    <i class="fas fa-crown me-1"></i>Premium
                  </span>
                </div>
              <% } %>
              
              <div class="card-header text-center position-relative" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 2.5rem 2rem; border: none;">
                <h3 class="text-white mb-3 font-weight-bold" style="letter-spacing: 1px;"><%= pkg.getName() %></h3>
                <div class="price-section">
                  <h1 class="text-white font-weight-bolder mb-0" style="font-size: 2.5rem; text-shadow: 0 2px 10px rgba(0,0,0,0.3);">
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
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-clock text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">Thời hạn sử dụng</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;"><%= pkg.getDuration() %> ngày</p>
                      </div>
                    </div>
                    
                    <% if (pkg.getSessions() != null && pkg.getSessions() > 0) { %>
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-dumbbell text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">Số buổi tập</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;"><%= pkg.getSessions() %> buổi</p>
                      </div>
                    </div>
                    <% } %>
                    
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-tools text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">Thiết bị tập luyện</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Sử dụng đầy đủ thiết bị hiện đại</p>
                      </div>
                    </div>
                    
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: rgba(102, 126, 234, 0.1); border-radius: 12px; border-left: 4px solid #667eea;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-user-tie text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">Hỗ trợ chuyên nghiệp</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Tư vấn chương trình tập phù hợp</p>
                      </div>
                    </div>
                    
                    <% if ("Premium".equals(pkg.getName()) || pkg.getName().toLowerCase().contains("premium") || pkg.getName().toLowerCase().contains("vip")) { %>
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.1)); border-radius: 12px; border-left: 4px solid #FFD700;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #FFD700, #FFA500); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-user-graduate text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">PT cá nhân</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Huấn luyện viên riêng 1-1</p>
                      </div>
                    </div>
                    
                    <div class="feature-item mb-3" style="display: flex; align-items: center; padding: 12px; background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.1)); border-radius: 12px; border-left: 4px solid #FFD700;">
                      <div class="feature-icon me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #FFD700, #FFA500); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-apple-alt text-white" style="font-size: 0.9rem;"></i>
                      </div>
                      <div>
                        <span class="font-weight-bold text-dark">Chế độ dinh dưỡng</span>
                        <p class="mb-0 text-secondary" style="font-size: 0.9rem;">Kế hoạch dinh dưỡng cá nhân</p>
                      </div>
                    </div>
                    <% } %>
                  </div>
                  
                  <% if (pkg.getDescription() != null && !pkg.getDescription().trim().isEmpty()) { %>
                  <div class="mt-4 p-3" style="background: rgba(0,0,0,0.05); border-radius: 12px; border-left: 4px solid #667eea;">
                    <h6 class="text-dark mb-2" style="font-weight: 600;">
                      <i class="fas fa-info-circle me-2 text-primary"></i>Mô tả gói tập
                    </h6>
                    <p class="text-secondary mb-0" style="font-size: 0.9rem; line-height: 1.6;"><%= pkg.getDescription() %></p>
                  </div>
                  <% } %>
                </div>
                
                <div class="mt-4">
                  <a href="/register" class="btn btn-lg w-100" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); border: none; border-radius: 15px; padding: 15px; font-weight: 700; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4); transition: all 0.3s ease; color: white !important;">
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
            <div class="alert text-center" style="background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1)); border: none; border-radius: 20px; padding: 3rem;">
              <div class="mb-3">
                <i class="fas fa-exclamation-circle" style="font-size: 3rem; color: #667eea;"></i>
              </div>
              <h4 class="text-dark mb-3">Hiện tại chưa có gói tập nào!</h4>
              <p class="text-secondary mb-0" style="font-size: 1.1rem;">Chúng tôi đang cập nhật các gói tập mới. Vui lòng quay lại sau hoặc liên hệ để được tư vấn.</p>
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
      
      #packages-section .package-card:nth-child(1) { animation-delay: 0.1s; }
      #packages-section .package-card:nth-child(2) { animation-delay: 0.2s; }
      #packages-section .package-card:nth-child(3) { animation-delay: 0.3s; }
      
      /* Gradient text effect */
      #packages-section .text-gradient {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
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
                    Phòng tập được trang bị các thiết bị tập luyện tiên tiến nhất, đảm bảo hiệu quả và an toàn cho mọi thành viên.
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
                    Phòng tập được thiết kế rộng rãi, thoáng mát với nhiều khu vực chức năng riêng biệt cho từng loại bài tập.
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
                    Phòng tập mở cửa từ sáng sớm đến tối muộn, giúp bạn dễ dàng sắp xếp thời gian tập luyện phù hợp với lịch trình bận rộn.
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
                    Từ tập luyện cá nhân, lớp học nhóm đến yoga, pilates và các dịch vụ chăm sóc sức khỏe khác đều có sẵn tại CoreFit Gym.
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
                  Trải nghiệm <br />
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
              <h2 class="text-dark mb-0">Các dịch vụ tại CoreFit Gym</h2>
              <h2 class="text-primary text-gradient">Đa dạng và chuyên nghiệp</h2>
              <p class="lead">
                Chúng tôi cung cấp nhiều dịch vụ khác nhau để đáp ứng nhu cầu tập luyện của mọi đối tượng, từ người mới bắt đầu đến người tập chuyên nghiệp.
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
              <h3>Dịch vụ nổi bật</h3>
              <h6 class="text-secondary font-weight-normal pe-3">
                Khám phá các dịch vụ đa dạng tại CoreFit Gym phù hợp với mọi nhu cầu và mục tiêu của bạn
              </h6>
            </div>
          </div>
          <div class="col-lg-9">
            <div class="row">
              <div class="col-md-4 mt-md-0">
                <a href="./sections/page-sections/hero-sections.html">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <img
                      class="w-100 my-auto"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/page-headers/header-7.jpg"
                      alt=""
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Page Headers</h6>
                    <p class="text-secondary text-sm">10 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="./sections/page-sections/features.html">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <img
                      class="w-100 my-auto"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/features/features-3.jpg"
                      alt=""
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Features</h6>
                    <p class="text-secondary text-sm">14 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/pricing/pricing-3.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="pricing"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Pricing</h6>
                    <p class="text-secondary text-sm">8 Examples</p>
                  </div>
                </a>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-md-4 mt-md-0 mt-3">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/faq/faq-1.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="faq"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">FAQ</h6>
                    <p class="text-secondary text-sm">1 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/blog-posts/blog-7.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="blog posts"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Blog Posts</h6>
                    <p class="text-secondary text-sm">11 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/testimonials/testimonials-2.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="testimonials"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Testimonials</h6>
                    <p class="text-secondary text-sm">11 Examples</p>
                  </div>
                </a>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-md-4 mt-md-0 mt-3">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/teams/team-6.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="teams"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Teams</h6>
                    <p class="text-secondary text-sm">6 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/stats/stats-2.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="stats"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Stats</h6>
                    <p class="text-secondary text-sm">3 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/call-to-actions/prefooter-1.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="CTA"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Call to Actions</h6>
                    <p class="text-secondary text-sm">8 Examples</p>
                  </div>
                </a>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-md-4 mt-md-0 mt-3">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/applications/project-6.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="applications"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Applications</h6>
                    <p class="text-secondary text-sm">6 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/logo-areas/logos-3.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="logo areas"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Logo Areas</h6>
                    <p class="text-secondary text-sm">4 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/footers/footer-9.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="footers"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Footers</h6>
                    <p class="text-secondary text-sm">10 Examples</p>
                  </div>
                </a>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-md-4 mt-md-0 mt-3">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/general-cards/card-4.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="general cards"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">General Cards</h6>
                    <p class="text-secondary text-sm">9 Examples</p>
                  </div>
                </a>
              </div>
              <div class="col-md-4 mt-md-0 mt-4">
                <a href="javascript:;">
                  <div
                    class="card shadow-lg move-on-hover min-height-160 min-height-160"
                  >
                    <div class="position-absolute top-0 end-0 p-2 z-index-1">
                      <svg
                        width="24px"
                        height="24px"
                        viewBox="0 0 24 24"
                        version="1.1"
                        xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                      >
                        <g
                          stroke="none"
                          stroke-width="1"
                          fill="none"
                          fill-rule="evenodd"
                        >
                          <circle
                            fill="#1F2937"
                            cx="12"
                            cy="12"
                            r="12"
                          ></circle>
                          <g
                            transform="translate(7.000000, 5.000000)"
                            fill="#FFFFFF"
                            fill-rule="nonzero"
                          >
                            <path
                              d="M5,0 C3.16666667,0 1.66666667,1.5 1.66666667,3.33333333 L1.66666667,4.58333333 C0.666666667,5.5 0,6.83333333 0,8.33333333 C0,11.0833333 2.25,13.3333333 5,13.3333333 C7.75,13.3333333 10,11.0833333 10,8.33333333 C10,6.83333333 9.33333333,5.5 8.33333333,4.58333333 L8.33333333,3.33333333 C8.33333333,1.5 6.83333333,0 5,0 Z M5.83333333,8.91666667 L5.83333333,10.8333333 L4.16666667,10.8333333 L4.16666667,8.91666667 C3.66666667,8.66666667 3.33333333,8.08333333 3.33333333,7.5 C3.33333333,6.58333333 4.08333333,5.83333333 5,5.83333333 C5.91666667,5.83333333 6.66666667,6.58333333 6.66666667,7.5 C6.66666667,8.08333333 6.33333333,8.66666667 5.83333333,8.91666667 Z M6.66666667,3.66666667 C6.16666667,3.41666667 5.58333333,3.33333333 5,3.33333333 C4.41666667,3.33333333 3.83333333,3.41666667 3.33333333,3.66666667 L3.33333333,3.33333333 C3.33333333,2.41666667 4.08333333,1.66666667 5,1.66666667 C5.91666667,1.66666667 6.66666667,2.41666667 6.66666667,3.33333333 L6.66666667,3.66666667 Z"
                            ></path>
                          </g>
                        </g>
                      </svg>
                    </div>
                    <img
                      class="w-100 my-auto opacity-6"
                      src="https://raw.githubusercontent.com/creativetimofficial/public-assets/master/soft-ui-design-system/presentation/sections/page-sections/content-sections/content-6.jpg"
                      data-bs-toggle="tooltip"
                      data-bs-placement="top"
                      title="Pro Element"
                      alt="content sections"
                    />
                  </div>
                  <div class="mt-2 ms-2">
                    <h6 class="mb-0">Content Sections</h6>
                    <p class="text-secondary text-sm">8 Examples</p>
                  </div>
                </a>
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
                The easiest way to get started is to use one of our <br />
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

        <hr class="horizontal dark my-5" />
      </div>
    </section>
    <!-- <section class="py-sm-7" id="download-soft-ui">
      <div
        class="bg-gradient-dark position-relative m-3 border-radius-xl overflow-hidden"
      >
        <img
          src="./assets/img/shapes/waves-white.svg"
          alt="pattern-lines"
          class="position-absolute start-0 top-md-0 w-100 opacity-6"
        />
        <div
          class="container py-7 postion-relative z-index-2 position-relative"
        >
          <div class="row">
            <div class="col-md-7 mx-auto text-center">
              <h3 class="text-white mb-0">Do you love this awesome</h3>
              <h3 class="text-primary text-gradient mb-4">
                Design System for Bootstrap 5?
              </h3>
              <p class="text-white mb-5">
                Cause if you do, it can be yours for FREE. Hit the button below
                to navigate to Creative Tim where you can find the Design System
                in HTML. Start a new project or give an old Bootstrap project a
                new look!
              </p>
              <a
                href="https://www.creative-tim.com/product/soft-ui-design-system"
                class="btn btn-primary btn-lg mb-3 mb-sm-0"
                >Download HTML</a
              >
            </div>
          </div>
        </div>
      </div>
    </section> -->
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
                colors.<br /><br />
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
      <hr class="horizontal dark mb-5" />
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
  </body>
</html>
