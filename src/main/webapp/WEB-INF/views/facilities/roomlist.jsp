<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>

  <style>
    .facility-card{ border-radius:14px; overflow:hidden; }
    .facility-card:hover{ box-shadow:0 .6rem 1.4rem rgba(0,0,0,.08); transform:translateY(-1px); transition:all .15s ease; }

    /* 사진 높이 (두 번째 샘플 느낌) */
    .facility-img{ width:100%; height:260px; object-fit:cover; cursor:pointer; }

    .facility-title{ font-weight:700; font-size:1.05rem; }

    /* 카드 본문: 세로 가운데 정렬 */
    .facility-card .card-body{
      padding: 1.2rem 1.25rem;
      min-height: 140px;             /* 필요시 120~160px 조절 */
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .info-block{ margin-top:.25rem; }

    /* 라벨+내용(수용인원/비품) – 폰트 통일 */
    .info-line{
      display:flex; flex-wrap:wrap; align-items:center;
      gap:12px; line-height:1.4;
      font-size:.9rem; font-weight:400;
      color:var(--bs-secondary-color);
      font-family:var(--bs-body-font-family);
    }
    .info-line .label{ margin-right:6px; }
    .equip-item{ display:inline-flex; align-items:center; gap:6px; }
    .equip-item i{ font-size:1em; line-height:1; opacity:.9; }
  </style>
</head>
  <%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 
      
<div class="body-wrapper">
  <div class="container">
    <!-- 배너 -->
    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-9">
            <h4 class="fw-semibold mb-8">회의실</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="/project/dashboard">Home</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Facilities</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- 카드 그리드 (한 줄 2개) -->
    <div class="row g-3 g-lg-4">
      <!-- Card 1 -->
      <div class="col-12 col-lg-6">
        <div class="card facility-card h-100">
          <img class="facility-img"
               src="${pageContext.request.contextPath}/resources/assets/images/meetingroom/회의실1.jpg"
               alt="회의실 1"
               data-room="1"
               data-img="${pageContext.request.contextPath}/resources/assets/images/meetingroom/회의실1.jpg">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-start mb-1">
              <div class="facility-title">회의실1</div>
            </div>

            <div class="info-block">
              <div class="info-line">
                <span class="label">수용인원 :</span>
                <span class="equip-item"><i class="ti ti-users"></i><span>10명</span></span>
              </div>

              <div class="info-line">
                <span class="label">비품 :</span>
                <span class="equip-item"><i class="ti ti-armchair-2"></i><span>의자</span></span>
                <span class="equip-item"><i class="ti ti-table"></i><span>책상</span></span>
                <span class="equip-item"><i class="ti ti-device-projector"></i><span>프로젝터</span></span>
                <span class="equip-item"><i class="ti ti-presentation"></i><span>화이트보드</span></span>
                <span class="equip-item"><i class="ti ti-device-tv"></i><span>스크린</span></span>
                <span class="equip-item"><i class="ti ti-fire-extinguisher"></i><span>소화기</span></span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Card 2 -->
      <div class="col-12 col-lg-6">
        <div class="card facility-card h-100">
          <img class="facility-img"
               src="${pageContext.request.contextPath}/resources/assets/images/meetingroom/회의실2.jpg"
               alt="회의실 2"
               data-room="2"
               data-img="${pageContext.request.contextPath}/resources/assets/images/meetingroom/회의실2.jpg">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-start mb-1">
              <div class="facility-title">회의실2</div>
            </div>

            <div class="info-block">
              <div class="info-line">
                <span class="label">수용인원 :</span>
                <span class="equip-item"><i class="ti ti-users"></i><span>8명</span></span>
              </div>

              <div class="info-line">
                <span class="label">비품 :</span>
                <span class="equip-item"><i class="ti ti-armchair-2"></i><span>의자</span></span>
                <span class="equip-item"><i class="ti ti-table"></i><span>책상</span></span>
                <span class="equip-item"><i class="ti ti-presentation"></i><span>화이트보드</span></span>
                <span class="equip-item"><i class="ti ti-fire-extinguisher"></i><span>소화기</span></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- /카드 그리드 -->

  </div>
</div>

        </div>
      </div>

<%@ include file="/module/footerPart.jsp" %>

<!-- 이미지 클릭 시 예약 페이지로 이동 + 같은 사진 전달 -->
<script>
(function(){
  const ctx = '${pageContext.request.contextPath}';
  document.querySelectorAll('.facility-img[data-room]').forEach(function(img){
    img.addEventListener('click', function(){
      const room = img.dataset.room;
      const src  = img.dataset.img || img.getAttribute('src');
      const url  = ctx + '/meeting/reserve?room=' + encodeURIComponent(room)
                 + '&img=' + encodeURIComponent(src);
      window.location.href = url;
    });
  });
})();
</script>
</body>
</html>
