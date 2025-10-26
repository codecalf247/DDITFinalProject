package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EmpVO {
	 private String empNo;				// 사원번호( ex. 202508001 )
	 private int deptNo;				// 부서번호
	 private String password;			// 비밀번호
	 private String jbgdCd;				// 직급코드((공통) 15001)
	 private String empNm;				// 사원명
	 private String brdt;				// 생년월일( ex. 20250825 )
	 private String email;				// 이메일
	 private String wnmpyEmail;			// 사내이메일( ex. 202508001@groovier.com )
	 private String telno;				// 전화번호 11자리( ex. 01012345678 )
	 private String extNo;				// 내선번호 10자리( ex. 0422520123 )
	 private String empZip;				// 우편코드 5자리
	 private String homeAddr;			// 기본주소 
	 private String homeDaddr;			// 상세주소
	 private String jncmpYmd;			// 입사일자( ex. 20250825 )
	 private String rsgntnYmd;			// 퇴사일자( ex. 20250825 )
	 private String bankCd;				// 은행코드((공통) 27001 )	
	 private String actno;				// 계좌번호
	 private String dpstrNm;			// 예금주명
	 private int salary;				// 연봉
	 private String profileFilePath;	// 프로필경로
	 private String signFilePath;		// 날인경로
	 private int userFolderUsgqty;		// 개인자료실 사용량(byte)
	 private String photoKey;			// 안면인식 key
	 private int enabled;				// 시큐리티?
	 private int upperDeptNo; /* SEQ_DEPT */
	 private int workTyNo; /* SEQ_WORK_TY */
	 
	 private String workYmd; // 출근일자
	 
	 private String deptNm; /* 부서명 */	 
	 private String jbgdNm; /* 직책명 */
	 private List<EmpAuthVO> authList;	// 권한정보
	 private List<DeptVO> deptList; // 부서 정보
	 
	 private MultipartFile profileImage;	// 이미지 파일 저장용
	 
}
