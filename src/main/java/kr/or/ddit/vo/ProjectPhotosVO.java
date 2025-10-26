package kr.or.ddit.vo;

import java.sql.Date;
import java.util.List;

import lombok.Data;


// 프로젝트 전체적인 VO

@Data
public class ProjectPhotosVO {

	private int sptPhotoNo; 			// 현장 사진 번호 
	private int prjctNo;				// 프로젝트 번호 
	private String empNo; 				// 사원 번호
	private String sptPhotoTitle; 		// 현장 사진 제목 
	private String sptPhotoYmd; 		// 혀장 사진 일자 
	private int fileGroupNo;			// 파일 그룹 번호 
	private String procsTy;				// 공통 코드 
	
	// 컨트롤러에서 받은 categories 목록을 담기 
	private List<String> categories; 
	
	private List<FilesVO> fileList; // 현장 사진에 속한 파일 목록 
	private String thumbnailPath; 	// 썸네일 파일 경로
}
