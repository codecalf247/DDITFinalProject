function fetchWidget(type) {
    return $.ajax({
        url: "/main/createWidget",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({widgetTy: type})
    });
}

async function renderWidget(type, x, y) {
    console.log('js 실행');
    try {
        const res = await fetchWidget(type); // 여기서 AJAX 완료까지 기다림
		console.log(res)
        if(res != null){
            let widget = res.widgetVO;
			let data = res.data;
			console.log(data);
			let html = "";
            let w = {
                gridX: x,
                gridY: y,
                defaultWidth: widget.defaultWidth,
                defaultHeight: widget.defaultHeight,
				widgetTy : widget.widgetTy,
				gridMasterNo : widget.gridMasterNo
            };
			
            switch (String(type)){
				case "26001":
					html = createCalendarWidget(w);
					break;
				case "26002":
					html = createAttendanceWidget(w, data);
					break;
				case "26003":
					html = createTodoWidget(w, data);
					break;
				case "26004":
					html = createNoticeWidget(w, data);
					break;
				case "26005":
					html = createProjectWidget(w, data);
					break;
				case "26006":
					html = createTaskWidget(w, data);
					break;
				case "26008":
					html = createMoveProjectWidget(w);
					break;
				case "26009":
					html = createMoveCalendarWidget(w);
					break;
				case "26010":
					html = createMoveAttendanceWidget(w);
					break;
				case "26011":
					html = createMoveApprovalWidget(w);
					break;
				case "26012":
					html = createMoveAddressWidget(w);
					break;
				case "26013":
					html = createMoveLibraryWidget(w);
					break;
			}

			return html;
        }
    } catch(err) {
        console.error(err);
        Swal.fire('오류 발생', '위젯 생성 중 오류가 발생했습니다.', 'error');
    }
}

function createMoveProjectWidget(w) {
  return `
  	<div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
  	   gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
  	   <div
  	     class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
  	     <div class="card-body">
  	       <div class="text-center">
  	         <img src="/resources/assets/images/svgs/rocket.svg" width="50" height="50"
  	           class="mb-3" alt="Projects" />
  	         <p class="fw-semibold fs-3 text-info mb-1">Projects</p>
  	         <a href="/project/projectList" class="stretched-link" aria-label="Projects"></a>
  	       </div>
  	     </div>
  	   </div>
  	 </div>
  `;
}

function createMoveCalendarWidget(w) {
  return `
     <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
       gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
       <div
         class="grid-stack-item-content card card-hover bg-danger-subtle shadow-none  ">
         <div class="card-body">
           <div class="text-center">
             <img src="/resources/assets/images/svgs/calendar.svg" width="50" height="50"
               class="mb-3" alt="Calender" />
             <p class="fw-semibold fs-3 text-danger mb-1">Calendar</p>
             <a href="/schedule/list" class="stretched-link" aria-label="Calendar"></a>
           </div>
         </div>
       </div>
     </div>
  `;
}

function createMoveAttendanceWidget(w) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}" gs-h="${w.defaultHeight}" 
  	data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
   <div
     class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
     <div class="card-body">
       <div class="text-center">
         <img src="/resources/assets/images/svgs/assign.svg" width="50" height="50"
           class="mb-3" alt="Attendance" />
         <p class="fw-semibold fs-3 text-info mb-1">Attendance</p>
         <a href="/attendance" class="stretched-link" aria-label="Attendance"></a>
       </div>
     </div>
   </div>
 </div>
  `;
}

function createMoveApprovalWidget(w) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
    gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
    <div
      class="grid-stack-item-content card card-hover bg-warning-subtle shadow-none ">
      <div class="card-body">
        <div class="text-center">
          <img src="/resources/assets/images/svgs/approved.svg" width="50" height="50"
            class="mb-3" alt="Elec. Approval" />
          <p class="fw-semibold fs-3 text-warning mb-1">Elec. Approval</p>
          <a href="/eApproval/dashBoard" class="stretched-link"
            aria-label="Elec. Approval"></a>
        </div>
      </div>
    </div>
  </div>
  `;
}

function createMoveAddressWidget(w) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
    gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}"> 
    <div
      class="grid-stack-item-content card card-hover bg-info-subtle shadow-none ">
      <div class="card-body">
        <div class="text-center">
          <img src="/resources/assets/images/svgs/book.svg" width="50" height="50"
            class="mb-3" alt="Address" />
          <p class="fw-semibold fs-3 text-primary mb-1">Address</p>
          <a href="/address/board" class="stretched-link" aria-label="Address"></a>
        </div>
      </div>
    </div>
  </div>
  `;
}

function createMoveLibraryWidget(w) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
    gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
    <div
      class="card grid-stack-item-content card-hover bg-success-subtle shadow-none ">
      <div class="card-body">
        <div class="text-center">
          <img src="/resources/assets/images/svgs/open-book.svg" width="50" height="50"
            class="mb-3" alt="Library" />
          <p class="fw-semibold fs-3 text-success mb-1">Library</p>
          <a href="/main/alllibrary" class="stretched-link" aria-label="Library"></a>
        </div>
      </div>
    </div>
  </div>
  `;
}


function createCalendarWidget(w) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
    gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
    <div
      class="grid-stack-item-content card text-center shadow-sm ">

      <div class="card-body py-2 app-calendar w-100">
        <div id="calendar" class="fc-compact"></div>
      </div>

    </div>
  </div>
  `;
}

function createAttendanceWidget(w, attdData) {
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
     gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">

     <div class="grid-stack-item-content card shadow-sm ">

       <div class="card-header d-flex justify-content-between align-items-center w-100">
         <span class="badge text-bg-primary">출근 체크</span>
         <button class="btn btn-sm" onclick="location.href='/attendance'">
           <i class="ti ti-plus fs-5"></i>
         </button>
       </div>

       <div class="card-body d-flex align-items-center p-2">

         <div class="me-5 text-center">
           <img
             src="${!attdData.profileFilePath ? '/resources/assets/images/profile/기본프로필.png' : attdData.profileFilePath}"
             class="rounded-circle border border-2" width="80" height="80">
           <div class="mt-1">
		   		<h5 class="mb-1 fw-bold">${attdData.empNm ?? ''}</h5>
		        <p class="text-muted small mb-2">${attdData.deptNm ?? ''}</p>
           </div>
         </div>

         <div class="flex-grow-1">
         
           <div class="d-flex gap-3 mb-4">
             <div class="flex-fill p-2 bg-light rounded-3 d-flex align-items-center">
               <i class="ti ti-clock-hour-9 fs-5 text-secondary"></i>
               <div class="ms-2">
                 <small class="text-muted">출근시간</small>
                 <div class="fw-semibold" id="startTimeDisplay">
                   ${attdData.beginTime ? attdData.beginTime.slice(0,2)+":"+attdData.beginTime.slice(2,4) : '--:--'}
                 </div>
               </div>
             </div>

             <div class="flex-fill p-2 bg-light rounded-3 d-flex align-items-center">
               <i class="ti ti-clock-hour-6 fs-5 text-secondary"></i>
               <div class="ms-2">
                 <small class="text-muted">퇴근시간</small>
                 <div class="fw-semibold" id="endTimeDisplay">
                   ${attdData.endTime ? attdData.endTime.slice(0,2)+":"+attdData.endTime.slice(2,4) : '--:--'}
                 </div>
               </div>
             </div>
           </div>
		   
		   <div class="d-flex justify-content-center gap-3 mb-3">
		           <button class="btn btn-primary px-4" id="startWorkBtn"
		   	 ${attdData.beginTime ? 'disabled' : ''}
		   	 >출근하기</button>
		           <button class="btn btn-danger px-4" id="endWorkBtn"
		   	 ${attdData.beginTime ? '' : 'disabled'}
		   	 >퇴근하기</button>
		   </div>
         </div>
       </div>
     </div>
   </div>
  `;
}

function createTodoWidget(w, todoList) {
  // 리스트 HTML 동적 생성
  let todoItems = "";
  if (todoList && todoList.length > 0) {
    todoList.forEach(todo => {
      const checked = todo.todoCheckYn === "Y" ? "checked" : "";
      todoItems += `
        <li class="list-group-item">
          <div class="form-check flex-grow-1">
            <input class="form-check-input todo-checkbox" type="checkbox" value="${todo.todoNo}"
              id="todo${todo.todoNo}" ${checked}>
            <label class="form-check-label" for="todo${todo.todoNo}">
              ${todo.todoCn}
            </label>
          </div>
        </li>
      `;
    });
  } 
  // 위젯 전체 HTML
  return `
  <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
    gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
    <div class="grid-stack-item-content card shadow-sm ">

      <div class="card-header d-flex justify-content-between align-items-center w-100">
        <span class="badge text-bg-primary">To Do List</span>
        <div>
          <button class="btn btn-sm btn-primary" id="todoListAddBtn">
            <i class="ti ti-edit fs-5"></i>
          </button>
          <button class="btn btn-sm btn-danger" id="todoListDeleteBtn">
            <i class="ti ti-trash fs-5"></i>
          </button>
        </div>
      </div>

      <div class="card-body w-100 text-start p-2">
        <ul class="list-group list-group-flush w-100 border border-1 rounded" id="todoList">
          ${todoItems}
        </ul>
      </div>

    </div>
  </div>
  `;
}
function createNoticeWidget(w, noticeList) {
  let rows = "";

  if (noticeList && noticeList.length > 0) {
    noticeList.forEach(n => {
      rows += `
        <tr data-id="${n.boardNo}" class="cursor-pointer">
          <td class="text-truncate">
            ${n.imprtncTagYn ? '<span class="badge rounded-pill text-bg-danger">중요</span>&nbsp;' : ''}
            ${n.boardTitle}
          </td>
          <td class="text-center">${n.boardRegDt.substring(0, 10)}</td>
        </tr>
      `;
    });
  } else {
    rows = `<tr><td colspan="2" class="text-center text-muted">공지사항이 없습니다</td></tr>`;
  }

  return `
    <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}"
      gs-h="${w.defaultHeight}" data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">

      <div class="grid-stack-item-content card shadow-sm ">

        <div class="card-header d-flex justify-content-between align-items-center w-100">
          <span class="badge text-bg-primary">공지사항</span>
          <button class="btn btn-sm" onclick="location.href='/boards/noticelist'">
            <i class="ti ti-plus fs-5"></i>
          </button>
        </div>

        <div class="card-body w-100 text-start p-2">
          <table class="table table-sm table-hover align-middle mb-0 notice-table" style="table-layout: fixed;">
            <thead class="bg-body-tertiary text-center">
              <tr>
                <th>제목</th>
                <th>날짜</th>
              </tr>
            </thead>
            <tbody>
              ${rows}
            </tbody>
          </table>
        </div>

      </div>
    </div>
  `;
}

function createProjectWidget(w, projectList) {
  let cardsHtml = "";

  if (!projectList || projectList.length === 0) {
    cardsHtml = `
      <div class="card text-center mb-0">
        <div class="card-header">
          <span class="fs-5 fw-semibold">프로젝트</span>
        </div>
        <div class="card-body p-3">
          <h5 class="card-title">진행중인 프로젝트가 없습니다</h5>
          <p class="card-text">새로운 프로젝트를 시작해 보세요.</p>
          <a href="/project/projectList" class="btn btn-primary">프로젝트 이동</a>
        </div>
      </div>
    `;
  } else {
    projectList.forEach(project => {
      cardsHtml += `
        <div class="card text-center mb-0">
          <div class="card-header">
            <span class="fs-5 fw-semibold">${project.sptNm}</span>
          </div>
          <div class="card-body p-3">
            <h5 class="card-title">${project.sptAddr}</h5>
            <p class="card-text">
              ${project.prjctStartYmd} ~ ${project.prjctDdlnYmd}
            </p>
            <a href="/project/dashboard?prjctNo=${project.prjctNo}" class="btn btn-primary">페이지로 이동</a>
          </div>
        </div>
      `;
    });
  }

  return `
    <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}" gs-h="${w.defaultHeight}" 
	data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
      <div class="grid-stack-item-content card shadow-sm ">
        <div class="card-header d-flex justify-content-between align-items-center w-100">
          <span class="badge text-bg-primary">진행중인 프로젝트</span>
          <div>
            <button id="prevCard" class="btn btn-sm">
              <i class="ti ti-chevron-left fs-5"></i>
            </button>
            <button id="nextCard" class="btn btn-sm">
              <i class="ti ti-chevron-right fs-5"></i>
            </button>
            <button class="btn btn-sm" onclick="location.href='/project/projectList'">
              <i class="ti ti-plus fs-5"></i>
            </button>
          </div>
        </div>
        <div class="card-body w-100 text-start p-2">
          <div id="cardContainer">
            ${cardsHtml}
          </div>
        </div>
      </div>
    </div>
  `;
}

function createTaskWidget(w, taskList) {
  let cardsHtml = "";

  if (!taskList || taskList.length === 0) {
    cardsHtml = `
      <div class="card text-center mb-0">
        <div class="card-header">
          <span class="fs-5 fw-semibold">진행중인 일감이 없습니다</span>
        </div>
        <div class="card-body p-3">
          <p class="card-text">새로운 일감을 등록해 보세요.</p>
        </div>
      </div>
    `;
  } else {
    taskList.forEach(task => {
      let progressBarColor = "bg-warning";
      if (task.taskProgrs <= 30) progressBarColor = "bg-danger";
      else if (task.taskProgrs >= 70) progressBarColor = "bg-success";

      cardsHtml += `
        <div class="card text-center mb-0">
          <div class="card-header">
            ${task.emrgncyYn === 'Y' ? '<span class="badge rounded-pill bg-danger-subtle text-danger">긴급</span>' : ''}
            <span class="fs-5 fw-semibold">${task.taskTitle}</span>
          </div>
          <div class="card-body p-3">
            <h5 class="card-title">${task.procsTy}</h5>
            <p class="card-text">${task.taskBeginYmd} ~ ${task.taskDdlnYmd}</p>
            <span>진행률</span>
            <div class="progress" style="height: 15px">
              <div class="progress-bar ${progressBarColor}" style="width: ${task.taskProgrs}%" role="progressbar">
                ${task.taskProgrs}%
              </div>
            </div>
          </div>
        </div>
      `;
    });
  }

  return `
    <div class="grid-stack-item" gs-x="${w.gridX}" gs-y="${w.gridY}" gs-w="${w.defaultWidth}" gs-h="${w.defaultHeight}"
		data-widget-type="${w.widgetTy}" data-grid-master-no="${w.gridMasterNo}">
      <div class="grid-stack-item-content card shadow-sm ">
        <div class="card-header d-flex justify-content-between align-items-center w-100">
          <span class="badge text-bg-primary">나의 일감</span>
          <div>
            <button id="prevTask" class="btn btn-sm">
              <i class="ti ti-chevron-left fs-5"></i>
            </button>
            <button id="nextTask" class="btn btn-sm">
              <i class="ti ti-chevron-right fs-5"></i>
            </button>
          </div>
        </div>
        <div class="card-body w-100 text-start p-2">
          <div id="taskContainer">
            ${cardsHtml}
          </div>
        </div>
      </div>
    </div>
  `;
}

