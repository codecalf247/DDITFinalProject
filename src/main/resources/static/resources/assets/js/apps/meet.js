/*========Calender Js (FINAL)=========*/

document.addEventListener("DOMContentLoaded", function () {
  /* utils */
  var newDate = new Date();
  function getDynamicMonth() {
    var m = newDate.getMonth() + 1;
    return m < 10 ? `0${m}` : `${m}`;
  }

  /* modal elems */
  var getModalTitleEl = document.querySelector("#event-title");
  var getModalStartDateEl = document.querySelector("#event-start-date");
  var getModalEndDateEl = document.querySelector("#event-end-date");
  var getModalAddBtnEl = document.querySelector(".btn-add-event");
  var getModalUpdateBtnEl = document.querySelector(".btn-update-event");

  var calendarsEvents = { Danger:"danger", Success:"success", Primary:"primary", Warning:"warning" };

  /* calendar data */
  var calendarEl = document.querySelector("#calendar");
  var isNarrow = () => window.innerWidth <= 1199;

  var calendarHeaderToolbar = {
    left: "prev next addEventButton",
    center: "title",
    right: "dayGridMonth,timeGridWeek,timeGridDay",
  };

  var calendarEventsList = [
    { id: 1, title: "Event Conf.", start: `${newDate.getFullYear()}-${getDynamicMonth()}-01`, extendedProps:{calendar:"Danger"} },
    { id: 2, title: "Seminar #4", start: `${newDate.getFullYear()}-${getDynamicMonth()}-07`, end: `${newDate.getFullYear()}-${getDynamicMonth()}-10`, extendedProps:{calendar:"Success"} },
    { groupId:"999", id: 3, title: "Meeting #5", start: `${newDate.getFullYear()}-${getDynamicMonth()}-09T16:00:00`, extendedProps:{calendar:"Primary"} },
    { groupId:"999", id: 4, title: "Submission #1", start: `${newDate.getFullYear()}-${getDynamicMonth()}-16T16:00:00`, extendedProps:{calendar:"Warning"} },
    { id: 5, title: "Seminar #6", start: `${newDate.getFullYear()}-${getDynamicMonth()}-11`, end: `${newDate.getFullYear()}-${getDynamicMonth()}-13`, extendedProps:{calendar:"Danger"} },
    { id: 6, title: "Meeting 3", start: `${newDate.getFullYear()}-${getDynamicMonth()}-12T10:30:00`, end: `${newDate.getFullYear()}-${getDynamicMonth()}-12T12:30:00`, extendedProps:{calendar:"Success"} },
    { id: 7, title: "Meetup #", start: `${newDate.getFullYear()}-${getDynamicMonth()}-12T12:00:00`, extendedProps:{calendar:"Primary"} },
    { id: 8, title: "Submission", start: `${newDate.getFullYear()}-${getDynamicMonth()}-12T14:30:00`, extendedProps:{calendar:"Warning"} },
    { id: 9, title: "Attend event", start: `${newDate.getFullYear()}-${getDynamicMonth()}-13T07:00:00`, extendedProps:{calendar:"Success"} },
    { id:10, title: "Project submission #2", start: `${newDate.getFullYear()}-${getDynamicMonth()}-28`, extendedProps:{calendar:"Primary"} },
  ];

  /* helpers: 마지막 주(전부 다음달)만 감추기 */
  function hideTrailingNonCurrentRow(calendar) {
    // 모든 행 보이도록 리셋
    calendarEl.querySelectorAll(".fc-daygrid-body tr").forEach(tr => tr.style.display = "");

    var view = calendar.view;
    var currentMonth = view.currentStart.getMonth(); // 현재 월
    var rows = Array.from(calendarEl.querySelectorAll(".fc-daygrid-body tr"));
    var lastRowToHide = null;

    rows.forEach(tr => {
      var tds = Array.from(tr.querySelectorAll("td[data-date]"));
      if (tds.length === 0) return;
      var allNextMonth = tds.every(td => (new Date(td.dataset.date)).getMonth() !== currentMonth);
      if (allNextMonth) lastRowToHide = tr; // 마지막으로 발견된 '전부 다른 달' 행을 후보로
    });

    if (lastRowToHide) lastRowToHide.style.display = "none";
  }

  /* select & add/edit handlers */
  var calendarSelect = function (info) {
    getModalAddBtnEl.style.display = "block";
    getModalUpdateBtnEl.style.display = "none";
    myModal.show();
    getModalStartDateEl.value = info.startStr;
    getModalEndDateEl.value = info.endStr;
  };

  var calendarAddEvent = function () {
    var d = new Date();
    var combineDate = `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,"0")}-${String(d.getDate()).padStart(2,"0")}T00:00:00`;
    getModalAddBtnEl.style.display = "block";
    getModalUpdateBtnEl.style.display = "none";
    myModal.show();
    getModalStartDateEl.value = combineDate;
  };

  var calendarEventClick = function (info) {
    var e = info.event;
    if (e.url) {
      window.open(e.url);
      info.jsEvent.preventDefault();
      return;
    }
    var id = e._def.publicId;
    var level = e._def.extendedProps["calendar"];
    var radio = document.querySelector(`input[value="${level}"]`);
    getModalTitleEl.value = e.title;
    getModalStartDateEl.value = e.startStr.slice(0,10);
    getModalEndDateEl.value = e.endStr ? e.endStr.slice(0,10) : "";
    if (radio) radio.checked = true;
    getModalUpdateBtnEl.setAttribute("data-fc-event-public-id", id);
    getModalAddBtnEl.style.display = "none";
    getModalUpdateBtnEl.style.display = "block";
    myModal.show();
  };

  
  
  /* init calendar */
  var calendar = new FullCalendar.Calendar(calendarEl, {
    selectable: true,

    // 높이 살짝 증가
    height: isNarrow() ? 520 : 980,
    expandRows: true,
    dayMaxEventRows: 5,

    // 앞쪽 이전달 날짜는 살려두고(투명 처리 가능), 마지막 주만 숨길 것
    fixedWeekCount: false,
    showNonCurrentDates: true,

    initialView: isNarrow() ? "listWeek" : "dayGridMonth",
    initialDate: `${newDate.getFullYear()}-${getDynamicMonth()}-07`,
    headerToolbar: calendarHeaderToolbar,
    firstDay: 0,

    events: calendarEventsList,
    select: calendarSelect,

    dayCellClassNames: function (arg) {
      var dow = arg.date.getDay();
      if (dow === 6) return ["fc-sat"];
      if (dow === 0) return ["fc-sun"];
      return [];
    },
    dayHeaderClassNames: function (arg) {
      var dow = arg.date.getDay();
      if (dow === 6) return ["fc-sat"];
      if (dow === 0) return ["fc-sun"];
      return [];
    },

    customButtons: {
      addEventButton: { text: "Add Event", click: calendarAddEvent },
    },

    eventClassNames: function ({ event }) {
      const color = calendarsEvents[event._def.extendedProps.calendar];
      return ["event-fc-color fc-bg-" + color];
    },

    eventClick: calendarEventClick,

    // 뷰가 바뀔 때마다 맨 아래 '전부 다음달' 주만 감추기
    datesSet: function () {
      hideTrailingNonCurrentRow(calendar);
    },

    windowResize: function () {
      calendar.setOption("height", isNarrow() ? 720 : 980);
      calendar.changeView(isNarrow() ? "listWeek" : "dayGridMonth");
      hideTrailingNonCurrentRow(calendar);
    },
  });

  /* render & modal wiring */
  calendar.render();
  hideTrailingNonCurrentRow(calendar);

  var myModal = new bootstrap.Modal(document.getElementById("eventModal"));

  getModalUpdateBtnEl.addEventListener("click", function () {
    var id = this.dataset.fcEventPublicId;
    var title = getModalTitleEl.value;
    var startV = getModalStartDateEl.value;
    var endV = getModalEndDateEl.value;
    var ev = calendar.getEventById(id);
    var lvlRadio = document.querySelector('input[name="event-level"]:checked');
    var lvl = lvlRadio ? lvlRadio.value : "";
    if (ev) {
      ev.setProp("title", title);
      ev.setDates(startV, endV || null);
      ev.setExtendedProp("calendar", lvl);
    }
    myModal.hide();
  });

  getModalAddBtnEl.addEventListener("click", function () {
    var lvlRadio = document.querySelector('input[name="event-level"]:checked');
    calendar.addEvent({
      id: String(Date.now()),
      title: getModalTitleEl.value,
      start: getModalStartDateEl.value,
      end: getModalEndDateEl.value || null,
      allDay: true,
      extendedProps: { calendar: lvlRadio ? lvlRadio.value : "" },
    });
    myModal.hide();
  });

  document.getElementById("eventModal").addEventListener("hidden.bs.modal", function () {
    getModalTitleEl.value = "";
    getModalStartDateEl.value = "";
    getModalEndDateEl.value = "";
    var checked = document.querySelector('input[name="event-level"]:checked');
    if (checked) checked.checked = false;
  });
});
