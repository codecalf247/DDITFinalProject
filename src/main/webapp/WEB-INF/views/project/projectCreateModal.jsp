<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<style>
  /* (생략) — 기존 스타일 동일 */
  .assign-list{overflow:visible;max-height:none;}
  .assign-list.scroll-when-many{max-height:320px;overflow-y:auto;border:1px solid var(--bs-border-color);border-radius:.5rem;}
  #jstree2{height:360px;overflow-y:auto;}
  .swal2-container{z-index:20000 !important;}
</style>

<div class="modal fade" id="projectCreateModal" tabindex="-1" aria-labelledby="projectCreateModalLabel" aria-hidden="true"
     data-bs-backdrop="static" data-bs-keyboard="false">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">
          <c:if test="${status eq 'u'}">프로젝트 수정</c:if>
          <c:if test="${empty status or status ne 'u'}">프로젝트 등록</c:if>
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <ul class="nav nav-tabs nav-justified" id="projectRegTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="project-info-tab" data-bs-toggle="tab" data-bs-target="#project-info" type="button" role="tab">
              <i class="ti ti-file-text fs-5"></i> 프로젝트 정보
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="assign-line-tab" data-bs-toggle="tab" data-bs-target="#assign-line" type="button" role="tab">
              <i class="ti ti-users fs-5"></i> 담당 지정
            </button>
          </li>
        </ul>

        <div class="tab-content pt-3" id="projectRegTabContent">
          <div class="tab-pane fade show active" id="project-info" role="tabpanel" aria-labelledby="project-info-tab">
            <form id="projectInfoForm" method="post">
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="sptNm" class="form-label">현장명 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="sptNm" name="sptNm" placeholder="예) OO아파트 101동 리모델링">
                </div>
                <div class="col-md-6">
                  <label for="sptAddr" class="form-label">현장주소 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="sptAddr" name="sptAddr" placeholder="예) 서울시 ○○구 ○○로 123">
                </div>
                <div class="col-md-6">
                  <label for="cstmrNm" class="form-label">고객명 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="cstmrNm" name="cstmrNm" placeholder="예) 홍길동">
                </div>
                <div class="col-md-6">
                  <label for="cstmrTel" class="form-label">고객 연락처 <span class="text-danger">*</span></label>
                  <input type="text" class="form-control" id="cstmrTel" name="cstmrTel" placeholder="예) 010-1234-5678">
                </div>
                <div class="col-md-6">
                  <label for="prjctStartYmd" class="form-label">착공 기간 <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <input type="date" class="form-control" id="prjctStartYmd" name="prjctStartYmd" placeholder="YYYY-MM-DD" autocomplete="off">
                    <span class="input-group-text"><i class="ti ti-calendar fs-5"></i></span>
                  </div>
                </div>
                <div class="col-md-6">
                  <label for="prjctDdlnYmd" class="form-label">마감 기간 <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <input type="date" class="form-control" id="prjctDdlnYmd" name="prjctDdlnYmd" placeholder="YYYY-MM-DD" autocomplete="off">
                    <span class="input-group-text"><i class="ti ti-calendar fs-5"></i></span>
                  </div>
                </div>
               <div class="col-md-6">
				  <label for="prjctSttus" class="form-label">상태 <span class="text-danger">*</span></label>
				  <select class="form-select" id="prjctSttus" name="prjctSttus">
				    <option value="진행중" selected>진행중</option>
				    <option value="보류">보류</option>
				    <c:if test="${status eq 'u'}">
				      <option value="완료">완료</option>
				    </c:if>
				  </select>
				</div>
              </div>
            </form>
          </div>

          <div class="tab-pane fade" id="assign-line" role="tabpanel" aria-labelledby="assign-line-tab">
            <div class="row" style="max-height:none;overflow:visible;">
              <div class="col-md-5 d-flex flex-column">
                <div class="d-flex align-items-center mb-3">
                  <h6 class="fw-semibold mb-0">부서선택</h6>
                  <div class="btn-group ps-2 d-flex flex-grow-1">
                    <input type="text" class="form-control form-control-sm me-2" id="lineSchName" placeholder="사원/부서 검색하세요.">
                  </div>
                  <button id="lineSch" class="btn btn-outline-secondary btn-sm">검색</button>
                </div>
                <div id="jstree2" class="flex-grow-1 border rounded p-2" style="height:360px;overflow-y:auto;"></div>
              </div>

              <div class="col-md-1 text-center d-flex flex-column justify-content-center gap-2">
                <button class="btn btn-primary btn-sm w-100" id="designerLineBtn">디자인팀 <i class="ti ti-arrow-right fs-6"></i></button>
                <button class="btn btn-info btn-sm w-100" id="fieldStffLineBtn">현장팀 <i class="ti ti-arrow-right fs-6"></i></button>
              </div>

              <div class="col-md-6 d-flex flex-column">
                <div class="flex-grow-1 mb-3">
                  <div class="d-flex align-items-center mb-2">
                    <h6 class="fw-semibold mb-0">디자인 담당</h6>
                    <span class="text-danger ms-2">*</span>
                    <div class="ms-auto">
                    	<c:if test="${status eq 'u' }">
                      <button class="btn btn-outline-secondary btn-sm" id="resetdesignerLineBtn">
                        <i class="ti ti-rotate-2 fs-5"></i> 초기화
                      </button>
                      </c:if>
                    </div>
                  </div>
                  <div id="designerWrapper" class="table-responsive assign-list">
                    <table class="table table-hover table-striped align-middle mb-0">
                      <thead>
                        <tr>
                          <th>이름</th><th>직급</th><th>부서</th>
                          <c:if test="${status eq 'u' }">
                          <th style="width:56px;" class="text-center"><i class="ti ti-trash fs-5 text-danger"></i></th>
                          </c:if>
                        </tr>
                      </thead>
                      <tbody id="designerLineTableBody">
                        <c:if test="${status eq 'u' && not empty project.participantsList}">
                          <c:forEach var="a" items="${project.participantsList}">
                            <c:if test="${a.prjctPrtcpntType eq 'DESIGN'}">
                              <tr data-emp-no="${a.empNo}" data-team="DESIGN" data-emp-name="${fn:escapeXml(a.empNm)}" data-dept-name="${fn:escapeXml(a.deptNm)}">
                                <td>${fn:escapeXml(a.empNm)}</td>
                                <td><c:out value="${a.jbgdCd}"/></td>
                                <td>${fn:escapeXml(a.deptNm)}</td>
                              </tr>
                            </c:if>
                          </c:forEach>
                        </c:if>
                      </tbody>
                    </table>
                  </div>
                </div>

                <div class="flex-grow-1">
                  <div class="d-flex align-items-center mb-2">
                    <h6 class="fw-semibold mb-0">현장 담당</h6>
                    <div class="ms-auto">
                    	<c:if test="${status eq 'u' }">
                      <button class="btn btn-outline-secondary btn-sm" id="resetfieldStffLineBtn">
                        <i class="ti ti-rotate-2 fs-5"></i> 초기화
                      </button>
                      </c:if>
                    </div>
                  </div>
                  <div id="fieldWrapper" class="table-responsive assign-list">
                    <table class="table table-hover table-striped align-middle mb-0">
                      <thead>
                        <tr>
                          <th>이름</th><th>직급</th><th>부서</th>
                          <c:if test="${status eq 'u' }">
                          <th style="width:56px;" class="text-center"><i class="ti ti-trash fs-5 text-danger"></i></th>
                          </c:if>
                        </tr>
                      </thead>
                      <tbody id="fieldStffLineTableBody">
                        <c:if test="${status eq 'u' && not empty project.participantsList}">
                          <c:forEach var="a" items="${project.participantsList}">
                            <c:if test="${a.prjctPrtcpntType eq 'FIELD'}">
                              <tr data-emp-no="${a.empNo}" data-team="FIELD" data-emp-name="${fn:escapeXml(a.empNm)}" data-dept-name="${fn:escapeXml(a.deptNm)}">
                                <td>${fn:escapeXml(a.empNm)}</td>
                                <td><c:out value="${a.jbgdCd}"/></td>
                                <td>${fn:escapeXml(a.deptNm)}</td>
                              </tr>
                            </c:if>
                          </c:forEach>
                        </c:if>
                      </tbody>
                    </table>
                  </div>
                </div>

              </div></div></div></div><div class="modal-footer d-flex justify-content-between">
          <div class="text-muted small"><span id="stepIndicator">1 / 2</span></div>
          <div>
            <div id="footerStep1" class="d-inline-flex gap-2">
              <button type="button" class="btn btn-light" id="btnCancel1" data-bs-dismiss="modal">취소</button>
              <button type="button" class="btn btn-primary" id="btnNext">다음</button>
            </div>
            <div id="footerStep2" class="d-inline-flex gap-2 d-none">
              <button type="button" class="btn btn-light" id="btnCancel2" data-bs-dismiss="modal">취소</button>
              <button type="button" class="btn btn-secondary" id="btnPrev">이전</button>
              <button type="button" class="btn btn-success" id="btnSubmit">등록</button>
            </div>
          </div>
        </div>

      </div></div>
  </div>
</div>

<!-- JS는 이미 있으니 CSS만 추가하세요 (JS 바로 위/아래, 어디든 OK) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<script src="${pageContext.request.contextPath}/resources/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>

<script type="text/javascript">
  
let IS_UPDATE = <c:choose><c:when test="${status eq 'u'}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
const PROJECT_DATA = {};
const existingParticipants = [];
const ST_CODE_TO_LABEL = { '17002': '진행중', '17003': '완료', '17004': '보류' };
const ST_LABEL_TO_CODE = { '진행중': '17002', '완료': '17003', '보류': '17004' };

let empNo="", empNm="", jbgdCd="", empDept="";

const jsEl2 = $("#jstree2").length ? $("#jstree2").jstree({
  plugins:["search"],
  core:{ data:function(obj, cb){
    $.ajax({ url:"/eApprovalTree/approvalLine", type:"get",
      success:function(res){
        (res||[]).forEach(n=>{ n.icon=(n.parent=="#")?"ti ti-users":"ti ti-user"; });
        cb.call(obj,res||[]);
      },
      error:function(e,s,t){ console.log(e,s,t); }
    });
  }, check_callback:true }
}) : null;

function initDatepickers(){
  if(!$.fn.datepicker){ return; }
  const opts={format:'yyyymmdd',autoclose:true,todayHighlight:true,orientation:'auto bottom',container:'#projectCreateModal'};
  $('#prjctStartYmd,#prjctDdlnYmd').attr('type','text').datepicker('destroy').datepicker(opts);
}

function validateStep1(){
  const reqs=[
      {id:'#sptNm',label:'현장명'},{id:'#sptAddr',label:'현장주소'},{id:'#cstmrNm',label:'고객명'},
      {id:'#cstmrTel',label:'고객 연락처'},{id:'#prjctStartYmd',label:'착공 기간'},{id:'#prjctDdlnYmd',label:'마감 기간'}
  ];
  for (let i=0;i<reqs.length;i++){
      const el=$(reqs[i].id);
      if(!el.val()||!el.val().trim()){
          Swal.fire({title:reqs[i].label+'을(를) 입력하세요.',icon:'error',confirmButtonText:'확인'}); el.focus(); return false;
      }
  }
  const tel=$('#cstmrTel').val();
  if(tel && !/^[0-9\-]+$/.test(tel)){
      Swal.fire({title:'전화번호는 숫자/하이픈(-)만 입력 가능합니다.',icon:'error',confirmButtonText:'확인'});
      $('#cstmrTel').focus(); return false;
  }
  const s=$('#prjctStartYmd').val(), e=$('#prjctDdlnYmd').val();
  if(s&&e&&s>e){
      Swal.fire({title:'마감 기간은 착공 기간 이후여야 합니다.',icon:'error',confirmButtonText:'확인'});
      $('#prjctDdlnYmd').focus(); return false;
  }
  return true;
}

function gotoStep(step){
  if(step===1){
      const tab=document.querySelector('#project-info-tab');
      if(tab) bootstrap.Tab.getOrCreateInstance(tab).show();
  }
}

function updatePanelHeights(){
  const d=$("#designerLineTableBody tr").length, f=$("#fieldStffLineTableBody tr").length;
  const dw=$("#designerWrapper"), fw=$("#fieldWrapper");
  if(d>=4){dw.addClass("scroll-when-many");} else {dw.removeClass("scroll-when-many");}
  if(f>=4){fw.addClass("scroll-when-many");} else {fw.removeClass("scroll-when-many");}
}

function yyyymmddToDash(val){
  if(!val) return ''; const s=String(val).trim();
  if(s.length!==8) return s;
  return s.substring(0,4)+'-'+s.substring(4,6)+'-'+s.substring(6,8);
}

function alreadyEmp(val, sels){
  for (let i=0;i<sels.length;i++){
      const trs=$(sels[i]).find("tr");
      for (let j=0;j<trs.length;j++){
          if(String($(trs[j]).attr("data-emp-no"))===String(val)){ return true; }
      }
  }
  return false;
}

function fillModalWithProjectData(res){
	let data = res.data;
	IS_UPDATE = res.status == 'u' ? true : false;
  if(!data) return;

  $('#sptNm').val(data.sptNm);
  $('#sptAddr').val(data.sptAddr);
  $('#cstmrNm').val(data.cstmrNm);
  $('#cstmrTel').val(data.cstmrTel);
  $('#prjctStartYmd').val(yyyymmddToDash(data.prjctStartYmd));
  $('#prjctDdlnYmd').val(yyyymmddToDash(data.prjctDdlnYmd));

  const mappedSttus = ST_CODE_TO_LABEL[data.prjctSttus] || data.prjctSttus;
  $('#prjctSttus').val(mappedSttus);
  $('#prjctSttus option[value="완료"]').prop('disabled', false);

  $("#designerLineTableBody, #fieldStffLineTableBody").empty();
  if (data.participantsList && data.participantsList.length > 0) {
      data.participantsList.forEach(function(p) {
          const row = `<tr data-emp-no="\${p.empNo}" data-team="\${p.prjctPrtcpntType}" data-emp-name="\${p.empNm}" data-dept-name="\${p.deptNm}">
                  <td>\${p.empNm}</td>
                  <td>\${p.jbgdNm || '-'}</td>
                  <td>\${p.deptNm}</td>
              </tr>`;
          if (p.prjctPrtcpntType === 'DESIGN') {
              $("#designerLineTableBody").append(row);
          } else {
              $("#fieldStffLineTableBody").append(row);
          }
      });
  }
  updatePanelHeights();
  $('#btnSubmit').text('수정');
}

// DOM Ready
$(document).ready(function(){
	jsEl2.on("select_node.jstree", function(e, data){
    const node=data.node;
    if(node.children && node.children.length>0) return;
    empNo = node.id || (node.original && node.original.id) || "";
    const parts=(node.text||"").split("(");
    empNm=(parts[0]||"").trim();
    jbgdCd=((parts[1]||"").replace(")","")||"").trim();
    const inst = jsEl2.jstree(true);
    const parentObj = inst && inst.get_node(node.parent);
    const parentText = (parentObj && parentObj.id!=='#') ? (parentObj.text||'') : '';
    empDept=(parentText || (node.original && (node.original.deptNm||node.original.dept)) || '').trim();
    console.log("empNO: " + empNo);
  });

  // 기본 submit 막기
  $("#projectInfoForm").on("submit", function(e){ e.preventDefault(); });

  // 탭 풋터 토글
  $('#projectRegTab button[data-bs-toggle="tab"]').off('shown.bs.tab').on('shown.bs.tab', function(e){
    const target=e.target.getAttribute('data-bs-target');
    if(target==='#project-info'){ $('#footerStep1').removeClass('d-none'); $('#footerStep2').addClass('d-none'); $('#stepIndicator').text('1 / 2'); }
    else { $('#footerStep1').addClass('d-none'); $('#footerStep2').removeClass('d-none'); $('#stepIndicator').text('2 / 2'); }
  });

  // 이동
  $("#btnNext").on('click', function(e){ e.preventDefault(); e.stopPropagation();
    if(!validateStep1()) return;
    bootstrap.Tab.getOrCreateInstance(document.querySelector('#assign-line-tab')).show();
  });
  $("#btnPrev").on('click', function(e){ e.preventDefault(); e.stopPropagation();
    bootstrap.Tab.getOrCreateInstance(document.querySelector('#project-info-tab')).show();
  });

  // 검색
  $("#lineSch").on("click", function(){
    const q=$("#lineSchName").val();
    if($("#jstree2").jstree){ $("#jstree2").jstree(true).search(q); }
  });

  // 담당자 추가/삭제/초기화
  $("#designerLineBtn").on("click", function(){
	  console.log("현재 empNo 값: ", empNo); // ★ 디버깅 코드 추가
	 if(!empNo){ Swal.fire({title:'디자인 담당자를 선택해주세요.',icon:'error',confirmButtonText:'확인'}); return; }
    if(alreadyEmp(empNo,["#designerLineTableBody","#fieldStffLineTableBody"])){ Swal.fire({title:'담당자는 이미 지정되었습니다.',icon:'warning',confirmButtonText:'확인'}); return; }
    const row = `<tr data-emp-no="\${empNo}" data-team="DESIGN" data-emp-name="\${empNm}" data-dept-name="\${empDept}">
        <td>\${empNm}</td><td>\${jbgdCd}</td><td>\${empDept}</td>
        <td class="text-center"><i class="ti ti-trash fs-4 text-danger delete-line" style="cursor:pointer;"></i></td>
      </tr>`;
    $("#designerLineTableBody").append(row); updatePanelHeights();
  });
  $("#fieldStffLineBtn").on("click", function(){
    if(!empNo){ Swal.fire({title:'현장 담당자를 선택해주세요.',icon:'error',confirmButtonText:'확인'}); return; }
    if(alreadyEmp(empNo,["#designerLineTableBody","#fieldStffLineTableBody"])){ Swal.fire({title:'담당자는 이미 지정되었습니다.',icon:'warning',confirmButtonText:'확인'}); return; }
    const row = `<tr data-emp-no="\${empNo}" data-team="FIELD" data-emp-name="\${empNm}" data-dept-name="\${empDept}">
        <td>\${empNm}</td><td>\${jbgdCd}</td><td>\${empDept}</td>
        <td class="text-center"><i class="ti ti-trash fs-4 text-danger delete-line" style="cursor:pointer;"></i></td>
      </tr>`;
    $("#fieldStffLineTableBody").append(row); updatePanelHeights();
  });

  $("#resetdesignerLineBtn").on("click", function(){ $("#designerLineTableBody").empty(); updatePanelHeights(); });
  $("#resetfieldStffLineBtn").on("click", function(){ $("#fieldStffLineTableBody").empty(); updatePanelHeights(); });
  $(document).on("click", ".delete-line", function(){ $(this).closest("tr").remove(); updatePanelHeights(); });

  /* ---- 모달: 단일 핸들러(등록/수정 겸용) ---- */
  $('#projectCreateModal').on('show.bs.modal', function (event) {
    const button = $(event.relatedTarget);
    const prjctNo = button && button.data('prjct-no');
    const firstTab = document.querySelector('#project-info-tab');
    if (firstTab) bootstrap.Tab.getOrCreateInstance(firstTab).show();

    if (prjctNo) {
      $.ajax({
        url: `/project/update/data?prjctNo=\${prjctNo}`,
        type: 'GET',
        success: function(res){ fillModalWithProjectData(res); },
        error: function(){ Swal.fire('오류','데이터를 불러오는데 실패했습니다.','error'); }
      });
    } else {
      $('#projectInfoForm')[0].reset();
      $('#designerLineTableBody,#fieldStffLineTableBody').empty();
      $('#prjctSttus').val('진행중');
      updatePanelHeights();
      initDatepickers();
      $('#btnSubmit').text('등록');
    }
  });

  // 저장(등록/수정)
  $("#btnSubmit").on("click", function(){
    if($("#designerLineTableBody tr").length===0){
      Swal.fire({title:'담당자(디자인팀)를 최소 1명 선택하세요.',icon:'error',confirmButtonText:'확인'}); return;
    }
    if(!validateStep1()){ gotoStep(1); return; }

    const stLabel = (String($('#prjctSttus').val()||'진행중')).trim();
    const stCode = ST_LABEL_TO_CODE[stLabel] || '17002';

    const payload={
      sptNm: $('#sptNm').val(),
      sptAddr: $('#sptAddr').val(),
      cstmrNm: $('#cstmrNm').val(),
      cstmrTel: $('#cstmrTel').val(),
      prjctStartYmd: $('#prjctStartYmd').val().replaceAll('-',''),
      prjctDdlnYmd: $('#prjctDdlnYmd').val().replaceAll('-',''),
      prjctSttus: stCode,
      participantsList: []
    };
    if(IS_UPDATE) payload.prjctNo = PROJECT_DATA.prjctNo;

    $("#designerLineTableBody tr").each(function(){
		const eno=$(this).attr("data-emp-no"); 
		if(eno){ 
    		if(IS_UPDATE){
				let findEl = $(this).find(".delete-line");
				if(findEl.length > 0){
					payload.participantsList.push({empNo:eno,prjctPrtcpntType:"DESIGN"});
				}
    		}else{
				payload.participantsList.push({empNo:eno,prjctPrtcpntType:"DESIGN"}); 
	    	}
		}
    });
    $("#fieldStffLineTableBody tr").each(function(){
		const eno=$(this).attr("data-emp-no"); 
		if(eno){
			if(IS_UPDATE){
				let findEl = $(this).find(".delete-line");
				if(findEl.length > 0){
					payload.participantsList.push({empNo:eno,prjctPrtcpntType:"FIELD"}); 
				}
			}else{
				payload.participantsList.push({empNo:eno,prjctPrtcpntType:"FIELD"}); 
			}
		}
    });
    
    console.log(payload.sptNm);
    console.log(payload.sptAddr);
    console.log(payload.cstmrNm);
    console.log(payload.participantsList[0]);
    console.log(payload.participantsList[1]);
    console.log(payload.participantsList[2]);
    
    let prjctNo = "";
    
    if(IS_UPDATE){
	    const httpUrl = new URL(location.href);
	    let urlParams = httpUrl.searchParams;
	    console.log(urlParams);
	    prjctNo = urlParams.get("prjctNo");
	    payload.prjctNo = prjctNo;
    }
    
    const url = IS_UPDATE ? "/project/update?prjctNo=" + prjctNo : "/project/createProject";
    $.ajax({
      url, type:"post",
      data: JSON.stringify(payload),
      contentType:"application/json; charset=utf-8",
      success: function(res) {
    	  try { if (typeof res === 'string') res = res.trim(); } catch (e) {}

    	  const isOk =
    	    res === 'OK' ||
    	    res === 'SUCCESS' ||
    	    (typeof res === 'object' && (res.result === 'OK' || res.status === 'OK')) ||
    	    (typeof res === 'string' && res.startsWith('<!DOCTYPE html'));

    	  if (isOk) {
    	    const modalEl = document.getElementById('projectCreateModal');
    	    const modalIns = bootstrap.Modal.getOrCreateInstance(modalEl);
    	    modalIns.hide();
    	    modalEl.addEventListener('hidden.bs.modal', function onHidden() {
    	      modalEl.removeEventListener('hidden.bs.modal', onHidden);
    	      $('.modal-backdrop').remove();
    	      $('body').removeClass('modal-open').css('padding-right', '');
    	    });

    	    const curStatus = $('#catTabs .nav-link.active').attr('data-status');
    	    const sttusCode = ST_LABEL_TO_CODE[curStatus] || '17002';

    	    Swal.fire({
    	      title: IS_UPDATE ? '프로젝트 수정이 완료되었습니다.' : '프로젝트 등록이 완료되었습니다.',
    	      icon: 'success',
    	      confirmButtonText: '확인'
    	    });

    	    setTimeout(function () {
    	      location.href = location.href;
    	    }, 1000);
    	  } else {
    	    Swal.fire({ title: '저장에 실패했습니다.', icon: 'error', confirmButtonText: '확인' });
    	  }
    	},
      error:function(e,s,t){
        console.log(e,s,t);
        Swal.fire({ title:'오류가 발생했습니다.', text:'잠시 후 다시 시도해주세요.', icon:'error', confirmButtonText:'확인' });
      }
    });
  });

  // 모달 닫힐 때 초기화
  $("#projectCreateModal").on("hidden.bs.modal", function(){
    $("#projectInfoForm")[0].reset();
    $("#designerLineTableBody,#fieldStffLineTableBody").empty();
    $("#prjctSttus").val("진행중");
    updatePanelHeights();
  });
});
</script>