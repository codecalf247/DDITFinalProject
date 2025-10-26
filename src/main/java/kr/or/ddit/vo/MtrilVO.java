package kr.or.ddit.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MtrilVO {

	
	// ===== 기본 자재 =====
    private String  mtrilId;      // 자재ID (SEQ_MTRIL)
    private String  mtrilTy;      // 자재유형 (공통코드 그룹 16)
    private String  unit;         // 단위 (공통코드 그룹 14)
    private String  mtrilNm;      // 자재명
    private int     stock;        // 현재 재고 수량
    private int     minStock;     // 최소 재고 수량
    private Integer fileGroupNo;  // 파일그룹번호 (nullable)
    private String  mtrilDc;      // 자재설명 (nullable)

    // ===== 자재 이력(MTRIL_HIST) =====
    private int mtrilHistNo;  // 자재이력번호 (PK)
    private String  empNo;        // 사원번호 (6자리년월 + 3자리 순번)
    private String  inoutTy;      // 입출고유형 ("1"=입고, "0"=출고)
    private int     inoutQy;      // 입출고 수량
    private String  inoutDt;      // 입출고 일시 (DB SYSDATE -> String 매핑)
    private String  sptNm;        // 현장명 (nullable)
    private String  memo;         // 메모 (nullable)

    // ===== 표시/조인 필드 =====
    private String  filePath;     // 대표 이미지 경로
    private String  mtrilTyNm;    // 자재유형명
    private String  unitNm;       // 단위명
    private String  stockStatus;  // 'normal' | 'shortage'

    // ===== 업로드 =====
    private MultipartFile uploadFile; // 자재 이미지

    // ===== 편의 상수/유틸 =====
    public static final String IN  = "1"; // 입고
    public static final String OUT = "0"; // 출고

    public boolean isIn()  { return IN.equals(this.inoutTy); }
    public boolean isOut() { return OUT.equals(this.inoutTy); }
}