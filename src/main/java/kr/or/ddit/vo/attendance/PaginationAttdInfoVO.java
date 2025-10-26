package kr.or.ddit.vo.attendance;

import java.util.List;

import lombok.Data;

@Data
public class PaginationAttdInfoVO<T> {
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
	private T data;				// 타입 설정된 객체 데이터 
	private String searchType;	// 검색 타입
	private String searchWord;	// 검색 단어
	
	private String empNo;		// 사원번호
	private String empNm;		// 사원이름
	private String startDay;	// 시작일
	private String endDay;		// 종료일 
    private Integer deptNo;		// 부서번호
    private String status;		// 상태번호
    private int year;			// 기준년도
	
	public PaginationAttdInfoVO() {}
	
	// PaginationInfoVO 객체를 만들 때, 한 페이지당 게시글 수와 페이지 블록 수를 원하는 값으로 초기화 할 수 있다.
	public PaginationAttdInfoVO(int screenSize, int blockSize) {
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
	    StringBuilder html = new StringBuilder();
	    html.append("<nav aria-label='Page navigation'>");
	    html.append("<ul class='pagination mb-0'>");

	    // 'Prev' 버튼
	    if(startPage > 1) {
	        html.append("<li class='page-item'>")
	            .append("<a class='page-link' href='javascript:void(0)' data-page='")
	            .append(startPage - blockSize)
	            .append("' tabindex='-1'>Previous</a></li>");
	    } else {
	        html.append("<li class='page-item disabled'>")
	            .append("<a class='page-link' href='javascript:void(0)' tabindex='-1' aria-disabled='true'>Previous</a></li>");
	    }

	    // 페이지 번호
	    for(int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
	        if(i == currentPage) {
	            html.append("<li class='page-item active' aria-current='page'>")
	                .append("<a class='page-link' href='javascript:void(0)'>")
	                .append(i)
	                .append("</a></li>");
	        } else {
	            html.append("<li class='page-item'>")
	                .append("<a class='page-link' href='javascript:void(0)' data-page='")
	                .append(i)
	                .append("'>")
	                .append(i)
	                .append("</a></li>");
	        }
	    }

	    // 'Next' 버튼
	    if(endPage < totalPage) {
	        html.append("<li class='page-item'>")
	            .append("<a class='page-link' href='javascript:void(0)' data-page='")
	            .append(endPage + 1)
	            .append("'>Next</a></li>");
	    } else {
	        html.append("<li class='page-item disabled'>")
	            .append("<a class='page-link' href='javascript:void(0)' aria-disabled='true'>Next</a></li>");
	    }

	    html.append("</ul>");
	    html.append("</nav>");

	    return html.toString();
	}
	
}




















