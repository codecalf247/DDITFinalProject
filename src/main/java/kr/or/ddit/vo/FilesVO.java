	package kr.or.ddit.vo;
	
	import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
	
	@Data
	public class FilesVO {
	
		 private int fileGroupNo;  			// 파일 그룹 번호
		 private int fileNo;			    // 파일 번호
		 private String originalNm;			// 원본 명
		 private String fileUploader;  		// 파일 업로더
		 private String savedNm;			// 저장된 명
		 private String filePath;			// 파일 경로
		 private long fileSize;				// 파일 크기
		 private String fileFancysize; 		// 파일 크기 단위
		 private String fileMime;			// 파일 MIME (/JPG,PNG,/GIF)
		 private String fileRegDt;			// 파일 등록 일시
		 private String delYn;				// 삭제 여부
		 
		 private List<FilesVO> fileList;    // 이 게시글에 속한 파일 목록을 담을 필드
		 
		 public FilesVO() {
			 
		 }
		 public FilesVO(MultipartFile item) {
			 this.originalNm = item.getOriginalFilename();
			 this.fileSize = item.getSize();
			 this.fileMime = item.getContentType();
			 this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
		 }
		 
	}
