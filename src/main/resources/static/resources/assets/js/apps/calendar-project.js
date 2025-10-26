/*======== Calendar Js (종료일 포함 보정 버전) =========*/
/*=====================================================*/

document.addEventListener("DOMContentLoaded", function () {
  // 날짜 기본값 계산용
  var newDate = new Date();
  function getDynamicMonth() {
    let getMonthValue = newDate.getMonth();
    let _getUpdatedMonthValue = getMonthValue + 1;
    return _getUpdatedMonthValue < 10
      ? `0${_getUpdatedMonthValue}`
      : `${_getUpdatedMonthValue}`;
  }

  // ===== 날짜 유틸 =====
  function toISODate(date) {
    // Date -> "YYYY-MM-DD"
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, "0");
    const d = String(date.getDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
  }
  function parseDate(str) {
    // "YYYY-MM-DD" -> Date (local)
    const [y, m, d] = (str || "").split("-").map(Number);
    if (!y || !m || !d) return null;
    return new Date(y, m - 1, d, 0, 0, 0, 0);
  }
  function addDays(date, days) {
    const d = new Date(date.getTime());
    d.setDate(d.getDate() + days);
    return d;
  }

  // 모달 요소
  var getModalTitleEl = document.querySelector("#event-title");
  var getModalStartDateEl = document.querySelector("#event-start-date");
  var getModalEndDateEl = document.querySelector("#event-end-date");
  var getModalAddBtnEl = document.querySelector(".btn-add-event");
  var getModalUpdateBtnEl = document.querySelector(".btn-update-event");
  var myModal = new bootstrap.Modal(document.getElementById("eventModal"));

  // hidden input (색상 키, hex)
  var getColorKeyEl = document.querySelector("#event-color-key");
  var getColorHexEl = document.querySelector("#event-color-hex");

  // 가독성 있는 텍스트 색상 계산
  function textColorFor(hex) {
    if (!hex) return "#000";
    var c = hex.replace("#", "");
    var r = parseInt(c.substr(0, 2), 16),
      g = parseInt(c.substr(2, 2), 16),
      b = parseInt(c.substr(4, 2), 16);
    var yiq = (r * 299 + g * 587 + b * 114) / 1000;
    return yiq >= 150 ? "#000" : "#fff";
  }

  // Calendar 기본 옵션
  var calendarEl = document.querySelector("#calendar");
  var checkWidowWidth = function () {
    return window.innerWidth <= 1199;
  };

  var calendarHeaderToolbar = {
    left: "prev next addEventButton",
    center: "title",
    right: "dayGridMonth,timeGridWeek,timeGridDay",
  };

  var calendarEventsList = []; // 초기 이벤트 리스트 (추후 서버연동 가능)

  // 일정 선택 시 (드래그로 날짜범위 선택)
  // FullCalendar는 end가 '미포함'으로 들어오므로, 모달의 마감일엔 -1일 보정해서 표시
  var calendarSelect = function (info) {
    getModalAddBtnEl.style.display = "block";
    getModalUpdateBtnEl.style.display = "none";
    myModal.show();

    // info.startStr / info.endStr는 ISO 문자열. 날짜 입력칸엔 "YYYY-MM-DD"만 세팅
    const startDateOnly = info.startStr.substring(0, 10);
    let endDateOnly = "";
    if (info.end) {
      // exclusive end - 1일
      endDateOnly = toISODate(addDays(info.end, -1));
    }
    getModalStartDateEl.value = startDateOnly;
    getModalEndDateEl.value = endDateOnly;
  };

  // 툴바의 Add Event 버튼 클릭 시
  var calendarAddEvent = function () {
    var currentDate = new Date();
    var dd = String(currentDate.getDate()).padStart(2, "0");
    var mm = String(currentDate.getMonth() + 1).padStart(2, "0");
    var yyyy = currentDate.getFullYear();
    var combineDate = `${yyyy}-${mm}-${dd}`; // date input 용

    getModalAddBtnEl.style.display = "block";
    getModalUpdateBtnEl.style.display = "none";
    myModal.show();
    getModalStartDateEl.value = combineDate;
    getModalEndDateEl.value = ""; // 기본 공백
  };

  // 일정 클릭 시 (편집 모드로 모달 열기)
  // 저장된 이벤트는 allDay exclusive end를 사용하므로, 모달에는 -1일 보정하여 보여줌
  var calendarEventClick = function (info) {
    var eventObj = info.event;

    getModalTitleEl.value = eventObj.title || "";

    // start/end를 date input에 맞게 변환
    const startStr = eventObj.start ? toISODate(eventObj.start) : "";
    let endStr = "";
    if (eventObj.end) {
      // exclusive end - 1일
      endStr = toISODate(addDays(eventObj.end, -1));
    }
    getModalStartDateEl.value = startStr;
    getModalEndDateEl.value = endStr;

    // 색상 키 복원
    if (eventObj.extendedProps && eventObj.extendedProps.colorKey) {
      getColorKeyEl.value = eventObj.extendedProps.colorKey;
      getColorHexEl.value =
        eventObj.backgroundColor || getColorHexEl.value || "#0d6efd";
    }

    getModalAddBtnEl.style.display = "none";
    getModalUpdateBtnEl.style.display = "block";
    getModalUpdateBtnEl.setAttribute("data-fc-event-id", eventObj.id);

    myModal.show();
  };

  // Calendar 객체 생성
  var calendar = new FullCalendar.Calendar(calendarEl, {
    selectable: true,
    height: checkWidowWidth() ? 900 : 1052,
    initialView: checkWidowWidth() ? "listWeek" : "dayGridMonth",
    initialDate: `${newDate.getFullYear()}-${getDynamicMonth()}-07`,
    headerToolbar: calendarHeaderToolbar,
    events: calendarEventsList,
    select: calendarSelect,
    unselect: function () {
      console.log("unselected");
    },
    customButtons: {
      addEventButton: {
        text: "Add Event",
        click: calendarAddEvent,
      },
    },
    eventClick: calendarEventClick,
    windowResize: function () {
      if (checkWidowWidth()) {
        calendar.changeView("listWeek");
        calendar.setOption("height", 900);
      } else {
        calendar.changeView("dayGridMonth");
        calendar.setOption("height", 1052);
      }
    },
  });

  // Update Event (모달 → 캘린더)
  // 폼의 마감일을 '포함'으로 받아서, FullCalendar에는 +1일(00:00) exclusive로 세팅
  getModalUpdateBtnEl.addEventListener("click", function () {
    var eventId = this.dataset.fcEventId;
    var getEvent = calendar.getEventById(eventId);
    if (!getEvent) return;

    var title = getModalTitleEl.value.trim();
    var startDateStr = getModalStartDateEl.value; // "YYYY-MM-DD"
    var endDateStr = getModalEndDateEl.value || ""; // "YYYY-MM-DD" or ""

    var colorKey = getColorKeyEl.value;
    var colorHex = getColorHexEl.value;
    var txtCol = textColorFor(colorHex);

    // 보정: allDay exclusive end = (마감일 + 1일)
    const start = startDateStr || null;
    let fcEnd = null;
    if (endDateStr) {
      const endInclusive = parseDate(endDateStr);
      fcEnd = toISODate(addDays(endInclusive, 1)); // +1일 (exclusive)
    }

    getEvent.setProp("title", title);
    getEvent.setDates(start, fcEnd); // FullCalendar에 exclusive로 반영
    getEvent.setProp("allDay", true);
    getEvent.setProp("backgroundColor", colorHex);
    getEvent.setProp("borderColor", colorHex);
    getEvent.setProp("textColor", txtCol);
    getEvent.setExtendedProp("colorKey", colorKey);

    myModal.hide();
  });

  // Add Event (모달 → 캘린더)
  // 폼의 마감일을 '포함'으로 받아서, FullCalendar에는 +1일(00:00) exclusive로 세팅
  getModalAddBtnEl.addEventListener("click", function () {
    var title = getModalTitleEl.value.trim();
    var startDateStr = getModalStartDateEl.value; // "YYYY-MM-DD"
    var endDateStr = getModalEndDateEl.value || ""; // "YYYY-MM-DD" or ""
    var colorKey = getColorKeyEl.value;
    var colorHex = getColorHexEl.value;
    var txtCol = textColorFor(colorHex);

    if (!title || !startDateStr) {
      alert("제목과 시작 날짜를 입력하세요.");
      return;
    }

    // 보정: allDay exclusive end = (마감일 + 1일)
    const start = startDateStr;
    let fcEnd = null;
    if (endDateStr) {
      const endInclusive = parseDate(endDateStr);
      fcEnd = toISODate(addDays(endInclusive, 1)); // +1일 (exclusive)
    }

    calendar.addEvent({
      id: String(Date.now()), // 임시 ID
      title: title,
      start: start,
      end: fcEnd ,            // exclusive end
      allDay: true,
      backgroundColor: colorHex,
      borderColor: colorHex,
      textColor: txtCol,
      extendedProps: { colorKey: colorKey },
    });

    myModal.hide();
  });

  // Calendar 실행
  calendar.render();

  // 모달 닫힐 때 초기화
  document
    .getElementById("eventModal")
    .addEventListener("hidden.bs.modal", function () {
      getModalTitleEl.value = "";
      getModalStartDateEl.value = "";
      getModalEndDateEl.value = "";
      getColorKeyEl.value = "primary";
      getColorHexEl.value = "#0d6efd";
    });

  // calendar 전역 노출
  window.calendar = calendar;
});
