<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/module/headPart.jsp"%>
<%@ include file="/module/aside.jsp"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<style>
/* 카드 헤더 배경색을 더 밝게 변경 */
.card-header.bg-primary {
	background-color: #6fa4e9 !important;
	color: #fff !important;
}

.card-header h5 {
    color: #fff !important;
}

.form-check {
	margin-bottom: 0.5rem;
}

.form-check-label {
	font-weight: 400;
	color: #495057;
}

.btn-primary {
	background-color: #2c7be5;
	border-color: #2c7be5;
}

.btn-secondary {
	background-color: #6c757d;
	border-color: #6c757d;
}

.fw-semibold {
	font-weight: 600 !important;
}

/* 추가된 스타일 */
.card.shadow-sm {
    border: 1px solid #dee2e6;
    border-radius: 0.5rem;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="body-wrapper">
	<div class="container-fluid">
		<div
			class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
			<div class="card-body px-4 py-3">
				<div class="row align-items-center">
					<div class="col-9">
						<h4 class="fw-semibold mb-8">설문</h4>
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/main/index">Home</a></li>
								<li class="breadcrumb-item"><a
									class="text-muted text-decoration-none"
									href="${pageContext.request.contextPath}/main/listsurvey">Survey</a></li>
								<li class="breadcrumb-item active" aria-current="page">Detail Survey</li>
							</ol>
						</nav>
					</div>
				</div>
			</div>
		</div>

		<div class="card shadow-sm">
			<div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
				<h5 class="mb-0 text-white">설문지</h5>
			</div>
			<div class="card-body">
				<h4 class="fw-bold mb-3 d-flex align-items-center">
					${survey.surveyTitle}
					<c:if test="${survey.privateYn eq 'Y'}">
						<span class="badge bg-danger ms-2">익명 설문</span>
					</c:if>
				</h4>
				<p class="text-muted">설문 기간 : ${fn:substring(survey.surveyRegDt, 0, 10)} ~ ${fn:substring(survey.surveyDdlnDt, 0, 10)}</p>
				<p class="text-muted">설문 내용 : ${survey.surveyCn}</p>

                <hr class="my-4" />

                <%--
                    c:choose로 분기하여 답변 데이터 유무에 따라 다른 화면을 보여줍니다.
                    survey.questionList[0].userRspnsList는 첫 번째 질문에 대한 답변 리스트입니다.
                    이 리스트가 비어있지 않으면 이미 설문에 참여한 것으로 간주합니다.
                --%>
				<c:choose>
                    <c:when test="${not empty survey.empNo}">
                        <div class="mb-4">
                            <p class="text-success fw-bold">이미 설문에 참여하셨습니다. 답변 내용을 확인하세요.</p>
                        </div>
                        <c:forEach var="question" items="${survey.questionList}" varStatus="status">
                            <div class="mb-4">
                                <label class="fw-semibold mb-2">
                                    ${status.index + 1}. ${question.questionCn}
                                    <c:if test="${question.mandatoryYn eq 'Y'}">
                                        <span class="text-danger">*</span>
                                    </c:if>
                                </label>
                                <c:choose>
                                    <c:when test="${question.questionTy eq '08001'}">
                                        <c:forEach var="option" items="${question.qesitmList}" varStatus="optStatus">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="question_${question.questionNo}" 
                                                    <c:if test="${question.userRspnsList[0].qesitmAnswerNo eq option.qesitmNo}">checked</c:if>
                                                    disabled
                                                    >
                                                <label class="form-check-label">${option.qesitmCn}</label>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:when test="${question.questionTy eq '08002'}">
                                        <c:forEach var="option" items="${question.qesitmList}" varStatus="optStatus">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox"
                                                    <c:forEach var="rspns" items="${question.userRspnsList}">
                                                        <c:if test="${rspns.qesitmAnswerNo eq option.qesitmNo}">checked</c:if>
                                                        disabled
                                                    </c:forEach>
                                                >
                                                <label class="form-check-label">${option.qesitmCn}</label>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:when test="${question.questionTy eq '08003'}">
                                        <p class="form-control-plaintext border p-3 rounded">${question.userRspnsList[0].qesitmAnswerCn}</p>
                                    </c:when>
                                </c:choose>
                            </div>
                        </c:forEach>
                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/main/joinedsurvey" class="btn btn-primary px-4 me-2">목록으로</a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <form id="surveyForm" action="${pageContext.request.contextPath}/main/submitSurvey" method="post">
                            <input type="hidden" name="surveyNo" value="${survey.surveyNo}" />

                            <c:forEach var="question" items="${survey.questionList}" varStatus="status">
                                <div class="mb-4">
                                    <label class="fw-semibold mb-2">
                                        ${status.index + 1}. ${question.questionCn}
                                        <c:if test="${question.mandatoryYn eq 'Y'}">
                                            <span class="text-danger">*</span>
                                        </c:if>
                                    </label>
                                    <c:choose>
                                        <c:when test="${question.questionTy eq '08001'}">
                                            <c:if test="${empty question.qesitmList}">
                                                <p class="text-danger">단일 선택형 옵션이 없습니다.</p>
                                            </c:if>
                                            <c:forEach var="option" items="${question.qesitmList}" varStatus="optStatus">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="q_${question.questionNo}" id="q_${question.questionNo}_${option.qesitmNo}" value="${option.qesitmNo}"
                                                        <c:if test="${question.mandatoryYn eq 'Y'}">required</c:if>>
                                                    <label class="form-check-label" for="q_${question.questionNo}_${option.qesitmNo}">${option.qesitmCn}</label>
                                                </div>
                                            </c:forEach>
                                        </c:when>

                                        <c:when test="${question.questionTy eq '08002'}">
                                            <c:if test="${empty question.qesitmList}">
                                                <p class="text-danger">복수 선택형 옵션이 없습니다.</p>
                                            </c:if>
                                            <c:forEach var="option" items="${question.qesitmList}" varStatus="optStatus">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="q_${question.questionNo}" id="q_${question.questionNo}_${option.qesitmNo}" value="${option.qesitmNo}">
                                                    <label class="form-check-label" for="q_${question.questionNo}_${option.qesitmNo}">${option.qesitmCn}</label>
                                                </div>
                                            </c:forEach>
                                        </c:when>

                                        <c:when test="${question.questionTy eq '08003'}">
                                            <textarea class="form-control" rows="3" name="q_${question.questionNo}" placeholder="의견을 입력해주세요."
                                                <c:if test="${question.mandatoryYn eq 'Y'}">required</c:if>></textarea>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                            <c:if test="${empty survey.questionList}">
                                <p class="text-danger">등록된 설문 문항이 없습니다.</p>
                            </c:if>

                            <div class="d-flex justify-content-end mt-4">
                                <button type="submit" class="btn btn-primary px-4 me-2">제출</button>
                                <a href="${pageContext.request.contextPath}/main/listsurvey" class="btn btn-secondary px-4">취소</a>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
			</div>
			
		</div>
	</div>
</div>

<%@ include file="/module/footerPart.jsp"%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('surveyForm');

    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // 1. 필수 답변 검증
            // 모든 질문 컨테이너(div.mb-4)를 선택
            const allQuestionContainers = document.querySelectorAll('.mb-4');
            let allAnswered = true;

            allQuestionContainers.forEach(container => {
                const isMandatory = container.querySelector('.text-danger'); // '필수' * 표시 확인
                
                // 필수 질문이 아니면 검사하지 않고 넘어감
                if (!isMandatory) {
                    return;
                }

                // 질문에 해당하는 모든 입력 필드(radio, checkbox, textarea)를 찾음
                const inputs = container.querySelectorAll('input, textarea');
                let questionAnswered = false;

                inputs.forEach(input => {
                    // 체크박스나 라디오 버튼이 선택되었는지, 또는 텍스트 입력 필드에 값이 있는지 확인
                    if ((input.type === 'radio' || input.type === 'checkbox') && input.checked) {
                        questionAnswered = true;
                    } else if (input.type === 'textarea' && input.value.trim() !== '') {
                        questionAnswered = true;
                    }
                });
                
                // 해당 필수 질문이 답변되지 않았으면 경고
                if (!questionAnswered) {
                    allAnswered = false;
                }
            });
            
            if (!allAnswered) {
                Swal.fire({
                    title: '필수 답변 누락',
                    text: '모든 필수 질문에 답변해주세요.',
                    icon: 'warning',
                    confirmButtonText: '확인'
                });
                return;
            }

            // 2. 모든 검증 통과 후, 폼 제출 확인
            Swal.fire({
                title: '설문을 제출하시겠습니까?',
                text: "한 번 제출하면 수정할 수 없습니다.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '제출',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        });
    }
});
</script>
</body>
</html>