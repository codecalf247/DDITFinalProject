<!-- WEB-INF/views/attendance/attdMenu.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
  <%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
    <style>
      .list-group-item.active .menu-link {
        color: #fff;
        font-weight: bold;
      }

      .list-group-item .menu-link {
        display: flex;
        align-items: center;
        /* 아이콘과 텍스트 세로 가운데 정렬 */
      }

      .list-group-item .menu-link i {
        font-size: 1.2rem;
        margin-right: 7px;
      }
    </style>
    <ul class="list-group list-group-menu mh-n100">
      <li class="border-bottom my-3"></li>

      <!-- 근태관리 -->
      <li class="list-group-item has-submenu">
        <a class="menu-link mb-2" href="#">
          <i class="ti ti-calendar-user"></i> 근태관리 <i class="ti ti-chevron-right menu-toggle"></i>
        </a>
        <ul class="submenu" style="border-radius: 8px;">
          <li class="list-group-item ${activeMenu eq 'attendance' ? 'active' : ''} ">
            <a class="menu-link" href="${pageContext.request.contextPath}/attendance">근태 현황</a>
          </li>
          <li class="list-group-item ${activeMenu eq 'history' ? 'active' : ''}">
            <a class="menu-link" href="${pageContext.request.contextPath}/attendance/history">근태 이력</a>
          </li>
          <li class="list-group-item ${activeMenu eq 'yearVacation' ? 'active' : ''}">
            <a class="menu-link" href="${pageContext.request.contextPath}/attendance/yearVacation">연차 내역</a>
          </li>
        </ul>
      </li>
	  
	<sec:authorize access="hasRole('ROLE_MANAGER')">
      <!-- 전사 근태관리 -->
      <li class="list-group-item has-submenu">
        <a class="menu-link mb-2" href="#">
          <i class="ti ti-users"></i> 전사 근태관리 <i class="ti ti-chevron-right menu-toggle"></i>
        </a>
        <ul class="submenu" style="border-radius: 8px;">
          <li class="list-group-item ${activeMenu eq 'companyAttd' ? 'active' : ''}">
          <a class="menu-link" href="${pageContext.request.contextPath}/attendance/companyAttd">전사 근태 현황</a></li>
          <li class="list-group-item ${activeMenu eq 'companyAttdAnalytics' ? 'active' : ''}">
          <a class="menu-link" href="${pageContext.request.contextPath}/attendance/companyAttdAnalytics">전사 근태 통계</a></li>
          <li class="list-group-item ${activeMenu eq 'companyYearVacation' ? 'active' : ''}">
          <a class="menu-link" href="${pageContext.request.contextPath}/attendance/companyYearVacation">전사 연차 현황</a></li>
        </ul>
      </li>
	</sec:authorize>

      <!-- 근태 수정 요청 -->
      <li class="list-group-item has-submenu">
        <a class="menu-link mb-2" href="#">
          <i class="ti ti-user-edit"></i> 근태 수정요청 <i class="ti ti-chevron-right menu-toggle"></i>
        </a>
        <ul class="submenu" style="border-radius: 8px;">
          <li class="list-group-item ${activeMenu eq 'attdUpdateReq' ? 'active' : ''}"><a class="menu-link"
              href="${pageContext.request.contextPath}/attendance/attdUpdateReq">근태 수정 요청</a></li>
        </ul>
      </li>
    </ul>