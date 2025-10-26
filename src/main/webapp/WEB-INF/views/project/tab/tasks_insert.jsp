<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${status eq 'u' ? '일감 수정' : '일감 등록'}</title>
  <%-- ✅ head 리소스는 여기에서만 include --%>
  <%@ include file="/module/headPart.jsp" %>
  <style>
    .form-section-title{font-weight:600;font-size:.95rem;text-transform:uppercase;color:var(--bs-secondary-color);margin-bottom:.75rem;}
    .progress-lg{height:26px;}
  </style>
</head>

<body>
  <%-- ✅ header/aside 는 body 시작 직후 1회만 --%>
  <%@ include file="/module/header.jsp" %>
  <%@ include file="/module/aside.jsp" %>

  <div class="body-wrapper">
    <div class="container-fluid mt-4">
      <div class="container">

        <%-- ✅ 여기 카드가 이제 정상 출력됨 --%>
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
                      <a class="text-muted text-decoration-none" href="/project/dashboard?prjctNo=${prjctNo}">Project</a>
                    </li>
                    <li class="breadcrumb-item">
                      <%-- ✅ 이중 슬래시 제거 --%>
                      <a class="text-muted text-decoration-none" href="/project/tasks?prjctNo=${prjctNo}">Tasks</a>
                    </li>
                    <li class="breadcrumb-item" aria-current="page">Tasks Insert</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </div>



    <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

    <form id="taskForm"
          method="post"
          action="${pageContext.request.contextPath}/project/tasks/${status eq 'u' ? 'update' : 'insert'}"
          novalidate
          enctype="multipart/form-data"> 
      <input type="hidden" name="prjctNo" value="${prjctNo}">
      <c:if test="${status eq 'u'}">
        <input type="hidden" name="taskNo" value="${task.taskNo}"/>
      </c:if>

      <input type="hidden" id="taskProgrs" name="taskProgrs"
             value="${status eq 'u' ? task.taskProgrs : 30}">

      <div class="card">
        <div class="card-body">

         <div class="row g-3 align-items-end mb-3">
			  <div class="col-md-9">
			    <label for="taskTitle" class="form-label mb-0">
			      제목 <span class="text-danger">*</span>
			    </label>
			    <input type="text"
			           class="form-control"
			           id="taskTitle"
			           name="taskTitle"
			           value="${status eq 'u' ? task.taskTitle : ''}"
			           required />
			    <div class="invalid-feedback">제목을 입력해 주세요.</div>
			  </div>
			
			  <div class="col-md-3 d-flex justify-content-md-end align-items-center">
			    <div class="form-check form-switch m-0">
			      <input class="form-check-input danger"
			             type="checkbox"
			             id="emrgncyYn"
			             name="emrgncyYn"
			             value="Y"
			             <c:if test="${status eq 'u' && task.emrgncyYn eq 'Y'}">checked</c:if> />
			      <label class="form-check-label" for="emrgncyYn">긴급</label>
			    </div>
			  </div>
			</div>

          <div class="mb-3">
            <label for="taskCn" class="form-label">설명</label>
            <textarea class="form-control" id="taskCn" name="taskCn" rows="4" required>${status eq 'u' ? task.taskCn : ''}</textarea>
          </div>

          <div class="mb-3">
            <label for="taskCharger" class="form-label">담당자</label>
            <select id="taskCharger" name="taskCharger" class="form-select" required>
              <c:forEach var="p" items="${participants}">
                <option value="${p.empNo}"
                  <c:if test="${status eq 'u' && task.taskCharger eq p.empNo}">selected</c:if>>
                  ${p.empNm}
                  <c:if test="${not empty p.jbgdNm}">(${p.jbgdNm})</c:if>
                  <c:if test="${not empty p.deptNm}"> - ${p.deptNm}</c:if>
                </option>
              </c:forEach>
            </select>
          </div>

         <div class="mb-3">
            <label for="procsTy" class="form-label">유형 <span class="text-danger">*</span></label>
            <select id="procsTy" name="procsTy" class="form-select" required>
              <c:set var="curType" value="${status eq 'u' ? task.procsTy : ''}"/>
              <option value="">선택하세요</option>
              <c:forEach var="t" items="${fn:split('철거,설비,목공,전기,타일,도배,필름,도장,가구,마감', ',')}">
                <option value="${t}" <c:if test="${curType eq t}">selected</c:if>>${t}</option>
              </c:forEach>
            </select>
            <div class="invalid-feedback">유형을 선택해 주세요.</div>
          </div>

<div class="row g-3">
  <div class="col-md-6">
    <label for="taskBeginYmd" class="form-label">시작일 <span class="text-danger">*</span></label>
    <input type="date"
           id="taskBeginYmd"
           name="taskBeginYmd"
           class="form-control"
           required
           value="${status eq 'u' ? task.taskBeginYmd : ''}">
    <div class="invalid-feedback">시작일을 선택해 주세요.</div>
  </div>

  <div class="col-md-6">
    <label for="taskDdlnYmd" class="form-label">마감일 <span class="text-danger">*</span></label>
    <input type="date"
           id="taskDdlnYmd"
           name="taskDdlnYmd"
           class="form-control"
           required
           value="${status eq 'u' ? task.taskDdlnYmd : ''}">
    <div class="invalid-feedback">마감일을 선택해 주세요.</div>
  </div>
</div>
          
          <div class="mb-3">
			    <label for="files" class="form-label">첨부파일</label>
			    
			    <%-- 💡 기존 파일 목록 표시 및 삭제 버튼 추가 --%>
			    <c:if test="${status eq 'u' and not empty files}">
			      <div class="list-group mb-2" id="existingFiles">
			        <c:forEach var="f" items="${files}">
			          <div class="list-group-item d-flex justify-content-between align-items-center"
			               data-file-no="${f.fileNo}"
			               data-file-name="${f.originalNm}">
			            <span class="d-inline-flex align-items-center gap-2">
			              <i class="ti ti-file-text"></i>
			              <span class="text-truncate" style="max-width: 420px;">
			                <c:out value="${f.originalNm}"/> (<c:out value="${f.fileFancysize}"/>)
			              </span>
			            </span>
			            <button type="button" class="btn-close js-delete-file" aria-label="파일 삭제"></button>
			          </div>
			        </c:forEach>
			      </div>
			      <small class="text-muted d-block mb-1">파일 삭제는 즉시 반영되며, **새 파일을 추가**하려면 아래 버튼을 사용하세요.</small>
			    </c:if>
			    
			    <%-- 새 파일 등록 input --%>
			    <input class="form-control" type="file" id="files" name="files" multiple>
			</div>
			
			<div class="col-12 mb-3">
            <div class="card mb-0">
              <div class="card-body">
                <div class="form-section-title">진행률</div>
                <div class="d-flex align-items-center gap-2 mb-2">
                  <button type="button" class="btn btn-outline-secondary btn-sm" id="btnDec">-10%</button>
                  <div class="progress flex-grow-1 progress-lg">
                    <div class="progress-bar bg-success" id="progressBar"
                         role="progressbar" style="width: 30%;" aria-valuenow="30"
                         aria-valuemin="0" aria-valuemax="100">30%</div>
                  </div>
                  <button type="button" class="btn btn-outline-secondary btn-sm" id="btnInc">+10%</button>
                </div>
                <small class="text-muted">상태를 바꾸면 진행률이 자동으로 맞춰집니다.</small>
              </div>
            </div>
          </div>

        </div>
			
			
        <div class="card-footer text-end">
          <button type="button" class="btn btn-warning me-2" id="fillDummyData">
            더미데이터
          </button>
          <button type="submit" class="btn btn-primary">${status eq 'u' ? '수정' : '등록'}</button>
          <a href="${pageContext.request.contextPath}/project/tasks?prjctNo=${prjctNo}" class="btn btn-secondary">취소</a>
        </div>
      </div>
    </form>

  </div>
</div>
</div>

<%@ include file="/module/footerPart.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<c:if test="${not empty message}">
  <div id="flash-message" class="d-none"><c:out value="${message}"/></div>
</c:if>
<c:if test="${not empty error}">
  <div id="flash-error" class="d-none"><c:out value="${error}"/></div>
</c:if>

<script>
$(function(){
	  const $ctx = "${pageContext.request.contextPath}";
	  
	  // 진행률 UI 로직
	  const $hidden = $("#taskProgrs");
	  const $bar    = $("#progressBar");
	  const $decBtn = $("#btnDec");
	  const $incBtn = $("#btnInc");
	  // 💡 수정 모드 초기값 설정: Controller에서 받은 task.taskProgrs 값 사용
	  const initialProgress = parseInt($hidden.val() || "30", 10); 


	  const clamp = (v) => {
		    v = parseInt(v || 0, 10);
		    if (isNaN(v)) v = 0;
		    return Math.max(0, Math.min(100, v));
	  };
	  
	  const applyBarStyle = (val) => {
		    // 기존 컬러 클래스/스타일 제거
		    $bar.removeClass("bg-success bg-secondary bg-light")
		        .css({ backgroundColor: "", color: "" });

		    if (val === 100) {
		      $bar.addClass("bg-success");
		    } else if (val === 90) {
		      // 90%: 커스텀 라일락
		      $bar.css({ backgroundColor: "#E3C8FA", color: "#000" });
		    } else if (val === 0) {
		      $bar.addClass("bg-light").css({ color: "#000" });
		    } else {
		      $bar.addClass("bg-secondary");
		    }
	  };

	  const setProgress = (v) => {
	    const val = clamp(v);
	    $hidden.val(val);
	    $bar.css("width", val + "%")
	        .attr("aria-valuenow", val)
	        .text(val + "%");
	    applyBarStyle(val);
	  };
	  
	  // 💡 초기 세팅을 수정 모드 초기값으로 설정
	  setProgress(initialProgress); 
	  
	  // 증감 버튼
	  $decBtn.on("click", function(){ setProgress(parseInt($hidden.val() || 0, 10) - 10); });
	  $incBtn.on("click", function(){ setProgress(parseInt($hidden.val() || 0, 10) + 10); });
	  $hidden.on("input change", function(){ setProgress($(this).val()); });
	  
	  
	  
	  
	  
	  // 💡 수정 모드 파일 삭제 로직 (AJAX)
	  $(document).on("click", ".js-delete-file", function(){
	    const $item = $(this).closest(".list-group-item");
	    const fileNo = $item.data("file-no");
	    const fileName = $item.data("file-name");

	    if (!confirm('파일 "'+fileName+'"을(를) 삭제하시겠습니까?')) return;

	    // AJAX로 즉시 삭제 (Controller의 delete-files 엔드포인트 사용)
	    $.ajax({
	      url: $ctx + "/project/photos/delete-files", // ProjectPhotosController의 엔드포인트 재사용
	      type: "POST",
	      data: { "fileNos[]": [fileNo] },
	      success: function(res){
	        if (res.success) {
	          $item.remove();
	          Swal.fire({icon: 'success', title: '삭제 완료', text: fileName + '이(가) 삭제되었습니다.'});
	        } else {
	          Swal.fire({icon: 'error', title: '삭제 실패', text: res.message || '파일 삭제에 실패했습니다.'});
	        }
	      },
	      error: function(){
	        Swal.fire({icon: 'error', title: '오류', text: '서버 통신 중 오류가 발생했습니다.'});
	      }
	    });
	  });
	  
	  
	  // 🚀 더미 데이터 채우기 로직 (추가된 기능)
	  $("#fillDummyData").on("click", function() {
	    // 1. 제목
	    $("#taskTitle").val("목공 자재 추가로 발주하기");
	    
	    // 2. 설명
	    $("#taskCn").val("지후 사원 일 배워야하니깐 한번 요번 기회를 통해 목공 자재 추가로 발주해야할거\n계산해서 직접 해봐!");
	    
	    // 3. 담당자 (김지후 (사원) 선택)
	    // '김지후 (사원)' 텍스트가 포함된 첫 번째 option의 value를 찾아 선택
	    let jihooEmpNo = null;
	    $("#taskCharger option").each(function() {
	        // 텍스트에 "김지후"와 "사원"이 모두 포함된 경우 선택 (예: "김지후 (사원) - 개발팀")
	        if ($(this).text().includes("김지후") && $(this).text().includes("사원")) { 
	            jihooEmpNo = $(this).val();
	            return false; // Loop 종료
	        }
	    });
	    if (jihooEmpNo) {
	        $("#taskCharger").val(jihooEmpNo).trigger('change');
	    }
	    
	    // 4. 유형 (목공 선택)
	    $("#procsTy").val("목공").trigger('change');
	    
	    // 5. 시작일/마감일
	    $("#taskBeginYmd").val("2025-10-02");
	    $("#taskDdlnYmd").val("2025-10-04");
	    
	    // 6. 긴급 스위치 (긴급 아님)
	    $("#emrgncyYn").prop('checked', false);
	    
	    // 7. 진행률
	    setProgress(30); 

	    // 유효성 검사 피드백 제거
	    $("#taskForm").find(".is-invalid").removeClass("is-invalid");
	    
	    // 사용자에게 채워졌음을 알림
	    Swal.fire({
	      icon: 'info', 
	      title: '더미 데이터 채움', 
	      text: '일감 정보가 더미 데이터로 채워졌습니다.', 
	      toast: true,
	      position: 'top-end',
	      showConfirmButton: false,
	      timer: 2000
	    });
	  });


	  // SweetAlert 플래시 메시지 (기존 로직 유지)
	  const flashMsg = ($("#flash-message").text() || "").trim();
	  const flashErr = ($("#flash-error").text() || "").trim();
	  if (flashMsg) {
	    Swal.fire({ icon: 'success', title: '완료', text: flashMsg, confirmButtonText: '확인' });
	  }
	  if (flashErr) {
	    Swal.fire({ icon: 'error', title: '오류', text: flashErr, confirmButtonText: '확인' });
	  }

	  // 폼 유효성 검사 (기존 로직 유지)
	  $("#taskForm").on("submit", function(e){
	    const $title = $("#taskTitle");
	    const $type  = $("#procsTy");
	    const $begin = $("#taskBeginYmd");
	    const $ddln  = $("#taskDdlnYmd");

	    [$title, $type, $begin, $ddln].forEach($el => $el.removeClass("is-invalid"));

	    let valid = true;
	    
	    if (!($title.val() || "").trim()) { 
	    	$title.addClass("is-invalid"); 
	    	valid = false; 
	    	}
	    
	    if (!($type.val()  || "")){ 
	    	$type.addClass("is-invalid");
	    	valid = false; 
	    	}
	    
	    if (!($begin.val() || "")){ 
	    	$begin.addClass("is-invalid"); 
	    	valid = false; 
	    	}
	    
	    if (!($ddln.val()  || "")){ 
	    	$ddln.addClass("is-invalid"); 
	    	valid = false; 
	    	}

	    if ($begin.val() && $ddln.val() && $ddln.val() < $begin.val()) {
	      $ddln.addClass("is-invalid")
	          .next(".invalid-feedback")
	          .text("마감일은 시작일 이후여야 합니다.");
	      valid = false;
	    } else {
	      $ddln.next(".invalid-feedback").text("마감일을 선택해 주세요.");
	    }

	    if (!valid) {
	      e.preventDefault();
	      e.stopPropagation();

	      Swal.fire({
	        icon: 'error',
	        title: '필수 항목을 확인하세요',
	        html: '제목, 유형, 시작일, 마감일은 <b>필수</b>입니다.',
	        confirmButtonText: '확인'
	      });

	      const $first = $(".is-invalid").first();
	      if ($first.length) {
	        $("html, body").animate({ scrollTop: $first.offset().top - 120 }, 300);
	      }
	    }
	  });

	  $("#taskTitle, #procsTy, #taskBeginYmd, #taskDdlnYmd").on("input change", function(){
	    $(this).removeClass("is-invalid");
	    if (this.id === "taskBeginYmd") {
	      $("#taskDdlnYmd").attr("min", this.value || null);
	    }
	  });
	});
</script>

</body>
</html>