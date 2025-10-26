function getColorByType(ty) {
  switch (ty) {
    case "11001":
      return { textColor: "#5d87ff", bgColor: "#eef3ff" };
    case "11002":
      return { textColor: "#13deb9", bgColor: "#e6fffa" };
    case "11003":
      return { textColor: "#ffb51f", bgColor: "#fef5e5" };
    default:
      return { textColor: "#000000", bgColor: "#ffffff" }; // 기본값
  }
}

/*========Calender Js=========*/
/*==========================*/

function initCalendar(calendarEventsList, loginEmpNo, loginDeptNo) {
  /*=================*/
  //  Calender Date variable
  /*=================*/
  var newDate = new Date(); // 현재 날짜
  // 월을 두자리 문자열로 반환(4 -> 04)
  function getDynamicMonth() {
    getMonthValue = newDate.getMonth();
    _getUpdatedMonthValue = getMonthValue + 1;
    if (_getUpdatedMonthValue < 10) {
      return `0${_getUpdatedMonthValue}`;
    } else {
      return `${_getUpdatedMonthValue}`;
    }
  }

  /*=================*/
  // Calender Modal Elements
  /*=================*/
  // 내부요소들을 JS에서 다루기위 DOM 선택
  // 모달: 이벤트 제목 입력 필드
  var getModalTitleEl = document.querySelector("#event-title");
  // 모달 : 이벤트 내용 입력 필드
  var getModalCnEl = document.querySelector("#event-content");
  // 모달 : 이벤트 유형 라디오버튼 3개
  var getModalradios = document.querySelectorAll('input[name="event-type"]');
  // 모달 : 시작 날짜 입력 필드
  var getModalStartDateEl = document.querySelector("#event-start-date");
  // 모달 : 종료 날짜 입력 필드
  var getModalEndDateEl = document.querySelector("#event-end-date");

  // 모달 : 이벤트 추가 버튼
  var getModalAddBtnEl = document.querySelector(".btn-add-event");
  // 모달 : 이벤트 수정 버튼
  var getModalUpdateBtnEl = document.querySelector(".btn-update-event");
  // 모달 : 이벤트 삭제 버튼
  var getModalDeleteBtnEl = document.querySelector(".btn-delete-event");
  // 모달 : 이벤트 수정 완료 버튼
  var getModalUpdateCompleteBtnEl = document.querySelector(
    ".btn-update-complete-event"
  );

  /*=====================*/
  // Calendar Elements and options
  /*=====================*/

  // 달력을 그릴 DOM ★★★★★★★★★★★★★★
  // FullCalendar가 렌더링될 컨터이너 요소
  var calendarEl = document.querySelector("#calendar");

  // 화면폭이 작아지면 true(반응형 레이아웃)
  /*  var checkWidowWidth = function () { 
    if (window.innerWidth <= 11099) {
      return true;
    } else {
      return false;
    }
  };
  */

  // 캘린더 헤더 설정 (좌 : 이전 다음 추가 버튼)
  // 중 : 제목(연/월)
  // 우 : 달력 뷰 변경 버튼(월, 주, 일)
  var calendarHeaderToolbar = {
    left: "addEventButton", // 이전/다음/사용자 정의 버튼
    center: "title", // 현재 뷰 제목
  };

  //모달 ===================================================================
  /*=====================*/
  // Calendar Select fn.
  /*=====================*/
  // 날짜 선택 시 실행 함수
  // 사용자가 달력에서 날짜 선택 시 모달 보여줌
  // update 버튼 숨기고 시작 끝 날짜 자동 입력
  /*  var calendarSelect = function (info) {
    getModalAddBtnEl.style.display = "block";	// 추가 버튼 표시
    getModalUpdateBtnEl.style.display = "none";	// 수정 버튼 숨김
    myModal.show();								// 모달 창 열기
    getModalStartDateEl.value = info.startStr;	// 선택한 시작일 입력
    getModalEndDateEl.value = info.endStr;		// 선택한 종료일 입력
  };*/

  /*=====================*/
  // Calendar AddEvent fn.
  /*=====================*/
  // 새 일정 등록 버튼 클릭 시 실행
  var calendarAddEvent = function () {
    var currentDate = new Date(); // 현재 날짜 가져오기
    var dd = String(currentDate.getDate()).padStart(2, "0"); // 일(2자리)
    var mm = String(currentDate.getMonth() + 1).padStart(2, "0"); // 월(2자리)
    var yyyy = currentDate.getFullYear(); // 연도
    var combineDate = `${yyyy}-${mm}-${dd}`; // YYYY-MM-DD
    getModalAddBtnEl.style.display = "block"; // 추가 버튼 표시
    getModalUpdateBtnEl.style.display = "none"; // 수정 버튼 숨김
    getModalDeleteBtnEl.style.display = "none"; // 삭제 버튼 숨김
    getModalUpdateCompleteBtnEl.style.display = "none"; // 수정완료 버튼 숨김
    $("#eventModalLabel").text("새 일정 등록"); // 모달 제목 변경

    // 입력창 활성화
    getModalTitleEl.disabled = false;
    getModalCnEl.disabled = false;
    getModalStartDateEl.disabled = false;
    getModalEndDateEl.disabled = false;

    // 전부 활성화
    getModalradios.forEach(function (radio) {
      radio.disabled = false;
    });

    myModal.show(); // 모달 열기
    getModalStartDateEl.value = combineDate; // 시작일 기본값 세팅
    getModalEndDateEl.value = combineDate; // 시작일 기본값 세팅
  };

  /*=====================*/
  // Calender Event Function
  /*=====================*/
  // 캘린더를 클릭하면 실행
  // URL이 있으면 새창 없으면 Modal로 편집
  var calendarEventClick = function (info) {
    var eventObj = info.event; // 클릭 한 이벤트 객체

    if (eventObj.url) {
      // URL이 지정된 이벤트라면
      window.open(eventObj.url); // 새 창 열기
      info.jsEvent.preventDefault(); // 기본 동작(페이지 이동) 방지
    } else {
      // URL이 없는 이벤트라면
      var getModalEventId = eventObj._def.publicId; // 이벤트 ID 가져오기
      var schdulTy = eventObj._def.extendedProps.schdulTy; // 이벤트 타입을 가져옴
	  var empNo = eventObj._def.extendedProps.empNo; // 이벤트를 쓴 사원번호를 가져옴
	  
	  // 해당 값과 같은 value를 가진 라디오 버튼 찾아서 checked
	  var targetRadio = document.querySelector(`input[name="event-type"][value="${schdulTy}"]`);
	  if (targetRadio) {
	    targetRadio.checked = true;
	  }
	  
      getModalTitleEl.value = eventObj.title; // 이벤트 제목을 모달에 입력
      getModalCnEl.value = eventObj._def.extendedProps.schdulCn; // 이벤트 내용을 모달에 입력
      getModalStartDateEl.value = eventObj.startStr.slice(0, 10); // 시작일만 추출
      getModalEndDateEl.value = eventObj.endStr.slice(0, 10); // 종료일만 출력
      getModalUpdateCompleteBtnEl.setAttribute(
        "data-fc-event-public-id",
        getModalEventId
      ); // 수정 완료 버튼에 이벤트 ID 저장
	  getModalDeleteBtnEl.setAttribute(
	    "data-fc-event-public-id",
	    getModalEventId
	  ); // 삭제 버튼에 이벤트 ID 저장

      // 입력창 비활성화
      getModalTitleEl.disabled = true;
      getModalCnEl.disabled = true;
      getModalStartDateEl.disabled = true;
      getModalEndDateEl.disabled = true;

      // 전부 비활성화
      getModalradios.forEach(function (radio) {
        radio.disabled = true;
      });

      getModalAddBtnEl.style.display = "none"; // 추가 버튼 숨김
	
	  // ============================================ 사원번호 확인
	  if(empNo == loginEmpNo){
		getModalUpdateBtnEl.style.display = "block"; // 수정 버튼 표시
		getModalDeleteBtnEl.style.display = "block"; // 삭제 버튼 표시
	  }else{
		getModalUpdateBtnEl.style.display = "none"; // 수정 버튼 숨김
		getModalDeleteBtnEl.style.display = "none"; // 삭제 버튼 숨김
	  }
	  
      getModalUpdateCompleteBtnEl.style.display = "none"; // 수정완료 버튼 숨김

      $("#eventModalLabel").text("일정"); // 모달 제목 변경

      myModal.show(); // 모달 열기
    }
  };

  /*=====================*/
  // Active Calender
  /*=====================*/
  // 캘린더 생성
  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: "dayGridMonth",
    contentHeight: 630, // 내용에 맞게 조정
    // 달력 초기 날짜
    initialDate: `${newDate.getFullYear()}-${getDynamicMonth()}-07`,
    // 달력 상단 헤더 툴바
    headerToolbar: calendarHeaderToolbar,
    // 달력에 표시할 이벤트
    events: calendarEventsList,
    // 사용자가 날짜 선택 시 실행할 함수
    // select: calendarSelect,
    dayMaxEventRows: 3, // 한 칸에 표시되는 최대 이벤트 줄 수
	fixedWeekCount: false,
    // 날짜 선택 취소 시 실행되는 함수
    unselect: function () {
      console.log("unselected");
    },

    // 커스텀 버튼 정의
    customButtons: {
      addEventButton: {
        text: "새 일정 등록", // 버튼 택스트
        click: calendarAddEvent, // 클릭 시 실행할 함수
      },
    },

    // 이벤트 클릭 시 실행할 함수
    eventClick: calendarEventClick,
  });

  /*=====================*/
  // Update Complete Calender Event
  /*=====================*/
  // 모달에서 수정 완료 버튼 클릭 시 실행
  getModalUpdateCompleteBtnEl.addEventListener("click", function () {
    var getPublicID = this.dataset.fcEventPublicId; // 이벤트 id
    var getTitleUpdatedValue = getModalTitleEl.value; // 제목 값
    var getContentUpdatedValue = getModalCnEl.value; // 내용 값
    var setModalStartDateValue = getModalStartDateEl.value; // 시작일 값
    var setModalEndDateValue = getModalEndDateEl.value; // 종료일 값
    var getEvent = calendar.getEventById(getPublicID); // 캘린더에서 이벤트 객체 가져오기
    var calendarEmpNo = getEvent.extendedProps.empNo;
	
	var flag = 0; // 유효성 검사 flag

	// 유효성 검사 =============================
	if(getTitleUpdatedValue == ""){
	  	getModalTitleEl.classList.add('is-invalid');
	    getModalTitleEl.nextElementSibling.textContent = "제목을 입력해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalTitleEl.classList.remove('is-invalid');
		getModalTitleEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}

	if(getContentUpdatedValue == ""){
		getModalCnEl.classList.add('is-invalid');
	    getModalCnEl.nextElementSibling.textContent = "내용을 입력해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalCnEl.classList.remove('is-invalid');
		getModalCnEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}

	if(setModalStartDateValue == ""){
		getModalStartDateEl.classList.add('is-invalid');
	    getModalStartDateEl.nextElementSibling.textContent = "시작일을 선택해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalStartDateEl.classList.remove('is-invalid');
		getModalStartDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}

	if(setModalEndDateValue == "")	{
		getModalEndDateEl.classList.add('is-invalid');
	    getModalEndDateEl.nextElementSibling.textContent = "종료일을 선택해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalEndDateEl.classList.remove('is-invalid');
		getModalEndDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}

	if(setModalStartDateValue != "" && setModalEndDateValue != ""){
		var startDate = new Date(setModalStartDateValue);
		var endDate = new Date(setModalEndDateValue);
		
		if (endDate < startDate){
			getModalEndDateEl.classList.add('is-invalid');
		    getModalEndDateEl.nextElementSibling.textContent = "종료일이 시작일보다 이전일 수 없습니다."; // 메시지 동적 설정
			flag++;
		}else{
			getModalEndDateEl.classList.remove('is-invalid');
			getModalEndDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
		}
	}

	if(flag > 0){
		return;
	}
	
    // data에 값 저장
    const data = {
      schdulNo: getPublicID,
      schdulTitle: getTitleUpdatedValue,
      schdulCn: getContentUpdatedValue,
      startDt: setModalStartDateValue,
      endDt: setModalEndDateValue,
      empNo: calendarEmpNo,
    };

    // DB 수정 ========================
    $.ajax({
      url: "/main/updateEvent",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function (result) {
        if (result === "OK") {
          // 캘린더 수정 ======================
          // 모달에서 입력된 값으로 기존 이벤트 속성 업데이트
          getEvent.setProp("title", getTitleUpdatedValue); // 이벤트 제목 갱신

          // 추가 내용 업데이트 (extendedProps)
          getEvent.setExtendedProp("schdulCn", getContentUpdatedValue);

          // 시작일/종료일 업데이트
          getEvent.setDates(setModalStartDateValue, setModalEndDateValue); // 시작/끝 날짜 갱신

          Swal.fire("알림", "수정에 성공했습니다.", "success");
        } else {
          Swal.fire("알림", "수정에 실패했습니다.", "warning");
        }
      },
    });

    myModal.hide(); // 수정 완료 후 모달 닫기
  });

  /*=====================*/
  // Update Calender Event
  /*=====================*/
  // 모달에서 수정 버튼 클릭 시 실행
  getModalUpdateBtnEl.addEventListener("click", function () {
	
	$("#eventModalLabel").text("일정 수정"); // 모달 제목 변경
	
	// 입력창 활성화
	getModalTitleEl.disabled = false;
	getModalCnEl.disabled = false;
	getModalStartDateEl.disabled = false;
	getModalEndDateEl.disabled = false;
	
	getModalUpdateBtnEl.style.display = "none"; // 수정 버튼 숨김
	getModalDeleteBtnEl.style.display = "none"; // 삭제 버튼 숨김
	getModalUpdateCompleteBtnEl.style.display = "block"; // 수정완료 버튼 표시
  });

  /*=====================*/
  // Delete Calender Event
  /*=====================*/
  // 모달에서 삭제 버튼 클릭 시 실행
  getModalDeleteBtnEl.addEventListener("click", function () {
	
	var getPublicID = this.dataset.fcEventPublicId; // 이벤트 id
	var getEvent = calendar.getEventById(getPublicID); // 캘린더에서 이벤트 객체 가져오기
	
	Swal.fire({
	    title: '일정을 삭제하시겠습니까?',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonText: '네',
	    cancelButtonText: '취소'
	}).then((result) => {
	    if (result.isConfirmed) {
	        $.ajax({
	            url: "/main/deleteEvent",
	            type: "post",
	            contentType: "text/plain;charset=utf-8",
	            data: getPublicID,
	            success: function(result) {
	                if (result === "OK") {
	                    Swal.fire('삭제가 완료 되었습니다!', '', 'success');
						getEvent.remove();
	                    myModal.hide(); // 삭제 완료 후 모달 닫기
	                } else {
	                    Swal.fire('삭제 실패', '', 'error');
	                }
	            },
	            error: function(error, status, thrown) {
	                console.log(error);
	                console.log(status);
	                console.log(thrown);
	                Swal.fire('오류 발생', '일정 삭제 중 오류가 발생했습니다.', 'error');
	            }
	        });
	    }
	});
    
  });

  /*=====================*/
  // Add Calender Event
  /*=====================*/
  // 모달에서 Add 버튼 클릭 시 실행
  getModalAddBtnEl.addEventListener("click", function () {
    // 모달 입력값들 가져오기
    var getTitleValue = getModalTitleEl.value; // 제목
    var getContentvalue = getModalCnEl.value; // 내용
    var setModalStartDateValue = getModalStartDateEl.value; // 시작일
    var setModalEndDateValue = getModalEndDateEl.value; // 종료일
    var getRadioValue = document.querySelector(
      'input[name="event-type"]:checked'
    ).value; // 일정 유형
    var colors = getColorByType(getRadioValue); // 유형에 따른 배경/글자 색
	var flag = 0; // 유효성 검사 flag
	
	// 유효성 검사 =============================
	if(getTitleValue == ""){
	  	getModalTitleEl.classList.add('is-invalid');
	    getModalTitleEl.nextElementSibling.textContent = "제목을 입력해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalTitleEl.classList.remove('is-invalid');
		getModalTitleEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}
	
	if(getContentvalue == ""){
		getModalCnEl.classList.add('is-invalid');
	    getModalCnEl.nextElementSibling.textContent = "내용을 입력해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalCnEl.classList.remove('is-invalid');
		getModalCnEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}
	
	if(setModalStartDateValue == ""){
		getModalStartDateEl.classList.add('is-invalid');
	    getModalStartDateEl.nextElementSibling.textContent = "시작일을 선택해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalStartDateEl.classList.remove('is-invalid');
		getModalStartDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}
	
	if(setModalEndDateValue == "")	{
		getModalEndDateEl.classList.add('is-invalid');
	    getModalEndDateEl.nextElementSibling.textContent = "종료일을 선택해주세요"; // 메시지 동적 설정
		flag++;
	}else{
		getModalEndDateEl.classList.remove('is-invalid');
		getModalEndDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
	}
	
	if(setModalStartDateValue != "" && setModalEndDateValue != ""){
		var startDate = new Date(setModalStartDateValue);
		var endDate = new Date(setModalEndDateValue);
		
		if (endDate < startDate){
			getModalEndDateEl.classList.add('is-invalid');
		    getModalEndDateEl.nextElementSibling.textContent = "종료일이 시작일보다 이전일 수 없습니다."; // 메시지 동적 설정
			flag++;
		}else{
			getModalEndDateEl.classList.remove('is-invalid');
			getModalEndDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
		}
	}
	
	if(flag > 0){
		return;
	}

    // data에 값 저장
    const data = {
      schdulTitle: getTitleValue,
      schdulCn: getContentvalue,
      startDt: setModalStartDateValue,
      endDt: setModalEndDateValue,
      textColor: colors.textColor,
      backgroundColor: colors.bgColor,
      schdulTy: getRadioValue,
    };

    // DB에 저장 후 불러오기
    $.ajax({
      url: "/main/addEvent",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function (v) {
        if (v != null) {
          let endD = v.endDt.substring(0, 10) + "T01:00";
          calendar.addEvent({
            id: v.schdulNo, // 일정번호
            title: v.schdulTitle, // 제목
            start: v.startDt, // 시작일
            end: endD, // 종료일
            backgroundColor: v.backgroundColor, // 배경색
            textColor: v.textColor, // 글자색
            borderColor: "transparent", // 테두리 없애기
            display: "block", // 이벤트 랜더링 유형
            extendedProps: {
              // 사용자 정보
              schdulCn: v.schdulCn, // 설명
              empNo: v.empNo, // 사원번호
              schdulTy: v.schdulTy, // 일정유형
              deptNo: v.deptNo, // 부서번호
              prjctNo: v.prjctNo, // 프로젝트번호
            },
          });

          Swal.fire("알림", "등록에 성공했습니다.", "success");
        } else {
          Swal.fire("알림", "등록에 실패했습니다.", "warning");
        }
      },
    });

    // 추가 완료 후 모달 닫기
    myModal.hide();
  });

  /*=====================*/
  // Calendar Init
  /*=====================*/
  // 캘린더 렌더링 및 모달 초기화
  calendar.render(); // FullCalendar UI 그리기

  // bootstrap Modal 초기화
  var myModal = new bootstrap.Modal(document.getElementById("eventModal"));

  // FullCalendar 커스텀 버튼 DOM 선택
 /* var modalToggle = document.querySelector(".fc-addEventButton-button ");*/

  // 모달이 닫힐 때 실행되는 초기화 로직
  document
    .getElementById("eventModal")
    .addEventListener("hidden.bs.modal", function (event) {
      // 입력값들 초기화
      getModalTitleEl.value = "";
      getModalCnEl.value = "";
      getModalStartDateEl.value = "";
      getModalEndDateEl.value = "";
	  
	  // 입력창 클래스 초기화
		getModalTitleEl.classList.remove('is-invalid');
		getModalTitleEl.nextElementSibling.textContent = ""; // 메시지 초기화
	
		getModalCnEl.classList.remove('is-invalid');
		getModalCnEl.nextElementSibling.textContent = ""; // 메시지 초기화
	
		getModalStartDateEl.classList.remove('is-invalid');
		getModalStartDateEl.nextElementSibling.textContent = ""; // 메시지 초기화
	
		getModalEndDateEl.classList.remove('is-invalid');
		getModalEndDateEl.nextElementSibling.textContent = ""; // 메시지 초기화

      // 입력창 활성화
      getModalTitleEl.disabled = false;
      getModalCnEl.disabled = false;
      getModalStartDateEl.disabled = false;
      getModalEndDateEl.disabled = false;

      // 전부 활성화
      getModalradios.forEach(function (radio) {
        radio.disabled = false;
      });

      // 기본 라디오 버튼 선택
      var defaultRadio = document.getElementById("radioPersonal"); // id 기준
      if (defaultRadio) {
        defaultRadio.checked = true;
      }
    });
}
