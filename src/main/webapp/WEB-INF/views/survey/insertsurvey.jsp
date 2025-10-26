<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <!-- Required meta tags -->
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
</head>
  <%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>
  <div class="body-wrapper">
    <div class="container-fluid"> 

<div class="container mt-4">
	<h3>새 설문 작성</h3>
	<form action="${pageContext.request.contextPath}/main/insertsurvey" method="post">
		<div style="text-align:right">
					<button type="button" class="btn btn-outline-warning" onclick="fillDummyData()">
			   <i class="fa fa-magic"></i> 더미데이터
			</button>
			</div>
		<div class="mb-3">
			<label class="form-label">설문 제목</label> 
			<input type="text" class="form-control" name="surveyTitle" placeholder="설문 제목을 입력하세요" required>
		</div>

		<div class="mb-3">
			<label class="form-label">설문 내용</label> 
			<textarea class="form-control" name="surveyCn" placeholder="설문 내용을 입력하세요" required></textarea>
		</div>
		
		<div class="mb-3">
    <label class="form-label">설문 마감일시</label>
    		<input type="text" class="form-control" id="surveyDdlnDt" name="surveyDdlnDt" placeholder="마감일시를 선택하세요" required>
		</div>

		<div class="form-check mb-3">
			<input class="form-check-input" type="checkbox" id="anonymousCheck" name="privateYn" value="Y">
			<label class="form-check-label" for="anonymousCheck"> 익명 투표 허용 </label>
		</div>

		<div class="form-check mb-3">
			<input class="form-check-input" type="checkbox" id="publicCheck" name="othbcYn" value="Y">
			<label class="form-check-label" for="publicCheck"> 공개 투표 허용 </label>
		</div>

		<div id="questionList" class="mb-3">
			<div class="card mb-2 question-item" data-qindex="0">
				<div class="card-body">
					<div class="d-flex justify-content-between align-items-center mb-2">
					
						<label class="form-label mb-0"><b>문항 1 (선택형)</b></label>
						<div>
							<input type="hidden" name="questionList[0].mandatoryYn" value="Y" class="mandatory-hidden-field">
							<div class="form-check form-check-inline">
								<input class="form-check-input mandatory-checkbox" type="checkbox" id="mandatoryCheck1" checked onchange="updateMandatoryStatus(this)">
								<label class="form-check-label" for="mandatoryCheck1">필수</label>
							</div>
							<button type="button" class="btn btn-sm btn-outline-danger delete-question">질문 삭제</button>
						</div>
						
					</div>
					
					<input type="hidden" name="questionList[0].questionTy" value="08001">
					<input type="text" class="form-control mb-2" name="questionList[0].questionCn" placeholder="질문을 입력하세요" required>
					
					<div class="options-container">
					
						<div class="input-group mb-1 option-item">
							<div class="input-group-text">
								<input class="form-check-input mt-0" type="radio" disabled>
							</div>
							<input type="text" class="form-control" name="questionList[0].qesitmList[0].qesitmCn" placeholder="옵션 1" required>
							<button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
						</div>
						
						<div class="input-group mb-1 option-item">
							<div class="input-group-text">
								<input class="form-check-input mt-0" type="radio" disabled>
							</div>
							<input type="text" class="form-control" name="questionList[0].qesitmList[1].qesitmCn" placeholder="옵션 2" required>
							<button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
						</div>
						
					</div>
					
					<button type="button" class="btn btn-sm btn-outline-primary mt-2 add-option">+ 옵션 추가</button>
					
				</div>
			</div>
		</div>

		<div class="d-flex gap-2 mb-3">
		    <button type="button" class="btn btn-sm btn-outline-success" onclick="addChoiceQuestion()">+ 객관식 추가</button>
		    <button type="button" class="btn btn-sm btn-outline-warning" onclick="addMultiChoiceQuestion()">+ 객관식(복수) 추가</button>
		    <button type="button" class="btn btn-sm btn-outline-info" onclick="addTextQuestion()">+ 주관식 추가</button>
		</div>

		<button type="submit" class="btn btn-primary px-4">등록하기</button>
		<a href="${pageContext.request.contextPath}/main/listsurvey" class="btn btn-secondary px-4">취소</a> 
	</form>
</div>

        </div>	<!-- <div class="container-fluid"> -->
      </div>	<!-- <div class="body-wrapper"> -->    

<%@ include file="/module/footerPart.jsp" %>
<script>
    let qCount = 1;

    document.addEventListener('DOMContentLoaded', (event) => {
        setupQuestionEvents();
    });

    function addChoiceQuestion() {
    	 let iCount = 0;
        
        const question = `
            <div class="card mb-2 question-item" data-qindex="\${qCount}">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="form-label mb-0"><b>문항 \${qCount+1} (선택형)</b></label>
						<div>
							<input type="hidden" name="questionList[\${qCount}].mandatoryYn" value="Y" class="mandatory-hidden-field">
							<div class="form-check form-check-inline">
								<input class="form-check-input mandatory-checkbox" type="checkbox" id="mandatoryCheck\${qCount}" checked onchange="updateMandatoryStatus(this)">
								<label class="form-check-label" for="mandatoryCheck\${qCount}">필수</label>
							</div>
                        	<button type="button" class="btn btn-sm btn-outline-danger delete-question">질문 삭제</button>
						</div>
                    </div>
                    <input type="hidden" name="questionList[\${qCount}].questionTy" value="08001">
                    <input type="text" class="form-control mb-2" name="questionList[\${qCount}].questionCn" placeholder="질문을 입력하세요" required>
                    <div class="options-container">
                        <div class="input-group mb-1 option-item">
                            <div class="input-group-text">
                                <input class="form-check-input mt-0" type="radio" disabled>
                            </div>
                            <input type="text" class="form-control" name="questionList[\${qCount}].qesitmList[\${iCount++}].qesitmCn" placeholder="옵션 1" required>
                            <button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
                        </div>
                        <div class="input-group mb-1 option-item">
                            <div class="input-group-text">
                                <input class="form-check-input mt-0" type="radio" disabled>
                            </div>
                            <input type="text" class="form-control" name="questionList[\${qCount}].qesitmList[\${iCount++}].qesitmCn" placeholder="옵션 2" required>
                            <button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
                        </div>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-primary mt-2 add-option">+ 옵션 추가</button>
                </div>
            </div>`;
       	 	qCount++;
        document.getElementById("questionList").insertAdjacentHTML("beforeend", question);
        setupQuestionEvents();
    }

    function addTextQuestion() {
        const question = `
            <div class="card mb-2 question-item" data-qindex="\${qCount}">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="form-label mb-0"><b>문항 \${qCount+1} (주관식)</b></label>
						<div>
							<input type="hidden" name="questionList[\${qCount}].mandatoryYn"  value="Y" class="mandatory-hidden-field">
							<div class="form-check form-check-inline">
								<input class="form-check-input mandatory-checkbox" type="checkbox" id="mandatoryCheck\${qCount}" checked onchange="updateMandatoryStatus(this)">
								<label class="form-check-label" for="mandatoryCheck\${qCount}">필수</label>
							</div>
                        	<button type="button" class="btn btn-sm btn-outline-danger delete-question">질문 삭제</button>
						</div>
                    </div>
                    <input type="hidden"  name="questionList[\${qCount}].questionTy" value="08003">
                    <input type="text" class="form-control mb-2" name="questionList[\${qCount}].questionCn" placeholder="질문을 입력하세요" required>
                    <textarea class="form-control" rows="2" placeholder="답변 입력란 (주관식)" disabled></textarea>
                </div>
            </div>`;
            qCount++;
        document.getElementById("questionList").insertAdjacentHTML("beforeend", question);
        setupQuestionEvents();
    }

    function setupQuestionEvents() {
        const questionList = document.getElementById('questionList');

        questionList.removeEventListener('click', handleQuestionClick);
        questionList.addEventListener('click', handleQuestionClick);

        updateQuestionNumbers();
    }

    function handleQuestionClick(event) {
        if (event.target.classList.contains('delete-question')) {
            const questionItem = event.target.closest('.question-item');
            if (questionItem) {
                questionItem.remove();
                updateQuestionNumbers();
                qCount--;
            }
        }
        
        if (event.target.classList.contains('add-option')) {
        	const questionItem = event.target.closest('.question-item');
            const qIndex = questionItem.dataset.qindex;
            const optionsContainer = questionItem.querySelector('.options-container');
            const newOptionCount = optionsContainer.children.length;
            const newOption = `
                <div class="input-group mb-1 option-item">
                    <div class="input-group-text">
                        <input class="form-check-input mt-0" type="radio" disabled>
                    </div>
                    <input type="text" class="form-control" name="questionList[\${qIndex}].qesitmList[\${newOptionCount}].qesitmCn" placeholder="옵션 \${newOptionCount+1}" required>
                    <button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
                </div>`;
            optionsContainer.insertAdjacentHTML("beforeend", newOption);
        }

        if (event.target.classList.contains('delete-option')) {
            const optionItem = event.target.closest('.option-item');
            if (optionItem) {
                const optionsContainer = optionItem.closest('.options-container');
                if (optionsContainer.children.length > 2) {
                    optionItem.remove();
                } else {
                    alert("최소 2개의 옵션은 유지해야 합니다.");
                }
            }
        }
    }

    function updateQuestionNumbers() {
        const questions = document.querySelectorAll('.question-item');
        questions.forEach((question, index) => {
            const label = question.querySelector('.form-label');
            
            // 문항 번호만 표시하도록 수정
            label.innerHTML = `<b>문항 \${index + 1}</b>`;

            // 질문 관련 name 속성 업데이트
            const mandatoryYnInput = question.querySelector('.mandatory-hidden-field');
            if(mandatoryYnInput) mandatoryYnInput.name = `questionList[\${index}].mandatoryYn`;
            
            const questionTyInput = question.querySelector('[name^="questionList["][name$="].questionTy"]');
            if(questionTyInput) questionTyInput.name = `questionList[\${index}].questionTy`;
            
            const questionCnInput = question.querySelector('[name^="questionList["][name$="].questionCn"]');
            if(questionCnInput) questionCnInput.name = `questionList[\${index}].questionCn`;

            // checkbox id 및 for 속성 업데이트
            const checkbox = question.querySelector('.mandatory-checkbox');
            if (checkbox) {
                checkbox.id = `mandatoryCheck\${index + 1}`;
                const checkboxLabel = question.querySelector('label[for^="mandatoryCheck"]');
                if (checkboxLabel) {
                    checkboxLabel.setAttribute('for', `mandatoryCheck\${index + 1}`);
                }
            }

        });
        // 현재 질문 개수로 qCount를 재설정
        qCount = questions.length;
    }
    
	function updateMandatoryStatus(checkbox) {
		const hiddenInput = checkbox.closest('div.d-flex').querySelector('.mandatory-hidden-field');
		if (checkbox.checked) {
			hiddenInput.value = 'Y';
		} else {
			hiddenInput.value = 'N';
		}
	}
	
	function addMultiChoiceQuestion() {
   	 	let iCount = 0;
   	 	
	    const question = `
	        <div class="card mb-2 question-item" data-qindex="\${qCount}">
	            <div class="card-body">
	                <div class="d-flex justify-content-between align-items-center mb-2">
	                    <label class="form-label mb-0"><b>문항 \${qCount+1} (복수선택형)</b></label>
	                    <div>
	                        <input type="hidden"  name="questionList[\${qCount}].mandatoryYn" value="Y" class="mandatory-hidden-field">
	                        <div class="form-check form-check-inline">
	                            <input class="form-check-input mandatory-checkbox" type="checkbox" id="mandatoryCheck\${qCount}" checked onchange="updateMandatoryStatus(this)">
	                            <label class="form-check-label" for="mandatoryCheck\${qCount}">필수</label>
	                        </div>
	                        <button type="button" class="btn btn-sm btn-outline-danger delete-question">질문 삭제</button>
	                    </div>
	                </div>
	                <input type="hidden" name="questionList[\${qCount}].questionTy" value="08002">
	                <input type="text" class="form-control mb-2" name="questionList[\${qCount}].questionCn" placeholder="질문을 입력하세요" required>
	                <div class="options-container">
	                    <div class="input-group mb-1 option-item">
	                        <div class="input-group-text">
	                            <input class="form-check-input mt-0" type="checkbox" disabled>
	                        </div>
	                        <input type="text" class="form-control" name="questionList[\${qCount}].qesitmList[\${iCount++}].qesitmCn" placeholder="옵션 1" required>
	                        <button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
	                    </div>
	                    <div class="input-group mb-1 option-item">
	                        <div class="input-group-text">
	                            <input class="form-check-input mt-0" type="checkbox" disabled>
	                        </div>
	                        <input type="text" class="form-control" name="questionList[\${qCount}].qesitmList[\${iCount++}].qesitmCn" placeholder="옵션 2" required>
	                        <button type="button" class="btn btn-sm btn-outline-secondary delete-option">삭제</button>
	                    </div>
	                </div>
	                <button type="button" class="btn btn-sm btn-outline-primary mt-2 add-option">+ 옵션 추가</button>
	            </div>
	        </div>`;
		    qCount++;
	    document.getElementById("questionList").insertAdjacentHTML("beforeend", question);
	    setupQuestionEvents();
	}
	
	document.addEventListener('DOMContentLoaded', (event) => {
	    // flatpickr 초기화
	    flatpickr("#surveyDdlnDt", {
	        enableTime: true,
	        dateFormat: "Y-m-dTH:i",
	        altInput: true,
	        altFormat: "Y-m-d H:i",
	        onReady: function(selectedDates, dateStr, instance) {
	            // 텍스트 박스에 포커스되었을 때 위젯을 열도록 설정
	            instance.altInput.addEventListener("focus", function() {
	                instance.open();
	            });
	        }
	    });
	    setupQuestionEvents();
	});
</script>

<script>
function fillDummyData() {
    // 설문 제목, 내용, 마감일 설정
    document.querySelector("[name='surveyTitle']").value = "📢 제 5차 사내 복지 프로그램 설문조사";
    document.querySelector("[name='surveyCn']").value = 
        "안녕하세요, 임직원 여러분.\n\n" +
        "이번 설문은 사내 복지 프로그램에 대한 의견을 수렴하고자 합니다.\n" +
        "많은 참여 부탁드립니다. 😊";

    // flatpickr 마감일 현재 날짜 + 7일
    const now = new Date();
    now.setDate(now.getDate() + 7);
    const deadline = now.toISOString().slice(0,16); 
    document.querySelector("#surveyDdlnDt").value = deadline;

    // 익명, 공개 투표 체크
    document.querySelector("#anonymousCheck").checked = true;
    document.querySelector("#publicCheck").checked = true;

    // 기본 문항 지우고 시작
    document.getElementById("questionList").innerHTML = "";
    qCount = 0;

    // 1. 객관식 질문
    addChoiceQuestion();
    document.querySelector("[name='questionList[0].questionCn']").value = "가장 만족스러운 복지 항목은 무엇입니까?";
    document.querySelector("[name='questionList[0].qesitmList[0].qesitmCn']").value = "사내 카페테리아";
    document.querySelector("[name='questionList[0].qesitmList[1].qesitmCn']").value = "헬스장 지원";

    // 2. 복수선택형 질문
    addMultiChoiceQuestion();
    document.querySelector("[name='questionList[1].questionCn']").value = "추가로 원하는 복지 혜택을 모두 선택해주세요.";
    const multiOptions = [
        "도서 구매 지원",
        "해외 연수 프로그램",
        "재택근무 확대",
        "사내 동호회 지원",
        "자기계발비 지원"
    ];
    const optionsContainer = document.querySelectorAll(".question-item")[1].querySelector(".options-container");

    // 옵션 2개는 기본, 나머지 3개 추가
    for (let i = 2; i < 5; i++) {
        document.querySelectorAll(".question-item")[1].querySelector(".add-option").click();
    }

    optionsContainer.querySelectorAll(".form-control").forEach((input, idx) => {
        input.value = multiOptions[idx];
    });

    // 3. 주관식 질문
    addTextQuestion();
    document.querySelector("[name='questionList[2].questionCn']").value = "기타 의견이 있으시면 자유롭게 작성해주세요.";
}
</script>
</body>
