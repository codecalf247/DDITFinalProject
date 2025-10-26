<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GroupWare</title>
  <%@ include file="/module/headPart.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.min.css">
  <style>
    .thumb-card { width: 140px; }
    .thumb-card .form-check-label { white-space: nowrap; }
  </style>
</head>
<%@ include file="/module/header.jsp" %>

<body>
<%@ include file="/module/aside.jsp" %>
<div class="body-wrapper">
  <div class="container-fluid">

    <div class="container mt-4">
      <%@ include file="/WEB-INF/views/project/carousels.jsp" %>

      <!-- 우측 버튼 그룹 -->
      <div class="d-flex justify-content-end align-items-start mt-4 mb-3">
        <div class="btn-group">
          <a href="/project/issues" class="btn btn-outline-secondary" id="listBtn">목록</a>
          <c:if test="${issue.ownerId == loginUser.userId}">
            <!-- 이 버튼이 아래 taskForm을 submit -->
            <button type="submit" class="btn btn-outline-success" id="updateBtn" form="taskForm">수정</button>
            <button type="button" class="btn btn-outline-danger" id="cancelBtn">취소</button>
          </c:if>
        </div>
      </div>

      <div class="row g-4">
        <!-- 단일 full width 폼 -->
        <div class="col-12">
          <div class="card rounded-3">
            <div class="card-body">

              <!-- 수정 폼 -->
              <form id="taskForm" action="/issue/update.do" method="post" enctype="multipart/form-data">
                <input type="hidden" name="issueId" value="${issue.issueId}">

                <!-- 제목 + 긴급여부(가로 한줄, 라벨 줄바꿈 방지) -->
                <div class="mb-3">
                  <label class="form-label">제목</label>
                  <div class="d-flex align-items-center gap-3">
                    <input type="text" class="form-control" id="title" name="title"
                           value="${issue.title}" placeholder="제목을 입력하세요" required>

                    <div class="form-check form-check-inline m-0">
                      <input class="form-check-input" type="checkbox" id="emergency" name="emergency"
                             value="Y" <c:if test="${issue.emergency eq 'Y'}">checked</c:if>>
                      <label class="form-check-label mb-0 ms-1" for="emergency" style="white-space:nowrap;">긴급여부</label>
                    </div>
                  </div>
                </div>

                <!-- 유형/상태 -->
                <div class="row g-3">
                  <div class="col-md-6">
                    <label class="form-label">이슈 유형</label>
                    <select class="form-select" id="issueType" name="issueType" required>
                      <option value="">선택</option>
                      <option value="현장"  <c:if test="${issue.issueType eq '현장'}">selected</c:if>>현장</option>
                      <option value="설계"  <c:if test="${issue.issueType eq '설계'}">selected</c:if>>설계</option>
                      <option value="민원"  <c:if test="${issue.issueType eq '민원'}">selected</c:if>>민원</option>
                      <option value="기타"  <c:if test="${issue.issueType eq '기타'}">selected</c:if>>기타</option>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">진행 상태</label>
                    <select class="form-select" id="status" name="status" required>
                      <option value="">선택</option>
                      <option value="대기"   <c:if test="${issue.status eq '대기'}">selected</c:if>>대기</option>
                      <option value="처리중" <c:if test="${issue.status eq '처리중'}">selected</c:if>>처리중</option>
                      <option value="완료"   <c:if test="${issue.status eq '완료'}">selected</c:if>>완료</option>
                    </select>
                  </div>
                </div>

                <!-- 담당자 -->
                <div class="mt-3">
                  <label class="form-label">담당자</label>
                  <input type="text" class="form-control" id="assignee" name="assigneeName"
                         value="${issue.assigneeName}" placeholder="담당자 이름을 입력하세요">
                </div>

                <!-- 본문 -->
                <div class="mt-4">
                  <label class="form-label">이슈 내용</label>
                  <textarea class="form-control" id="content" name="content" rows="8"
                            placeholder="이슈 상세 내용을 입력하세요">${fn:escapeXml(issue.content)}</textarea>
                </div>

                <!-- 첨부파일: 기존 파일(삭제 체크) + 새 파일 추가 -->
                <div class="mt-4">
                  <label class="form-label d-block">첨부파일</label>

                  <!-- 기존 첨부 썸네일 -->
                  <div class="d-flex flex-wrap gap-3 mb-2" id="existingFiles">
                    <c:forEach var="f" items="${issue.files}">
                      <div class="card shadow-sm position-relative thumb-card">
                        <img src="${f.thumbUrl}" data-full="${f.url}" class="img-fluid rounded-2 thumb-img" alt="attachment">
                        <!-- 기존 파일 삭제 체크: deleteFileIds 다중 전송 -->
                        <div class="form-check position-absolute bottom-0 start-0 m-2 bg-white bg-opacity-75 px-2 rounded">
                          <input class="form-check-input" type="checkbox" value="${f.fileId}" id="del_${f.fileId}" name="deleteFileIds">
                          <label class="form-check-label small ms-1" for="del_${f.fileId}">삭제</label>
                        </div>
                      </div>
                    </c:forEach>
                    <c:if test="${empty issue.files}">
                      <div class="text-muted">기존 첨부 없음</div>
                    </c:if>
                  </div>

                  <!-- 새 파일 추가 -->
                  <input type="file" class="form-control" id="newFiles" name="files" multiple>
                  <div class="form-text">여러 파일을 선택할 수 있습니다.</div>
                </div>

              </form>
              <!-- /#taskForm -->

            </div>
          </div>
        </div>
      </div>

    </div> <!-- /.container -->
  </div>   <!-- /.container-fluid -->
</div>     <!-- /.body-wrapper -->

<!-- 이미지 확대 모달 -->
<div class="modal fade" id="photoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-body p-0">
        <img id="photoModalImg" src="" class="img-fluid w-100" alt="preview">
      </div>
    </div>
  </div>
</div>

<%@ include file="/module/footerPart.jsp" %>
<script src="${pageContext.request.contextPath}/resources/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>

<script>
$(function(){

  /* 썸네일 클릭 → 큰 이미지 모달 */
  $(document).on('click', '.thumb-img', function(){
    const full = $(this).data('full') || $(this).attr('src');
    $('#photoModalImg').attr('src', full);
    $('#photoModal').modal('show');
  });

  /* 수정 제출: AJAX(FormData) */
  $(document).on('submit', '#taskForm', function(e){
    e.preventDefault();

    // emergency 체크 안했으면 N을 명시적으로 전달
    if(!$('#emergency').is(':checked')){
      if(!$('#emergencyHidden').length){
        $('<input>', {type:'hidden', id:'emergencyHidden', name:'emergency', value:'N'}).appendTo('#taskForm');
      } else {
        $('#emergencyHidden').val('N');
      }
    } else {
      $('#emergencyHidden').remove();
    }

    const fd = new FormData(this);
    // NOTE: 체크된 deleteFileIds는 자동으로 포함됨(name="deleteFileIds" 여러개)

    $.ajax({
      url: $(this).attr('action'),   // /issue/update.do
      type: 'post',
      data: fd,
      processData: false,
      contentType: false,
      success: function(res){
        Swal.fire({
          icon: 'success',
          title: '수정 완료',
          text: '이슈가 성공적으로 수정되었습니다.',
          timer: 1200,
          showConfirmButton: false
        }).then(function(){
          location.href = '/issues/detail?issueId=${issue.issueId}';
        });
      },
      error: function(xhr){
        Swal.fire({
          icon: 'error',
          title: '수정 실패',
          text: xhr.responseText || '수정 처리 중 오류가 발생했습니다.'
        });
        console.error(xhr.responseText);
      }
    });
  });

  /* 삭제 버튼: SweetAlert 확인 → 삭제 요청 */
  $(document).on('click', '#deleteBtn', function(){
    Swal.fire({
      title: '정말 삭제하시겠습니까?',
      text: '삭제하면 복구할 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then(function(result){
      if(result.isConfirmed){
        $.post('/issue/delete.do', { issueId: '${issue.issueId}' })
          .done(function(){
            Swal.fire({
              title: '삭제 완료',
              text: '이슈가 삭제되었습니다.',
              icon: 'success',
              confirmButtonText: '확인'
            }).then(function(){
              location.href = '/project/issues';
            });
          })
          .fail(function(xhr){
            Swal.fire({
              icon: 'error',
              title: '삭제 실패',
              text: xhr.responseText || '삭제 처리 중 오류가 발생했습니다.'
            });
          });
      }
    });
  });

});
</script>
</body>
</html>
