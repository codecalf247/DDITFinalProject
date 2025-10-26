<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  // 필요 시 서버에서 SKY/PTY/T1H 세팅
%>
<c:choose>
  <c:when test="${SKY eq '1'}">
    <%-- <c:set var="weather" value="${pageContext.request.contextPath }/resources/assets/weather/morning.gif"/> --%>
    <c:set var="weatherIcon" value="☀️"/>
    <c:set var="todayweather" value="맑음"/>
  </c:when>
  <c:when test="${SKY eq '3'}">
    <%-- <c:set var="weather" value="${pageContext.request.contextPath }/resources/assets/weather/morning.gif"/> --%>
    <c:set var="weatherIcon" value="☁️"/>
    <c:set var="todayweather" value="구름많음"/>
  </c:when>
  <c:when test="${SKY eq '4' and (PTY eq '1' or PTY eq '2')}">
    <%-- <c:set var="weather" value="${pageContext.request.contextPath }/resources/assets/weather/rainy.gif"/> --%>
    <c:set var="weatherIcon" value="🌧️"/>
    <c:set var="todayweather" value="흐림"/>
  </c:when>
  <c:otherwise>
    <c:set var="weather" value="https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"/>
    <c:set var="todayweather" value=""/>
  </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

  <!-- Favicon -->
  <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png"/>

  <!-- Modernize Core CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/styles.css"/>

  <!-- SweetAlert2 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css"/>

  <title>출근 체크</title>

  <style>
    /* 전체 배경 */
    #bg-wrap{
      background: url('${pageContext.request.contextPath }/resources/assets/weather/interior1.jpg') no-repeat center center fixed;
      background-size: cover;
      min-height: 100vh;
    }

    /* ===== 왼쪽 히어로 영역 기준 좌표계 ===== */
    .left-hero{
      position: relative;
      min-height: 100vh;
    }

    /* 날씨 배지: 히어로 좌상단 */
    .weather-info{
      position: absolute;
      top: 20px; left: 20px;   /* ← 왼쪽 상단으로 이동 */
      background: rgba(255,255,255,.9);
      padding: 14px 18px; border-radius: 14px;
      backdrop-filter: blur(10px);
      box-shadow: 0 5px 20px rgba(0,0,0,.12);
      z-index: 19;
    }
    .weather-temp{font-weight:700; font-size:18px; color:#111}
    .weather-desc{font-size:14px; color:#444}

    /* 로그인 카드 상단 시계 */
    .time{ font-size:2rem; font-weight:800; }

    /* 로그인 카드 상단 로고(Welcome 위) */
    .auth-brand{ display:flex; align-items:center; gap:10px; margin-bottom:14px; }
    .auth-logo{ height:40px; width:auto; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,.08); }
    @media (max-width:1199.98px){
      .weather-info{ position: fixed; top: 16px; left: 16px; z-index: 29; }
      .auth-logo{ height:34px; }
    }
    /* 모달 열릴 때 레이아웃 흔들림 방지 */
/* 1) 왼쪽 여백 없애고 오른쪽만 안정화 */
:root { scrollbar-gutter: stable; }   /* both-edges → stable */

/* 2) 아예 예약 끄기 */
:root { scrollbar-gutter: auto; }     /* 또는 이 줄 삭제 */
html  { overflow-y: auto; }                     /* ← scroll 이었음 */

/* Bootstrap/SweetAlert2가 넣는 padding-right 보정 끄기 */
body.modal-open { padding-right: 0 !important; }
html.swal2-shown, body.swal2-shown { padding-right: 0 !important; }
  </style>
</head>

<body>
  <!-- Preloader -->
  <div class="preloader">
    <img src="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png" alt="loader" class="lds-ripple img-fluid"/>
  </div>

  <div id="main-wrapper" class="auth-customizer-none">
    <div id="bg-wrap" class="position-relative w-100">
      <div class="position-relative z-index-5">
        <div class="row g-0">
          <!-- 좌측: 배경 영역 -->
          <div class="col-xl-7 col-xxl-8 p-0">
            <div class="left-hero d-none d-xl-block">
              <!-- 가운데 데코가 필요하면 여기에 -->
              <div class="d-flex align-items-center justify-content-center h-100"></div>
              <!-- 날씨 (좌상단) -->
              <div class="weather-info">
                <div class="weather-temp"><span class="weather-icon">☀️</span> <span>21°</span></div>
                <div class="weather-desc">맑음 · 대전</div>
              </div>
            </div>
          </div>

          <!-- 우측: 로그인 폼 -->
          <div class="col-xl-5 col-xxl-4">
            <div class="authentication-login min-vh-100 bg-body d-flex justify-content-center align-items-center p-4">
              <div class="auth-max-width col-sm-8 col-md-6 col-xl-7 px-4">
                <!-- 로고: Welcome 위, 둥근 모서리 -->
                <div class="auth-brand">
                  <img src="${pageContext.request.contextPath }/resources/assets/images/logos/logo.png" alt="Brand" class="auth-logo">
                </div>

                <h2 class="mb-1 fs-7 fw-bolder">Welcome</h2>
                <p class="mb-2"><span id="clock" class="time">--:--</span></p>
                <p id="welcomeMsg" class="mb-7">유쾌한 업무의 시작! 출근 체크를 해주세요!</p>

                <form id="frm" method="post" action="${pageContext.request.contextPath }/login">
                  <div class="mb-3">
                    <label for="empNo" class="form-label">사원번호</label>
                    <input type="text" class="form-control" name="username" id="empNo" placeholder="사원번호">
                  </div>
                  <div class="mb-4">
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" name="password" id="password" value="1234" placeholder="비밀번호">
                  </div>

                  <div class="d-flex align-items-center justify-content-between mb-4">
                    <a href="#" class="text-primary fw-medium fs-3" data-bs-toggle="modal" data-bs-target="#findEmpNoModal">사원번호 찾기</a>
                    <a href="#" class="text-primary fw-medium fs-3" data-bs-toggle="modal" data-bs-target="#changeEmpPasswordModal">비밀번호 찾기</a>
                  </div>

                  <button type="submit" class="btn btn-primary w-100 py-8 mb-4 rounded-2">출근하기</button>
                </form>
              </div>
            </div>
          </div>
          <!-- // 우측 -->
        </div>
      </div>
    </div>

    <!-- ===== 모달 : 사번 찾기 ===== -->
    <div class="modal fade" id="findEmpNoModal" tabindex="-1" aria-labelledby="findEmpNoModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content text-dark">
          <div class="modal-header">
            <h5 class="modal-title" id="findEmpNoModalLabel">사원번호 찾기</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <div class="form-floating mb-3">
              <input type="text" class="form-control" id="empNm" placeholder="이름">
              <label for="empNm">이름</label>
            </div>
            <div class="form-floating mb-3">
              <input type="text" class="form-control" id="brdt" placeholder="생년월일">
              <label for="brdt">생년월일</label>
            </div>
            <button id="findId" type="button" class="btn btn-primary w-100">사번 찾기</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== 모달 : 비밀번호 발송 ===== -->
    <div class="modal fade" id="changeEmpPasswordModal" tabindex="-1" aria-labelledby="changeEmpPasswordModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content text-dark">
          <div class="modal-header">
            <h5 class="modal-title" id="changeEmpPasswordModalLabel">비밀번호 발송</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <div class="form-floating mb-3">
              <input type="text" class="form-control" id="findEmpNo" placeholder="사번">
              <label for="findEmpNo">사번</label>
            </div>
            <div class="form-floating mb-3">
              <input type="text" class="form-control" id="findEmail" placeholder="이메일">
              <label for="findEmail">이메일</label>
            </div>
            <button id="changePW" type="button" class="btn btn-primary w-100">비밀번호 찾기</button>
          </div>
        </div>
      </div>
    </div>
    <!-- // 모달들 -->
  </div>
  <div class="dark-transparent sidebartoggler"></div>

  <!-- ===== Scripts ===== -->
  <script src="${pageContext.request.contextPath }/resources/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/libs/simplebar/dist/simplebar.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/app.minisidebar.init.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/theme.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/js/theme/app.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
  <script src="${pageContext.request.contextPath }/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>

  <script>
    function handleColorTheme(e){ document.documentElement.setAttribute("data-color-theme", e); }

    const frm = document.querySelector("#frm");
    const empNo = document.querySelector("#empNo");
    const password = document.querySelector("#password");

    function updateClock(){
      const now = new Date();
      let h = now.getHours(), m = String(now.getMinutes()).padStart(2,'0');
      const ampm = h >= 12 ? '오후' : '오전';
      h = h % 12; h = h ? h : 12;
      document.getElementById('clock').innerText = ampm + " " + h + ":" + m;
    }

    window.onload = function(){
      const logincheck = '${msg}';
      if(logincheck){
        Swal.fire({ title: logincheck, icon: 'warning', confirmButtonColor: '#3085d6' });
      }

      updateClock();
      setInterval(updateClock, 1000);

      const now = new Date();
      const message = document.getElementById("welcomeMsg");
      if(now.getHours() < 12)      message.innerText = "유쾌한 업무의 시작! 출근 체크를 해주세요!";
      else if(now.getHours() < 17) message.innerText = "즐거운 오후 근무!";
      else                         message.innerText = "오늘도 수고 많으셨습니다!";

      // 필요 시 시간대 배경 전환
      // if(now.getHours() >= 13){
      //   var bg = document.getElementById('bg-wrap');
      //   bg.style.background = "url('${pageContext.request.contextPath }/resources/assets/weather/interior1.jpg') no-repeat center center fixed";
      //   bg.style.backgroundSize = "cover";
      // }

      frm.addEventListener("submit", function(e){
        if(!empNo.value){ e.preventDefault(); empNo.focus(); alert("회원번호를 입력해 주세요."); return false; }
        if(!password.value){ e.preventDefault(); password.focus(); alert("비밀번호를 입력해 주세요."); return false; }
      });

      document.getElementById("findId").addEventListener("click", function(){
        const empNm = document.getElementById("empNm").value;
        const brdt  = document.getElementById("brdt").value;
        if(!empNm){ alert("이름을 입력 해주세요."); return; }
        if(!brdt){ alert("생년월일을 입력 해주세요."); return; }

        fetch("${pageContext.request.contextPath }/api/findId", {
          method:"POST", headers:{ "Content-Type":"application/json" },
          body: JSON.stringify({ empNm:empNm, brdt:brdt })
        })
        .then(r=>{ if(!r.ok) throw new Error("서버 요청 실패"); return r.json(); })
        .then(function(data){
          if(!data){
            Swal.fire({ title:'아이디 찾기 결과 없습니다.', icon:'warning', target:'#findEmpNoModal', scrollbarPadding:false, heightAuto:false });
          }else{
            Swal.fire({ title:'아이디는 '+ data +' 입니다.', icon:'success', target:'#findEmpNoModal', scrollbarPadding:false, heightAuto:false });
          }
        })
        .catch(()=> alert("아이디 찾기 실패"));
      });

      document.getElementById("changePW").addEventListener("click", function(){
        const findEmpNo = document.getElementById("findEmpNo").value;
        const findEmail = document.getElementById("findEmail").value;
        if(!findEmpNo){ alert("사번을 입력해주세요."); return; }
        if(!findEmail){ alert("이메일을 입력해주세요."); return; }

        fetch("${pageContext.request.contextPath }/api/changePw", {
          method:"POST", headers:{ "Content-Type":"application/json" },
          body: JSON.stringify({ empNo:findEmpNo, email:findEmail })
        })
        .then(r=>{ if(!r.ok) throw new Error("서버 요청 실패"); return r.json(); })
        .then(function(data){
          if((typeof data === 'string' ? data.trim() : data) === "OK"){
            Swal.fire({ title:'비밀번호를 메일로 발송했습니다.', icon:'success', target:'#changeEmpPasswordModal', scrollbarPadding:false, heightAuto:false });
          }else{
            Swal.fire({ title:'조회결과 해당하신 정보는 없습니다.', icon:'warning', target:'#changeEmpPasswordModal', scrollbarPadding:false, heightAuto:false });
          }
        });
      });
    };
  </script>
</body>
</html>
