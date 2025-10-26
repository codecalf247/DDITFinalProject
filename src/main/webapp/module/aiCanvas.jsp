<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

  <style>
    #aiOffcanvas {
      width: 400px !important;
    }

    /* 입력창 : 하단에 고정 */
    .aiChat-input-area {
      flex: 0 0 auto;
      position: sticky;
      bottom: 0;
      z-index: 1;
    }

    /* 메시지 영역: 남는 공간 전부 + 여기만 스크롤 */
    .aiChat-messages {
      flex: 1 1 auto;
      overflow-y: auto;
      min-height: 0;
      /* ← 중요 */
    }

    /* Offcanvas 내부를 세로 레이아웃 + 자식 스크롤 허용 */
  </style>
  <!-- AI canvas 화면 -->
  <div class="offcanvas customizer offcanvas-end" tabindex="-1" id="aiOffcanvas" aria-labelledby="aiOffcanvasLabel">

    <!-- TITLE -->
    <div class="d-flex align-items-center justify-content-between p-3 border-bottom">
      <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 48 48">
        <defs>
          <mask id="SVGSDSXGb1A">
            <g fill="none">
              <rect width="30" height="24" x="9" y="18" fill="#555555" stroke="#fff" stroke-width="4" rx="2" />
              <circle cx="17" cy="26" r="2" fill="#fff" />
              <circle cx="31" cy="26" r="2" fill="#fff" />
              <path fill="#fff" d="M20 32a2 2 0 1 0 0 4zm8 4a2 2 0 1 0 0-4zm-8 0h8v-4h-8z" />
              <path stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="4"
                d="M24 10v8M4 26v8m40-8v8" />
              <circle cx="24" cy="8" r="2" stroke="#fff" stroke-width="4" />
            </g>
          </mask>
        </defs>
        <path fill="#78bbe4" d="M0 0h48v48H0z" mask="url(#SVGSDSXGb1A)" />
      </svg>
      <h4 class="offcanvas-title fw-semibold" id="aiOffcanvasLabel" style="text-align: left;">
        Groovy
      </h4>
      <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column h-100">
	  
	  <!-- 숨겨진 음성파일 input -->		
	  <input type="file" id="audioFileHiddenInput" accept="audio/*" class="d-none">

      <!-- 개별 채팅 대화 화면 -->
      <div id="aiChatConversationView" class="d-flex flex-column h-100">

        <!-- 메시지 영역 -->
        <div class="aiChat-messages flex-grow-1 overflow-auto">
        
          <!-- 가데이터 메세지 -->
          <div class="message-group mb-3">
            <div class="d-flex align-items-start">
              <div class="d-flex align-items-center justify-content-center me-2"
                style="width:32px;height:32px;font-size:14px;">
              	
              	 <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 48 48">
			        <defs>
			          <mask id="SVGSDSXGb1A">
			            <g fill="none">
			              <rect width="30" height="24" x="9" y="18" fill="#555555" stroke="#fff" stroke-width="4" rx="2" />
			              <circle cx="17" cy="26" r="2" fill="#fff" />
			              <circle cx="31" cy="26" r="2" fill="#fff" />
			              <path fill="#fff" d="M20 32a2 2 0 1 0 0 4zm8 4a2 2 0 1 0 0-4zm-8 0h8v-4h-8z" />
			              <path stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="4"
			                d="M24 10v8M4 26v8m40-8v8" />
			              <circle cx="24" cy="8" r="2" stroke="#fff" stroke-width="4" />
			            </g>
			          </mask>
			        </defs>
			        <path fill="#78bbe4" d="M0 0h48v48H0z" mask="url(#SVGSDSXGb1A)" />
			      </svg>  
              </div>
              <div>
                <div class="fw-semibold small text-muted mb-1">Groovy</div>
                <div class="message-bubble bg-light p-2 rounded-3 mb-1" style="max-width:250px;">안녕하세요! 저는 회사에 대한 
정보를 제공하고, 회의 음성을 요약하여 
파일로 변환할 수 있는 AI Groovy입니다. 
언제든지 도움이 필요하시면 알려주세요!
</div>
              </div>
            </div>
          </div>
           <!-- 가데이터 메세지 --> 
           
        </div> <!-- 메세지 영역 -->

        <!-- 메시지 입력 영역 (한줄) -->
        <div class="aiChat-input-area border-top bg-white d-flex">
        
        	<!-- 파일 버튼 -->
            <button id="audioFileInputBtn" class="btn btn-outline-secondary btn-sm me-2" type="button">
              <i class="ti ti-file-phone"></i>
            </button>
            
          <div class="input-group">

            <!-- 입력창 -->
            <input type="text" class="form-control border-0 bg-light" placeholder="메시지를 입력하세요..." id="aiMessageInput">

            <!-- 전송 버튼 -->
            <button class="btn btn-primary" type="button" id="sendAiMessageBtn">
              <i class="ti ti-send"></i>
            </button>

          </div>
        </div>

      </div>


    </div>
  </div>

  <script type="text/javascript">
  	  
  	  // 메시지 입력 창
	  const aiMessageInput = document.querySelector('#aiMessageInput');
  	  // 메시지 전송 버튼
	  const sendAiMessageBtn = document.querySelector('#sendAiMessageBtn');
  	  // 메시지 영역 부분
	  const aiChatMessages = document.querySelector('.aiChat-messages');
  	  
  	  // 음성 메시지 입력 버튼
  	  const audioFileInputBtn = document.querySelector("#audioFileInputBtn");
  	  // 숨겨진 파일 입력 필드
  	  const audioFileHiddenInput = document.querySelector("#audioFileHiddenInput");
  	  
	  // 전송 버튼 클릭 또는 Enter 키 입력 시 호출될 함수
	  function sendMessage() {
	      const userMessage = aiMessageInput.value.trim();
	      if (userMessage === '') return; // 공백 메시지는 전송하지 않음

	      // 1. 사용자 메시지 화면에 표시
	      appendMessage(userMessage, 'user');

	      // 2. 입력창 비우기
	      aiMessageInput.value = '';

	      // 3. AI 로딩 인디케이터 표시
	      const loadingMessageElement = appendLoadingIndicator();

	      // 4. 비동기 통신으로 AI 응답 요청 
	      fetch('/api/query-stream', {
	          method: 'POST',
	          headers: { 'Content-Type': 'application/json' },
	          body: JSON.stringify({
	              messages: [{
	                  role: 'user',
	                  content: userMessage
	              }]
	          })
	      })
	      .then(response => {
	          // 스트리밍 응답을 읽기 위한 Reader 객체
	          const reader = response.body.getReader();
	          const decoder = new TextDecoder();
	          let receivedText = '';

	          // 스트림 데이터를 처리하는 재귀 함수
	          function processStream({ done, value }) {
	              if (done) {
	                  return;
	              }
	              // 수신된 텍스트를 디코딩하여 누적
	              receivedText += decoder.decode(value, { stream: true });
	              
	              // 실시간으로 AI 메시지 업데이트
	              updateLastAiMessage(receivedText);
	              
	              // 화면 스크롤을 맨 아래로 이동
	              scrollToBottom();
	              
	              // 다음 스트림 데이터를 읽도록 호출
	              return reader.read().then(processStream);
	          }

	          // 스트림 읽기 시작
	          reader.read().then(processStream);
	      })
	      .catch(error => {
	          console.error('Error:', error);
	          removeLoadingIndicator(loadingMessageElement);
	          appendMessage('죄송합니다. 메시지를 처리하는 중 오류가 발생했습니다.', 'ai');
	      });
	  }
	  
	// 채팅 메시지 말풍선을 추가하는 함수
	  function appendMessage(content, role) {
	      const isAi = role === 'ai';
	      let messageHtml = '';

	      if (isAi) {
	          // AI 메시지 HTML
	          messageHtml = `
	              <div class="message-group mb-3">
	                  <div class="d-flex align-items-start">
	                      <div class="d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;">
	                          <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 48 48">
	                              <defs>
	                                  <mask id="SVGSDSXGb1A">
	                                      <g fill="none">
	                                          <rect width="30" height="24" x="9" y="18" fill="#555555" stroke="#fff" stroke-width="4" rx="2" />
	                                          <circle cx="17" cy="26" r="2" fill="#fff" />
	                                          <circle cx="31" cy="26" r="2" fill="#fff" />
	                                          <path fill="#fff" d="M20 32a2 2 0 1 0 0 4zm8 4a2 2 0 1 0 0-4zm-8 0h8v-4h-8z" />
	                                          <path stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="M24 10v8M4 26v8m40-8v8" />
	                                          <circle cx="24" cy="8" r="2" stroke="#fff" stroke-width="4" />
	                                      </g>
	                                  </mask>
	                              </defs>
	                              <path fill="#78bbe4" d="M0 0h48v48H0z" mask="url(#SVGSDSXGb1A)" />
	                          </svg>
	                      </div>
	                      <div>
	                          <div class="fw-semibold small text-muted mb-1">Groovy</div>
	                          <div class="message-bubble bg-light p-2 rounded-3 mb-1" style="max-width:250px;">
	                              \${content}
	                          </div>
	                      </div>
	                  </div>
	              </div>`;
	      } else {

	          // 사용자 메시지 HTML
	          messageHtml = `
	              <div class="message-group mb-3">
	                  <div class="d-flex justify-content-end">
	                      <div class="text-end">
	                          <div class="bg-primary text-white p-2 rounded-3 mb-1 ms-auto" style="max-width:250px;">
	                              \${content}
	                          </div>
	                      </div>
	                  </div>
	              </div>`;
	      }

	      aiChatMessages.insertAdjacentHTML('beforeend', messageHtml);
	      scrollToBottom();
	  }

	  // 로딩 인디케이터를 추가하고 해당 요소를 반환하는 함수
	  function appendLoadingIndicator() {
	     
		  const loadingHtml = `
	          <div class="message-group mb-3 ai-loading-indicator">
	              <div class="d-flex align-items-start">
	                  <div class="d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;">
	                      <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 48 48">
	                          <defs>
	                              <mask id="SVGSDSXGb1A">
	                                  <g fill="none">
	                                      <rect width="30" height="24" x="9" y="18" fill="#555555" stroke="#fff" stroke-width="4" rx="2" />
	                                      <circle cx="17" cy="26" r="2" fill="#fff" />
	                                      <circle cx="31" cy="26" r="2" fill="#fff" />
	                                      <path fill="#fff" d="M20 32a2 2 0 1 0 0 4zm8 4a2 2 0 1 0 0-4zm-8 0h8v-4h-8z" />
	                                      <path stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="M24 10v8M4 26v8m40-8v8" />
	                                      <circle cx="24" cy="8" r="2" stroke="#fff" stroke-width="4" />
	                                  </g>
	                              </mask>
	                          </defs>
	                          <path fill="#78bbe4" d="M0 0h48v48H0z" mask="url(#SVGSDSXGb1A)" />
	                      </svg>
	                  </div>
	                  <div>
	                      <div class="fw-semibold small text-muted mb-1">Groovy</div>
	                      <div class="ai-message bg-light p-2 rounded-3 mb-1" style="max-width:250px;">
		                      <div class="spinner-grow spinner-grow-sm" role="status"></div>
	                      </div>
	                  </div>
	              </div>
	          </div>
	      `;
	      
	      aiChatMessages.insertAdjacentHTML('beforeend', loadingHtml);
	      scrollToBottom();
	      // 로딩 인디케이터 요소를 찾아 반환
	      return aiChatMessages.lastElementChild;
	  }

	  // 로딩 인디케이터를 제거하는 함수
	  function removeLoadingIndicator(loadingElement) {
	      if (loadingElement) {
	          loadingElement.remove();
	      }
	  }

	  // 마지막 AI 메시지 내용을 업데이트하는 함수
	  function updateLastAiMessage(content) {
	      const lastMessageBubble = document.querySelector('.aiChat-messages .message-group:last-child .ai-message');
	      if (lastMessageBubble) {
	          lastMessageBubble.innerHTML = content;
	      }
	  }

	  // 스크롤을 맨 아래로 이동시키는 함수
	  function scrollToBottom() {
	      aiChatMessages.scrollTop = aiChatMessages.scrollHeight;
	  }
	  
	  // 전송 버튼 클릭 이벤트
	  sendAiMessageBtn.addEventListener('click', sendMessage);

	  // 입력창에서 Enter 키 입력 이벤트
	  aiMessageInput.addEventListener('keypress', (event) => {
	      if (event.key === 'Enter') {
	          sendMessage();
	      }
	  });
	  
	  // 음성 파일버튼을 눌렀을 때
	  audioFileInputBtn.addEventListener("click", function(){
		  console.log("눌림");
		  audioFileHiddenInput.click();
	  });
	  
	  // 파일이 선택되면 실행될 이벤트
	  audioFileHiddenInput.addEventListener("change", async function(event){
		 
		 // 입력창 막음
		 aiMessageInput.disabled = true;
		 sendAiMessageBtn.disabled = true;
		 audioFileInputBtn.disabled = true;
		 const file = event.target.files[0]; // 첫번째 파일을 가져옴 
		 
		 console.log(file);
		 if(!file){ // 파일이 없으면 리턴
			 aiMessageInput.disabled = false;
			 sendAiMessageBtn.disabled = false;
			 audioFileInputBtn.disabled = false;
			 return;	
		 }
		 
		 const filename = file.name;
		 
		 // 사용자에게 파일 전송을 알림
		 appendMessage(`\${filename}`, 'user');
		 
		 // AI 로딩 인디케이터 표시
		 const loadingMessageElement = appendLoadingIndicator();
		 
		 // FormData 객체를 사용하여 파일 데이터 준비
		 const formData = new FormData();
		 formData.append("audio", file);
		 
		 try{
			 // 서버로 파일 전송 및 요약 결과 스트리밍 받기
			 const transcriptionResponse = await fetch("/meetings/generate-summary", {
				 method : 'POST',
				 body : formData, 
			 });
			 
			 if(!transcriptionResponse.ok){
				 aiMessageInput.disabled = false;
				 sendAiMessageBtn.disabled = false;
				 audioFileInputBtn.disabled = false;
				 updateLastAiMessage("음성 변환에 실패했습니다.");
				 return;
			 }
			 
	         const transcriptionData = await transcriptionResponse.json();
	         const transcribedText = transcriptionData.transcription;
			 
	         // 2. 변환된 텍스트를 서버로 보내서 요약
	         updateLastAiMessage("택스트를 요약 중입니다...");
	         
			 const summarizeResponse = await fetch('/meetings/summarize', {
				method : 'POST',
				headers : { 'Content-Type' : 'application/json' },
				body : JSON.stringify({ transcription : transcribedText })
			 });
			 
			 if(!summarizeResponse.ok){
				 aiMessageInput.disabled = false;
				 sendAiMessageBtn.disabled = false;
				 audioFileInputBtn.disabled = false;
				 updateLastAiMessage("요약에 실패했습니다.");
				 return;
			 }
			  
			  const summaryData = await summarizeResponse.json();
			  const summaryText = summaryData.summary; 
	         
			  // 3. 요약 결과를 다운로드 할 수 있는 파일로 만들고 메시지에 추가 
	          
	          const downloadResponse = await fetch('/meetings/download', {
					method : 'POST',
					headers : { 'Content-Type' : 'application/json' },
					body : JSON.stringify({ 
						content : summaryText,
						file_format : 'docx'
						
				 })
			  });
	          
			  // 응답은 바이너리
			  const blob = await downloadResponse.blob();
			  const url = window.URL.createObjectURL(blob);
			  
		      removeLoadingIndicator(loadingMessageElement);
				 
			  // 채팅창에 파일 메시지 추가
			  appendAiFileMessage(url, "회의록_요약.docx");
			  
			  
		 }catch(error){
	          console.error('Error:', error);
	          removeLoadingIndicator(loadingMessageElement);
			  aiMessageInput.disabled = false;
		 	  sendAiMessageBtn.disabled = false;
			  audioFileInputBtn.disabled = false;
	          updateLastAiMessage('파일 처리 중 오류가 발생했습니다. 다시 시도해 주세요.', 'ai');
		 }
		 

		 aiMessageInput.disabled = false;
		 sendAiMessageBtn.disabled = false;
		 audioFileInputBtn.disabled = false;
		 // 파일 입력창 초기화
		 event.target.value = '';
		 
	  });
	  
      // 채팅 메시지 파일 다운 
	  function appendAiFileMessage(fileUrl, fileName) {
	      let messageHtml = '';

	     // AI 메시지 HTML
	     messageHtml = `
	         <div class="message-group mb-3">
	             <div class="d-flex align-items-start">
	                 <div class="d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;">
	                     <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 48 48">
	                         <defs>
	                             <mask id="SVGSDSXGb1A">
	                                 <g fill="none">
	                                     <rect width="30" height="24" x="9" y="18" fill="#555555" stroke="#fff" stroke-width="4" rx="2" />
	                                     <circle cx="17" cy="26" r="2" fill="#fff" />
	                                     <circle cx="31" cy="26" r="2" fill="#fff" />
	                                     <path fill="#fff" d="M20 32a2 2 0 1 0 0 4zm8 4a2 2 0 1 0 0-4zm-8 0h8v-4h-8z" />
	                                     <path stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="M24 10v8M4 26v8m40-8v8" />
	                                     <circle cx="24" cy="8" r="2" stroke="#fff" stroke-width="4" />
	                                 </g>
	                             </mask>
	                         </defs>
	                         <path fill="#78bbe4" d="M0 0h48v48H0z" mask="url(#SVGSDSXGb1A)" />
	                     </svg>
	                 </div>
	                 <div>
	                     <div class="fw-semibold small text-muted mb-1">Groovy</div>
	                     <div class="bg-light p-2 rounded-3 mb-1" style="max-width:250px;">
	                      <a href="\${fileUrl}" download="\${fileName}" class="text-decoration-none"><i class="ti ti-paperclip me-2"></i> \${fileName}</a>
	                     </div>
	                 </div>
	             </div>
	         </div>`;
		      
			  console.log("ADDD");
		      aiChatMessages.insertAdjacentHTML('beforeend', messageHtml);
		      scrollToBottom();
	  }
  </script>
