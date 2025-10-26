<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pno" value="${project.prjctNo}" />
<c:if test="${empty pno}">
  <c:set var="pno" value="${prjctNo}" />
</c:if>
<c:if test="${empty pno}">
  <c:set var="pno" value="${param.prjctNo}" />
</c:if>

<!-- 컨텍스트 패스 공통 변수 -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>

  .text-purple { color: #6f42c1 !important; }
  .bg-purple-subtle { background-color: #f3e8ff !important; }
  .text-bg-purple { background-color: #6f42c1 !important; color: #fff !important; }
  .bg-teal-subtle { background-color: #e0f7f5 !important; }
  .bg-orange-subtle { background-color: #fff4e0 !important; }
  .bg-pink-subtle { background-color: #ffe0f0 !important; }
  .bg-sky-subtle { background-color: #e0f2ff !important; }
  .bg-mint-subtle { background-color: #e6fff5 !important; }
  .bg-lavender-subtle { background-color: #f4e8ff !important; }

  .project_btn_wrap { display: inline-block; width: 100%; z-index: 1 }
  .project_btn_wrap .item{width:calc(12.5% - 8.75px); display:inline-block; float:left; margin-right:10px;}
  .project_btn_wrap .item:last-child{margin-right:0;}
 
  @media (max-width: 1200px) {
    .project_btn_wrap .item{width:calc(25% - 7.5px);}
    .project_btn_wrap .item:nth-child(4n){margin-right:0;}
  }
  @media (max-width: 650px) {
    .project_btn_wrap .item{width:calc(50% - 5px);}
    .project_btn_wrap .item:nth-child(2n){margin-right:0;}
  }

  /* 선택된 카드 시각 강조 */
  #project-carousel .card.is-selected {
    border: 2px solid #878787 !important;
    box-shadow: 0 0.5rem 1.25rem rgba(13,110,253,.25);
    transform: translateY(-2px);
    transition: box-shadow .2s ease, transform .2s ease;
  }
</style>

<!-- 캐러셀 -->
<div id="project-carousel" class="counter-carousel owl-theme project_btn_wrap">

  <!-- 자료함 -->
  <div class="item">
    <div class="card border-0 card-hover bg-lavender-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/design.svg" width="50" height="50" class="mb-3" alt="자료함" />
          <p class="fw-semibold fs-3 text-primary mb-1">자료함</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/files?prjctNo=${pno}" class="stretched-link" aria-label="자료함으로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 견적서 -->
  <div class="item">
    <div class="card border-0 card-hover bg-danger-subtle shadow-none position-relative" data-bs-theme="light">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/calculator.svg" width="50" height="50" class="mb-3" alt="견적서" />
          <p class="fw-semibold fs-3 text-danger mb-1">견적서</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/estimate?prjctNo=${pno}" class="stretched-link" aria-label="견적서로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 일감 리스트 -->
  <div class="item">
    <div class="card border-0 card-hover bg-sky-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/tasksboard.svg" width="50" height="50" class="mb-3" alt="일감 리스트" />
          <p class="fw-semibold fs-3 text-info mb-1">일감 리스트</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/tasks?prjctNo=${pno}" class="stretched-link" aria-label="일감 리스트로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 칸반보드 -->
  <div class="item">
    <div class="card border-0 card-hover bg-orange-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/kanban.svg" width="50" height="50" class="mb-3" alt="칸반보드 관리" />
          <p class="fw-semibold fs-3 text-success mb-1">칸반보드</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/kanban?prjctNo=${pno}" class="stretched-link" aria-label="칸반보드로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 간트차트 -->
  <div class="item">
    <div class="card border-0 card-hover bg-mint-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/gantt-chart.svg" width="50" height="50" class="mb-3" alt="간트차트 관리" />
          <p class="fw-semibold fs-3 text-success mb-1">간트차트</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/gantt?prjctNo=${pno}" class="stretched-link" aria-label="간트차트로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 현장사진 -->
  <div class="item">
    <div class="card border-0 card-hover bg-orange-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/camera.svg" width="50" height="50" class="mb-3" alt="현장사진" />
          <p class="fw-semibold fs-3 text-warning mb-1">현장사진</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/photos/list?prjctNo=${pno}" class="stretched-link" aria-label="현장사진으로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 이슈 관리 -->
  <div class="item">
    <div class="card border-0 card-hover bg-pink-subtle shadow-none position-relative">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/cwarning.svg" width="50" height="50" class="mb-3" alt="이슈 관리" />
          <p class="fw-semibold fs-3 text-danger mb-1">이슈 관리</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/issues/lists?prjctNo=${pno}" class="stretched-link" aria-label="이슈 관리로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 프로젝트 정보 -->
  <div class="item">
    <div class="card border-0 card-hover bg-success-subtle shadow-none position-relative" data-bs-theme="light">
      <div class="card-body">
        <div class="text-center">
          <img src="${ctx}/resources/assets/images/svgs/info.svg" width="50" height="50" class="mb-3" alt="프로젝트 정보" />
          <p class="fw-semibold fs-3 text-success mb-1">정보</p>
          <c:if test="${not empty pno}">
            <a href="${ctx}/project/info?prjctNo=${pno}" class="stretched-link" aria-label="프로젝트 정보로 이동"></a>
          </c:if>
        </div>
      </div>
    </div>
  </div>

</div>

<!-- 바닐라 JS: 자동/클릭 하이라이트 -->
<script>
document.addEventListener('DOMContentLoaded', () => {
  const carousel = document.getElementById('project-carousel');
  if (!carousel) return;

  const cards = Array.from(carousel.querySelectorAll('.card'));
  const links = Array.from(carousel.querySelectorAll('a.stretched-link'));

  const here = window.location.pathname + window.location.search;

  // 현재 URL과 동일한 링크를 찾아 카드에 is-selected 부여
  let activeIndex = -1;
  for (let i = 0; i < links.length; i++) {
    const href = links[i].getAttribute('href');
    // href가 상대경로일 수 있으므로 URL 객체로 정규화
    const url = new URL(href, window.location.origin);
    const target = url.pathname + url.search;
    if (target === here) { activeIndex = i; break; }
  }
  if (activeIndex !== -1) {
    cards[activeIndex]?.classList.add('is-selected');
  }

  // 클릭 시 시각 피드백
  links.forEach((a, i) => {
    a.addEventListener('click', () => {
      cards.forEach(c => c.classList.remove('is-selected'));
      cards[i]?.classList.add('is-selected');
    });
  });

  
   


});
</script>
