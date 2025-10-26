<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare - 현장 자료</title>
  <%@ include file="/module/headPart.jsp" %>

  <style>
   <style>
  /* ===== 페이지 전용 스타일 (업데이트) ===== */
  .page-title { line-height: 1.2; }
  
  .info-grid .label::before {
  content: none;   /* 점 없애기 */
}

  /* info 카드 강화 */
  .info-card .card-body { padding: 1.25rem 1.25rem 1rem; }
  .info-grid .info-row {
    display:flex; align-items:flex-start; gap:1rem;
    padding:.6rem 0 .7rem; border-bottom:1px dashed var(--bs-border-color);
  }
  .info-grid .info-row:last-child { border-bottom:0; padding-bottom:0; }
  .info-grid .label {
    width:120px; min-width:120px; font-weight:600; color:var(--bs-secondary-color);
  }
  .info-grid .value {
    color:var(--bs-body-color); word-break:keep-all; font-size:1.05rem;
  }
  .info-grid .value .muted { color:var(--bs-secondary-color); }

  /* 팀 카드 스타일 */
  .team-card .card-body { padding: 1.1rem; }
  .team-split { display:block; }
  .team-half + .team-half { border-top:1px solid var(--bs-border-color); padding-top:.9rem; margin-top:.9rem; }

  /* 멤버 그리드: 기본 2열, 좁은 화면에서 1열 */
  .members-grid {
    display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.75rem;
  }
  @media (max-width: 575.98px) {
    .members-grid { grid-template-columns:1fr; }
  }

  /* 멤버 타일 */
  .member-tile {
    display:flex; align-items:center; gap:.75rem;
    background: var(--bs-tertiary-bg);
    border:1px solid var(--bs-border-color);
    border-radius: .85rem; padding:.6rem .75rem;
    transition: transform .15s ease, box-shadow .15s ease, background .15s ease;
  }
  .member-tile:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 18px rgba(0,0,0,.06);
    background: var(--bs-body-bg);
  }

  /* 아바타 사이즈 업 */
  .team-card .avatar {
    width:56px; height:56px; border-radius:50%; object-fit:cover;
    background: var(--bs-tertiary-bg);
    box-shadow: 0 1px 0 rgba(0,0,0,.04);
  }
  .team-card .name { font-weight:700; color:var(--bs-body-color); line-height:1.15; }
  .team-card .dept { font-size:.9rem; color:var(--bs-secondary-color); }

  /* 배지 톤 */
  .badge-design { background: var(--bs-success-bg-subtle); color: var(--bs-success-text); }
  .badge-field  { background: var(--bs-warning-bg-subtle); color: var(--bs-warning-text); }
  
    /* ===== 정보 카드 강화(레이블 굵게, 값 크게, 행 분리, 칩) ===== */
  .info-card-body { padding: 1.25rem 1.25rem .9rem; }
  .info-grid .info-row {
    display:flex; align-items:flex-start; gap:1rem;
    padding:.7rem 0 .8rem; border-bottom:1px dashed var(--bs-border-color);
  }
  .info-grid .info-row:last-child { border-bottom:0; padding-bottom:0; }

  .info-grid .label {
    width:120px; min-width:120px; font-weight:700; letter-spacing:.02em;
    color:var(--bs-secondary-color);
  }
  .info-grid .value {
    color:var(--bs-body-color); word-break:keep-all; line-height:1.5;
    font-size:1.08rem; /* 값 크게 */
  }
  .info-grid .value .muted { color:var(--bs-secondary-color); }

  /* 값 강조 줄(타이틀 + 서브메타) */
  .value-strong { font-size:1.15rem; font-weight:800; letter-spacing:.01em; }
  .value-meta { display:block; font-size:.92rem; color:var(--bs-secondary-color); margin-top:.15rem; }

  /* 날짜/상태 등 칩 */
  .info-chip {
    display:inline-block; padding:.2rem .5rem; border-radius:999px;
    border:1px solid var(--bs-border-color); font-size:.82rem; line-height:1;
    background:var(--bs-tertiary-bg);
  }
  .info-chip + .info-chip { margin-left:.35rem; }

  /* 아이콘 점 포인트 (레이블 앞의 작은 점) */
  .label::before{
    content:""; display:inline-block; width:.5rem; height:.5rem; border-radius:50%;
    background: var(--bs-primary);
    margin-right:.5rem; translate:0 -.08rem;
  }
  
  

  /* 다크 모드 보정 */
  [data-bs-theme='dark'] .team-half + .team-half { border-color: rgba(255,255,255,.15); }
   [data-bs-theme='dark'] .info-grid .info-row { border-color: rgba(255,255,255,.15); }
  [data-bs-theme='dark'] .info-chip { border-color: rgba(255,255,255,.15); }
</style>

  
</head>

<body>
  <%@ include file="/module/header.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <div class="body-wrapper">
  <div class="container-fluid">
    
    
  <div class="body-wrapper">
  <div class="container mt-4">
  
	<!-- 브레드크럼 -->
	<div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
	  <div class="card-body px-4 py-3">
	    <div class="row align-items-center">
	      <div class="col-9">
	        <h4 class="fw-semibold mb-8">프로젝트</h4>
	        <nav aria-label="breadcrumb">
	          <ol class="breadcrumb">
	            <li class="breadcrumb-item">
	              <a class="text-muted text-decoration-none" href="/main/dashboard">Home</a>
	            </li>
	            <li class="breadcrumb-item">
	              <a class="text-muted text-decoration-none" href="/project/dashboard?prjctNo=${project.prjctNo}">Project</a>
	            </li>
	            <li class="breadcrumb-item" aria-current="page">Info</li>
	          </ol>
	        </nav>
	      </div>
	    </div>
	  </div>
	</div>
	
	
      <!-- ▷ 공통 캐러셀(고정) -->
      <%@ include file="/WEB-INF/views/project/carousels.jsp" %>


        <!-- ===== 상단 타이틀 & 상태 배지 ===== -->
        <div class="d-flex justify-content-between align-items-start mb-3">
          <div>
            <h3 class="page-title mb-1 d-flex align-items-center gap-2">
              프로젝트 정보
            <c:choose>
			    <c:when test="${project.prjctSttus eq '17002'}">
			      <span class="badge bg-secondary">진행중</span>
			    </c:when>
			    <c:when test="${project.prjctSttus eq '17003'}">
			      <span class="badge bg-success">완료</span>
			    </c:when>
			    <c:when test="${project.prjctSttus eq '17004'}">
			      <span class="badge bg-warning text-dark">보류</span>
			    </c:when>
			    <c:otherwise>
			      <span class="badge bg-primary">${project.prjctSttus}</span>
			    </c:otherwise>
			  </c:choose>
			</h3>
          </div>

		    <div class="d-flex gap-2">
		    	<sec:authorize access="hasRole('ROLE_MANAGER')">
            <c:choose>
              <c:when test="${not empty project.prjctNo}">
                <a href="#" class="btn btn-outline-primary" id="btnUpdateProject"
					  data-bs-toggle="modal"
					  data-bs-target="#projectCreateModal"
					  data-prjct-no="${project.prjctNo}">
					  수정
					</a>
              </c:when>
              <c:otherwise>
              
                <button type="button" class="btn btn-outline-primary" disabled title="프로젝트 번호가 없어 수정할 수 없습니다.">수정</button>
              </c:otherwise>
            </c:choose>
            </sec:authorize>
          </div>
        </div>
        
       
      
        <!-- ===== 2-컬럼(50:50) ===== -->
        <div class="row g-3 mt-1">
          <!-- 좌측 50 : 프로젝트 기본정보 -->
          <div class="col-12 col-lg-6">
            <div class="card border-0 shadow-sm rounded-3 h-100">
          <div class="card-body info-card-body">
			  <div class="d-flex justify-content-between align-items-center mb-3">
			    <h5 class="mb-0">프로젝트 기본정보</h5>
			    <span class="mb-1 badge bg-success-subtle text-success">상세 조회</span>
			  </div>
			
			  <div class="info-grid">
			    <!-- 현장명 -->
			    <div class="info-row">
			      <div class="label">현장명</div>
			      <div class="value">
			        <span class="value-strong"> ${project.sptNm} </span>
			      </div>
			    </div>
			
			    <!-- 현장주소 -->
			    <div class="info-row">
			      <div class="label">현장주소</div>
			      <div class="value-strong">
			       ${project.sptAddr }
			        <div class="mt-1">
			        </div>
			      </div>
			    </div>
			
			    <!-- 고객명 -->
			    <div class="info-row">
			      <div class="label">고객명</div>
			      <div class="value">
			        <span class="value-strong">${project.cstmrNm}</span>
			      </div>
			    </div>
			
			    <!-- 고객 연락처 -->
			    <div class="info-row">
			      <div class="label">고객연락처</div>
			      <div class="value-strong">${project.cstmrTel}
			        <div class="mt-1">
			        </div>
			      </div>
			    </div>
			
			    <!-- 착공기간 -->
			    <div class="info-row">
			      <div class="label">착공기간</div>
			      <div class="value">
			        <span class="value-strong">${project.prjctStartYmd }</span>
			      </div>
			    </div>
			
			    <!-- 마감기간 -->
			    <div class="info-row">
			      <div class="label">마감기간</div>
			      <div class="value">
			        <span class="value-strong">${project.prjctDdlnYmd }</span>
			        <!-- 필요하면 상태 칩 -->
			        <div class="mt-1">
			        </div>
			      </div>
			    </div>
			  </div>
			</div>
            </div>
          </div>

          <!-- 우측 50 : 팀 구성(디자인/현장 50:50) -->
          <div class="col-12 col-lg-6">
            <div class="card team-card border-0 shadow-sm rounded-3 h-100">
              <div class="card-body team-split">

                <!-- 상단 50% : 디자인팀 -->
                <div class="team-half">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0">디자인팀</h6>
                    <span class="mb-1 badge  bg-secondary-subtle text-secondary">DESIGN</span>
                  </div>

                  <c:choose>
					<c:when test="${not empty designerMembers}">
					  <div class="members-grid">
					    <c:forEach var="m" items="${designerMembers}">
					      <%-- 1) 기본값 또는 DB값 선택 --%>
					      <c:set var="path" value="${empty m.photoUrl ? '/resources/assets/images/profile/user-1.jpg' : m.photoUrl}" />
					      <%-- 2) 경로 보정 --%>
					      <c:if test="${!fn:startsWith(path, '/') and !fn:startsWith(path, 'http') and !fn:startsWith(path, '//')}">
					        <c:set var="path" value='/${path}' />
					      </c:if>
					      <%-- 3) 컨텍스트 경로 포함 --%>
					      <c:url var="imgSrc" value="${path}" />
					
					      <div class="member-tile">
					        <img src="${imgSrc}" alt="프로필" class="avatar border" />
					        <div>
					          <div class="name">${fn:escapeXml(m.empNm)}</div>
					          <div class="dept">${fn:escapeXml(m.deptNm)}</div>
					        </div>
					      </div>
					    </c:forEach>
					  </div>
					</c:when>
					  <c:otherwise>
					    <div class="text-muted small">등록된 디자인팀 인원이 없습니다.</div>
					  </c:otherwise>
					</c:choose>
                </div>

				<!-- 하단 50% : 현장팀 -->
				<div class="team-half">
				  <div class="d-flex justify-content-between align-items-center mb-2">
				    <h6 class="mb-0">현장팀</h6>
				    <span class="mb-1 badge  bg-warning-subtle text-warning">FIELD</span>
				  </div>
				
				  <c:choose>
				   <c:when test="${not empty fieldStffMembers}">
					  <div class="members-grid">
					    <c:forEach var="m" items="${fieldStffMembers}">
					      <c:set var="path" value="${empty m.photoUrl ? '/resources/assets/images/profile/user-1.jpg' : m.photoUrl}" />
					      <c:if test="${!fn:startsWith(path, '/') and !fn:startsWith(path, 'http') and !fn:startsWith(path, '//')}">
					        <c:set var="path" value='/${path}' />
					      </c:if>
					      <c:url var="imgSrc" value="${path}" />
					
					      <div class="member-tile">
					        <img src="${imgSrc}" alt="프로필" class="avatar border" />
					        <div>
					          <div class="name">${fn:escapeXml(m.empNm)}</div>
					          <div class="dept">${fn:escapeXml(m.deptNm)}</div>
					        </div>
					      </div>
					    </c:forEach>
					  </div>
					</c:when>

				    <c:otherwise>
				      <div class="text-muted small">등록된 현장팀 인원이 없습니다.</div>
				    </c:otherwise>
				  </c:choose>
				</div>

              </div>
            </div>
          </div>
        </div>
        <!-- /row -->

      </div><!-- /.container -->
    </div><!-- /.container-fluid -->
  </div><!-- /.body-wrapper -->


 <%-- ✅ jsTree 자원: 실제 배치 경로에 맞게 dist/ 포함 --%>

  <%-- ✅ 수정/등록 모달 포함 (jsTree 로드 이후에 include) --%>
<%-- <script src="${pageContext.request.contextPath}/resources/vendor/jstree/jstree.min.js"></script> --%>

  <%@ include file="/WEB-INF/views/project/projectCreateModal.jsp" %>

  <%-- ✅ 수정 모드면 모달 자동 오픈(오류 없이 1회만) --%>
<%--   <c:if test="${status eq 'u'}"> --%>

<%--   </c:if> --%>

 <c:if test="${status eq 'u'}">
  <script type="text/javascript">
    // 프로젝트 수정 모달 내의 폼 제출 이벤트
    $(function() {
        $('#updateProjectForm').on('submit', function(e) {
            e.preventDefault(); // 폼의 기본 제출 동작 방지

            // 폼 데이터 직렬화
            const formData = $(this).serialize();

            $.ajax({
                url: '/project/update/data', // AJAX 처리 컨트롤러 URL
                type: 'POST',
                data: formData, // 폼 데이터 전송
                success: function(response) {
                    if (response.result === "SUCCESS") {
                        Swal.fire('성공', '프로젝트 정보가 수정되었습니다.', 'success').then(() => {
                            location.reload(); 
                        });
                    } else {
                        Swal.fire('실패', '프로젝트 정보 수정에 실패했습니다.', 'error');
                    }
                },
                error: function() {
                    Swal.fire('오류', '서버 통신 오류가 발생했습니다.', 'error');
                }
            });
        });
    });
      
      
      
    </script>
  </c:if>
  
 <%@ include file="/module/footerPart.jsp" %>
</body>
</html>
