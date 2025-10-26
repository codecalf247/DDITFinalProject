<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<sec:authentication property="principal.member" var="member"/>

<style>
.chart-container {
    height: 250px;   /* 차트 높이 */
    width: 100%;     /* col-md-6 안에서 꽉 차게 */
}
/* 카드 헤더 배경색을 더 밝게 변경 */
.card-header.bg-primary {
	background-color: #6fa4e9 !important;
	color: #fff !important;
}
.card-header h5 { color: #fff !important; }	
.form-check { margin-bottom: 0.5rem; }
.form-check-label { font-weight: 400; color: #495057; }
.btn-primary { background-color: #2c7be5; border-color: #2c7be5; }
.btn-secondary { background-color: #6c757d; border-color: #6c757d; }
.fw-semibold { font-weight: 600 !important; }
.card.shadow-sm { border: 1px solid #dee2e6; border-radius: 0.5rem; }

.chart-container {
    height: 250px;
    width: 100%;
}
.progress-bar {
    background-color: #2c7be5;
    color: #fff;
    padding-left: 10px;
    font-weight: bold;
    line-height: 20px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="body-wrapper">
    <div class="container-fluid">
        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
            <div class="card-body px-4 py-3">
                <div class="row align-items-center">
                    <div class="col-9">
                        <h4 class="fw-semibold mb-8">설문</h4>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/index">Home</a></li>
                                <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="${pageContext.request.contextPath}/main/endsurvey">EndSurvey</a></li>
                                <li class="breadcrumb-item active" aria-current="page">EndSurvey Detail</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        
       
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-white">${survey.surveyTitle}</h5>
            </div>
            <div class="card-body">
                <p class="text-muted">설문 기간: ${fn:substring(survey.surveyRegDt, 0, 10)} ~ ${fn:substring(survey.surveyDdlnDt, 0, 10)}</p>
                <p class="text-muted">설문 내용: ${survey.surveyCn}</p>

                <hr class="my-4" />
                
                <c:choose>
                    <c:when test="${survey.privateYn eq 'N'}">
                        <h6 class="fw-bold">답변자 목록 (${totalParticipants}명)</h6>
                        <div class="mb-4">
                            <c:if test="${not empty respondents}">
                                <c:forEach var="respondent" items="${respondents}" varStatus="status">
                                    <span class="badge bg-secondary me-1">${respondent.empNm}</span>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty respondents}">
                                <p class="text-muted">아직 답변자가 없습니다.</p>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
					<h6 class="fw-bold">
					    답변자 목록:<span class="badge bg-primary ms-2">${totalParticipants}명</span>
					</h6>                   
				 </c:otherwise>
                </c:choose>
                <hr class="my-4" />
                <c:forEach var="question" items="${survey.questionList}" varStatus="status">
                    <div class="mb-4">
                        <h6 class="fw-semibold mb-2">${status.index + 1}. ${question.questionCn}</h6>
                        <c:choose>
                            <c:when test="${question.questionTy eq '08001' or question.questionTy eq '08002'}">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <div class="chart-container">
                                            <canvas id="jhChart-${question.questionNo}"></canvas>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <c:forEach var="option" items="${question.qesitmList}">
								    <c:set var="percentage" value="${totalParticipants > 0 ? (option.rspnsCount / totalParticipants) * 100 : 0}"/>
								    <div class="mb-2">
								        <p class="mb-1">${option.qesitmCn} (${option.rspnsCount}표)</p>
								        <div class="progress" style="height: 25px;">
								            <c:if test="${option.rspnsCount > 0}">
								                <div class="progress-bar" role="progressbar" style="width: ${percentage}%">
								                    <span class="ps-2">
								                        ${fn:substring(percentage, 0, fn:indexOf(percentage, '.') + 3)}%
								                    </span>
								                </div>
								            </c:if>
								        </div>
								    </div>
								</c:forEach>
								 </div>
                                </div>
                            </c:when>
                            <c:when test="${question.questionTy eq '08003'}">
                                <ul class="list-group">
                                    <c:if test="${survey.privateYn eq 'Y'}">
                                        <li class="list-group-item text-muted">익명 설문입니다. 답변자 정보가 표시되지 않습니다.</li>
                                    </c:if>
                                    <c:forEach var="rspns" items="${question.userRspnsList}">
                                        <li class="list-group-item">
                                            <c:if test="${survey.privateYn eq 'N'}">
                                                <strong class="me-2">${rspns.empNm}:</strong>
                                            </c:if>
                                            ${rspns.qesitmAnswerCn}
                                        </li>
                                    </c:forEach>
                                    <c:if test="${empty question.userRspnsList}">
                                        <li class="list-group-item text-muted">답변이 없습니다.</li>
                                    </c:if>
                                </ul>
                            </c:when>
                        </c:choose>
                    </div>
                </c:forEach>

                <div class="d-flex justify-content-end mt-4">
                    <a href="${pageContext.request.contextPath}/main/endsurvey" class="btn btn-primary px-4 me-2">목록으로</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/module/footerPart.jsp"%>

<div id="chartContainer"></div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const stats = ${jhStr};
    const qList = stats.questionList;

    qList.forEach(q => {
        // JSP에서 만든 canvas 가져오기
        const canvas = document.getElementById("jhChart-" + q.questionNo);
        if (!canvas || !q.qesitmList) return;  // 주관식은 건너뛰기

        const labels = q.qesitmList.map(opt => opt.qesitmCn);
        const data = q.qesitmList.map(opt => opt.rspnsCount);


        new Chart(canvas, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: q.questionCn,
                        data: data,
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,  // 크기 제어 가능하게
                plugins: {
                    legend: { position: 'top' },
                    title: { display: true, text: q.questionCn }
                }
            }
        });
    });
});
</script>
</body>
</html>