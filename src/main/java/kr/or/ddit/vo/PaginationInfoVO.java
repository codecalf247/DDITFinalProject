package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class PaginationInfoVO<T> {
	private int totalRecord;	// 총 게시글 수
	private int totalPage;		// 총 페이지 수
	private int currentPage;	// 현재 페이지
	private int screenSize = 10;// 페이지 당 게시글 수
	private int blockSize = 5;	// 페이지 블록 수
	private int startRow;		// 시작 row
	private int endRow;			// 끝 row
	private int startPage;		// 시작 page
	private int endPage;		// 끝 page
	private List<T> dataList;	// 결과를 넣을 데이터 리스트
	private String searchType;	// 검색 타입
	private String searchWord;	// 검색 단어
	private int formNo;
	private String empNo;	// 사원번호

	private String statusFilter; // 상태 필터 (normal, rent, repair 등)
	
	// EXTRA
	private T data;		
	private String fileTy;	// 프로젝트 파일 내 유형별용으로 사용
	
	public PaginationInfoVO() {}
	
	// PaginationInfoVO 객체를 만들 때, 한 페이지당 게시글 수와 페이지 블록 수를 원하는 값으로 초기화 할 수 있다.
	public PaginationInfoVO(int screenSize, int blockSize) {
		this.screenSize = screenSize;
		this.blockSize = blockSize;
	}
	
	public void setTotalRecord(int totalRecord) {
		// 총 게시글수를 저장하고, 총 게시글수를 페이지 당 나타낼 게시글 수로 나눠 총 페이지수를 구합니다.
		this.totalRecord = totalRecord;
		totalPage = (int) Math.ceil(totalRecord / (double)screenSize);
	}
	
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;	// 현재 페이지 저장
		// startRow, endRow는 screenSize의 값을 활용해서 공식화
		endRow = currentPage * screenSize;		// 끝 row = 현재 페이지 * 한 페이지당 게시글 수
		startRow = endRow - (screenSize - 1);	// 시작 row = 끝 row - (한 페이지당 게시글 수 - 1)
		// startPage, endPage는 blockSize의 값을 활용해서 공식화
		// 마지막 페이지 = (현재 페이지 + (페이지 블록 사이즈 - 1)) / 페이지 블록 사이즈 * 페이지 블록 사이즈
		// / blockSize * blockSize는 1,2,3,4,5... 페이지마다 실수 계산이 아닌 정수 계산을 이용해 endPage를 구함.
		endPage = (currentPage + (blockSize - 1)) / blockSize * blockSize;
		startPage = endPage - (blockSize - 1);	 // 시작 페이지 = 끝 페이지 - (페이지 블록 사이즈 - 1)
	}
	
	public String getPagingHTML() {
		// startPage는 1,6,11 이런 숫자로 증가해서 올라갑니다.
		// 1-5 범위안에 있는 경우는 Prev가 생성되지 않습니다.
		// 6 범위부터 Prev가 만들어지는 조건이 됩니다.
		StringBuffer html = new StringBuffer();
		html.append("<ul class='pagination'>");
		
		// 'Prev' 버튼은 현재 페이지가 blockSize(현재 5)를 넘었을 때 나타나야 합니다.
		// 현재 페이지가 1-5 사이의 범위에 있다면 startpage는 무조건 1이 됩니다.
		// 현재 페이지가 blockSize보다 큰 6~ 범위에 있을때부터 startPage는 blockSize 보다 큰 6부터 시작합니다.
		// 그런점을 고려한다면, 현재 페이지가 1보다 무조건 다음 페이지에 있어야만 'Prev' 버튼을 활용할 수 있으므로 조건식 작성
		// (blockSize가 5보다 작을 수 있음)
		if(startPage > 1) {
			html.append("<li class=page-item disabled'><a class='page-link' href='javascript:void(0)' data-page='" +
			(startPage - blockSize) + "' tabindex='-1' aria-disabled='true'>이전</a>");
		}
		
		// 반복문 내 조건은 총 페이지가 있고 현재 페이지에 따라 endPage 값이 결정됩니다.
		// 총 페이지가 14개고 현재 페이지가 9 페이지라면 넘어가야할 페이지가 남아 있는것이기 때문에 endPage만큼 반복됩니다.
		// 넘어가야할 페이지가 존재하지 않는 상태라면 마지막 페이지가 포함되어 있는 block영역이므로 totalPage만큼
		// 반복됩니다.
		for(int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
			if(i == currentPage) {
				html.append("<li class='page-item active' aria-current='page'><a class='page-link' href='javascript:void(0)'>" + 
				i + "</a></li>");
			}else {
				html.append("<li class='page-item'><a href='' class='page-link' data-page='" +
				i + "'>" + i + "</a></li>");
			}
		}
		
		if(endPage < totalPage) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='" + 
			(endPage + 1) + "'>다음</a></li>");
		}
		
		html.append("</ul>");
		return html.toString();
	}
	
	public String getPagingHTML2() {
	    StringBuffer html = new StringBuffer();
	    html.append("<nav aria-label='Page navigation'>");
	    html.append("<ul class='pagination justify-content-center'>");

	    // Prev 버튼
	    if(startPage > 1) {
	        html.append("<li class='page-item'>")
	            .append("<a class='page-link' href='?page=" + (startPage - blockSize) +
	                    (searchType != null ? "&searchType=" + searchType : "") +
	                    (searchWord != null ? "&searchWord=" + searchWord : "") +
	                    "'>Previous</a></li>");
	    } else {
	        html.append("<li class='page-item disabled'>")
	            .append("<a class='page-link' href='javascript:void(0)' tabindex='-1' aria-disabled='true'>Previous</a></li>");
	    }

	    // 페이지 번호
	    for(int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
	        if(i == currentPage) {
	            html.append("<li class='page-item active' aria-current='page'>")
	                .append("<a class='page-link' href='javascript:void(0)'>" + i + "</a></li>");
	        } else {
	            html.append("<li class='page-item'>")
	                .append("<a class='page-link' href='?page=" + i +
	                        (searchType != null ? "&searchType=" + searchType : "") +
	                        (searchWord != null ? "&searchWord=" + searchWord : "") +
	                        "'>" + i + "</a></li>");
	        }
	    }

	    // Next 버튼
	    if(endPage < totalPage) {
	        html.append("<li class='page-item'>")
	            .append("<a class='page-link' href='?page=" + (endPage + 1) +
	                    (searchType != null ? "&searchType=" + searchType : "") +
	                    (searchWord != null ? "&searchWord=" + searchWord : "") +
	                    "'>Next</a></li>");
	    } else {
	        html.append("<li class='page-item disabled'>")
	            .append("<a class='page-link' href='javascript:void(0)' tabindex='-1' aria-disabled='true'>Next</a></li>");
	    }

	    html.append("</ul>");
	    html.append("</nav>");
	    return html.toString();
	}

	
	
	
	
	
	
	
	
	
	// 프로젝트 페이지용!!!!!!!!!!!!!!!!!!!!!!!!!!!
	public String getPagingHTML2ForProject() {
		StringBuffer html = new StringBuffer();
		html.append("<nav aria-label='Page navigation'>");
		html.append("<ul class='pagination justify-content-center'>");

		// 1. prjctNo 값 추출 및 쿼리스트링 준비
		String prjctNoQuery = "";
		
		// this.data가 ProjectPhotosVO 타입이라고 가정하고 prjctNo를 추출합니다.
		if (this.data != null && this.data instanceof kr.or.ddit.vo.ProjectPhotosVO) {
		    // 안전하게 형변환하여 prjctNo를 가져옵니다.
		    Integer currentPrjctNo = ((kr.or.ddit.vo.ProjectPhotosVO) this.data).getPrjctNo();
		    
		    if (currentPrjctNo != null) {
		        prjctNoQuery = "&prjctNo=" + currentPrjctNo;
		    }
		}
		
		// 기존 검색 쿼리스트링 조합
	    String searchQuery = 
	            (searchType != null ? "&searchType=" + searchType : "") +
	            (searchWord != null ? "&searchWord=" + searchWord : "");

		// 2. Prev 버튼
		if(startPage > 1) {
			html.append("<li class='page-item'>")
			// 💡 prjctNo 쿼리스트링 추가
			.append("<a class='page-link' href='?page=" + (startPage - blockSize) +
					searchQuery +
					prjctNoQuery + 
					"'>Previous</a></li>");
		} else {
			html.append("<li class='page-item disabled'>")
			.append("<a class='page-link' href='javascript:void(0)' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}
		
		// 3. 페이지 번호
		for(int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
			if(i == currentPage) {
				html.append("<li class='page-item active' aria-current='page'>")
				.append("<a class='page-link' href='javascript:void(0)'>" + i + "</a></li>");
			} else {
				html.append("<li class='page-item'>")
				// 💡 prjctNo 쿼리스트링 추가
				.append("<a class='page-link' href='?page=" + i +
						searchQuery +
						prjctNoQuery +
						"'>" + i + "</a></li>");
			}
		}
		
		// 4. Next 버튼
		if(endPage < totalPage) {
			html.append("<li class='page-item'>")
			// 💡 prjctNo 쿼리스트링 추가
			.append("<a class='page-link' href='?page=" + (endPage + 1) +
					searchQuery +
					prjctNoQuery +
					"'>Next</a></li>");
		} else {
			html.append("<li class='page-item disabled'>")
			.append("<a class='page-link' href='javascript:void(0)' tabindex='-1' aria-disabled='true'>Next</a></li>");
		}
		
		html.append("</ul>");
		html.append("</nav>");
		return html.toString();
	}
	
}




















