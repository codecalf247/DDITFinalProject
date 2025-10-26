<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ include file="/module/headPart.jsp" %>
<%@ include file="/module/aside.jsp" %>

<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare | 프로젝트 사진</title>
  <style>
   
    
  .card-grid { row-gap: 1.5rem; }
  .photo-card.ring { box-shadow: 0 0 0 3px rgba(13,110,253,.35) !important; transition: box-shadow .25s; }
  .img-450x300 { width: 100%; height: 300px; object-fit: cover; }
  .badge-wrap { gap: .4rem; flex-wrap: wrap; }
  /* 💡 호버 효과 추가 */
  .photo-card:hover {
    cursor: pointer;
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
  }
  </style>
</head>


<%@ include file="/module/header.jsp" %>

<body>
<div class="body-wrapper">
  <div class="container-fluid">
   <div class="body-wrapper">
        <div class="container">
        

    <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
      <div class="card-body px-4 py-3">
        <div class="row align-items-center">
          <div class="col-12">
            <h4 class="fw-semibold mb-8">프로젝트 &gt; 사진 목록</h4>
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/dashboard">Home</a>
                </li>
                <li class="breadcrumb-item">
                  <a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/project/dashboard?prjctNo=${project.prjctNo}">Project</a>
                </li>
                <li class="breadcrumb-item" aria-current="page">Photos</li>
              </ol>
            </nav>
          </div>
        </div>
      </div>
    </div>

	<%@ include file="/WEB-INF/views/project/carousels.jsp" %>




    <div class="d-flex justify-content-end mb-3">
	    <a href="${pageContext.request.contextPath}/project/photos/insert?prjctNo=${project.prjctNo}" class="btn btn-primary">
	      <i class="ti ti-plus me-1"></i> 사진 등록
	    </a>
	</div>

    <div class="row card-grid">
      <c:forEach var="p" items="${photoList}">
        <div class="col-12 col-sm-6 col-lg-4 col-xxl-3">
          <div class="card shadow-sm photo-card" data-id="${p.sptPhotoNo}">
            <img class="card-img-top img-responsive img-450x300"
                  src="${empty p.thumbnailPath ? pageContext.request.contextPath.concat('/resources/assets/images/photos/placeholder.jpg') : p.thumbnailPath}"
                 alt="${fn:escapeXml(p.sptPhotoTitle)}" />

            <div class="card-body">
              <div class="d-flex justify-content-between align-items-center">
              <h5 class="card-title text-truncate mb-0" title="${fn:escapeXml(p.sptPhotoTitle)}">${p.sptPhotoTitle}</h5>

              <div class="d-flex badge-wrap ms-2">
                <c:forEach var="cat" items="${p.categories}">
                  <c:choose>
                    <c:when test="${cat eq '철거'}">
                      <span class="mb-1 badge bg-primary-subtle text-primary">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '설비'}">
                      <span class="mb-1 badge bg-secondary-subtle text-secondary">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '전기'}">
                      <span class="mb-1 badge bg-success-subtle text-success">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '목공'}">
                      <span class="mb-1 badge bg-danger-subtle text-danger">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '타일'}">
                      <span class="mb-1 badge bg-warning-subtle text-warning">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '도배'}">
                      <span class="mb-1 badge bg-info-subtle text-info">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '도장'}">
                      <span class="mb-1 badge bg-primary-subtle text-primary">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '가구'}">
                      <span class="mb-1 badge bg-secondary-subtle text-secondary">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '마감'}">
                      <span class="mb-1 badge bg-success-subtle text-success">${cat}</span>
                    </c:when>
                    <c:when test="${cat eq '기타'}">
                      <span class="mb-1 badge bg-danger-subtle text-danger">${cat}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="mb-1 badge bg-light text-dark">${cat}</span>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </div>
              </div>

              <div class="d-flex justify-content-between align-items-center mt-3">
                <a href="${pageContext.request.contextPath}/project/photos/detail/${p.sptPhotoNo}?prjctNo=${project.prjctNo}"
				   class="btn btn-rounded bg-primary-subtle text-primary">
				   사진 더보기
				</a>
				                
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty photoList}">
        <div class="col-12">
          <div class="alert alert-info mb-0">등록된 사진이 없습니다. <strong>사진 등록</strong> 버튼을 눌러 추가해 주세요.</div>
        </div>
      </c:if>
    </div>

  </div> 
  </div> 
  </div> 
  </div> 
  
   <div class="d-flex justify-content-center mt-4">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center mb-0"> 
                ${pagingVO.pagingHTML2ForProject}
            </ul>
        </nav>
    </div>

<form id="pageForm"
        action="${pageContext.request.contextPath}/project/photos/list"
        method="get">
        
        <input type="hidden" name="page" id="page"> 
        <input type="hidden" name="searchWord" value="${searchWord}">
        
        <input type="hidden" name="prjctNo" value="${prjctNo}"> 
    </form>
  
  <%@ include file="/module/footerPart.jsp" %>

<script>


//fn_pagination 함수가 호출될 때, 위에서 수정한 #pageForm이 제출됩니다.

$(function() {
    // 등록 완료 후 돌아왔을 때 새 카드 하이라이트
    var newId = '${param.newId}';
    if (newId) {
      var $card = $('.photo-card[data-id="' + newId + '"]');
      if ($card.length) {
        $card.addClass('ring');
        $('html, body').animate({ scrollTop: $card.offset().top - 120 }, 400);
        setTimeout(function(){ $card.removeClass('ring'); }, 2000);
      }
    }

    // 💡 카드 클릭 시 상세 페이지로 이동 (버튼 제외)
    $('.card-grid').on('click', '.photo-card', function(e) {
      // a 태그나 button 태그를 클릭한 경우에는 이 이벤트를 무시
      if ($(e.target).closest('a,button').length) {
        return;
      }
      var id = $(this).data('id');
      if (id) {
    	  window.location.href = '${pageContext.request.contextPath}/project/photos/detail/' + id + '?prjctNo=' + '${project.prjctNo}';
      }
    });
  });
</script>
</body>
</html>