package kr.or.ddit.employee.attendance.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.MonthDay;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.attendance.mapper.IAttendanceMapper;
import kr.or.ddit.employee.main.mapper.ICommuteMapper;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.vo.attendance.WorkWeekRcordVO;
import kr.or.ddit.vo.attendance.YrycSttusVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.attendance.CompanyAnalyticsVO;
import kr.or.ddit.vo.attendance.CompanyAttendSearchVO;
import kr.or.ddit.vo.attendance.CompanyYrycSttusVO;
import kr.or.ddit.vo.attendance.CountRequestVO;
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistMdfncRequstVO;
import kr.or.ddit.vo.attendance.WorkHistVO;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class AttendanceServiceImpl implements IAttendanceService {

	// 저장 파일 경로
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private ICommuteMapper commuteMapper;
	
	@Autowired
	private IAttendanceMapper attendanceMapper;
	
	@Autowired
	private IFileMapper fileMapper;
	
	@Override
	public List<WorkRcordVO> getWeeklyWorkRecord(Map<String, Object> param) {
		return attendanceMapper.getWeeklyWorkRecord(param);
	}

	@Override
	public Map<String, Object> getRangeData(Map<String, Object> param) {

		Map<String, Object> result = new HashMap<>();
		String type = (String) param.get("type");
		String baseDate = (String) param.get("baseDate");
		int offset = (int) param.get("offset");
		List<WorkRcordVO> workRecordList = new ArrayList<>();
		List<WorkWeekRcordVO> workWeekRecordList = new ArrayList<>();
		String formatDay; // 포맷한 날짜(기준날짜)
		LocalDate base; // String -> LocalDate 변환 날짜
		LocalDate monday = null; // 화면용 날짜 (월)
		LocalDate sunday = null; // 화면용 날짜 (일)

		// baseDate 문자열 → LocalDate 변환

		base = LocalDate.parse(baseDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		if ("week".equals(type)) {
			if (offset > 0) {
				// 다음 주
				base = base.plusWeeks(1); // 기준일에서 1주 더함
			} else if (offset < 0) {
				// 이전 주
				base = base.minusWeeks(1); // 기준일에서 1주 빼기
			}
			monday = base.with(DayOfWeek.MONDAY);
			sunday = monday.plusDays(6);

			formatDay = base.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			param.put("formatDay", formatDay);

			workRecordList = attendanceMapper.getWeeklyWorkRecord(param);

			result.put("workRecordList", workRecordList);
			result.put("monday", monday);
			result.put("sunday", sunday);

		} else if ("month".equals(type)) {

			// 이번달 시작일
			base = base.withDayOfMonth(1);

			// offset 값에 따라 이전/다음 달 계산
			if (offset > 0) {
				// 다음 달
				base = base.plusMonths(1);
			} else if (offset < 0) {
				// 이전 달
				base = base.minusMonths(1);
			}

			formatDay = base.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
			param.put("formatDay", formatDay);

			log.info(param.toString());

			workWeekRecordList = attendanceMapper.getMonthlyWorkRecord(param);

			result.put("workWeekRecordList", workWeekRecordList);
			result.put("month", base);
		}

		return result;
	}

	@Override
	public List<WorkHistVO> getRangeWorkHistory(PaginationAttdInfoVO<WorkHistVO> pagingVO) {

		List<WorkHistVO> workHistList = new ArrayList<>();

		// 총 게시글 수 가져오기
		int totalRecord = attendanceMapper.getWorkHistoryCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);
		
		workHistList = attendanceMapper.getRangeWorkHistory(pagingVO);

		return workHistList;
	}

	@Override
	public ServiceResult updateRequest(Map<String, Object> param) {

		ServiceResult result = null;

		WorkHistMdfncRequstVO requestVO = (WorkHistMdfncRequstVO) param.get("requestVO");
		String empNo = (String) param.get("empNo");

		MultipartFile attachFile = requestVO.getAttachFile();
		
		// 1. 파일 저장 
		if (attachFile != null && !attachFile.isEmpty()) {
			
			// 파일 그룹 번호 생성
			int fileGroupNo = fileMapper.createFileGroupNo();
			
			String originalFileName = attachFile.getOriginalFilename();
			String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

			FilesVO fileVO = new FilesVO();

			fileVO.setFileGroupNo(fileGroupNo);
			fileVO.setOriginalNm(originalFileName);
			fileVO.setSavedNm(saveFileName);
			fileVO.setFilePath("/upload/attendanceRequest/" + saveFileName);
			fileVO.setFileSize((int) attachFile.getSize());
			fileVO.setFileUploader(empNo);
			fileVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fileVO.getFileSize()));
			fileVO.setFileMime(attachFile.getContentType());

			fileMapper.insertFile(fileVO);
			
			// path에 저장
			File saveFile = new File(uploadPath + "attendanceRequest/" + saveFileName);
			
			try {
				attachFile.transferTo(saveFile);
				requestVO.setFileGroupNo(fileGroupNo);	// 파일 그룹 번호 저장
			} catch (IOException e) {
				log.error("파일 업로드 중 오류 발생: {}", e.getMessage(), e);
				return ServiceResult.FAILED;
			}
		}
		requestVO.setRequstTime(requestVO.getRequstTime().replace(":", ""));	// 시간 저장
		
		// 2. 요청 저장
		int count = attendanceMapper.insertRequest(requestVO);
		
		if(count > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public WorkHistMdfncRequstVO getRequest(int workRcordNo) {
		return attendanceMapper.getRequest(workRcordNo);
	}

	@Override
	public ResponseEntity<byte[]> downloadFile(String fileName) {
		
		InputStream in = null;
	    ResponseEntity<byte[]> entity = null;

	    try {
	        // 서버에 저장된 전체 경로
	        String fullFilePath = uploadPath + File.separator + "attendanceRequest" + File.separator + fileName;

	        in = new FileInputStream(fullFilePath);

	        // 다운로드용 헤더 설정
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM); // 무조건 다운로드
	        String originalFileName = fileName.substring(fileName.indexOf("_") + 1); // UUID 제거 등
	        headers.add("Content-Disposition", "attachment; filename=\"" +
	                new String(originalFileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");

	        // 파일 byte 배열로 변환
	        entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	    } finally {
	        if (in != null) try { in.close(); } catch (IOException e) { e.printStackTrace(); }
	    }

	    return entity;
	}

	@Override
	public List<WorkHistVO> getExcelData(@RequestBody PaginationAttdInfoVO<WorkHistVO> pagingVO) {
		
		List<WorkHistVO> workHistList = new ArrayList<>();

		workHistList = attendanceMapper.getExcelData(pagingVO);

		return workHistList;
	}

	@Override
	public List<YrycSttusVO> getVacation(Map<String, Object> param) {
		return attendanceMapper.getVacation(param);
	}

	@Override
	public Map<String, Object> getVacationRangeData(Map<String, Object> param) {
		
		Map<String, Object> result = new HashMap<>(); 	// 결과를 담을 Map
		List<YrycSttusVO> vacationList = new ArrayList<>(); // 연차기록을 담을 List
		
		// 받아온 파라미터 
		int year = (int) param.get("year");
		int offset = (int) param.get("offset");

		if(offset > 0) { // 다음 년도
			year++;
		}else if(offset < 0){ // 전 년도
			year--;
		}
		
		// 변경된 날짜 삽입
		param.put("year", year);
		
		// 연차 이력 가져오기
		vacationList = attendanceMapper.getVacation(param);
		
		result.put("year", year);
		result.put("vacationList", vacationList);

		return result;
	}

	@Override
	public List<DeptVO> getDeptList() {
		return attendanceMapper.getDeptList();
	}

	@Override
	public List<WorkRcordVO> getCompanyWorkRecord(PaginationAttdInfoVO<WorkRcordVO> pagingVO) {
		
		List<WorkRcordVO> workRecordList = new ArrayList<>();

		// 총 게시글 수 가져오기
		int totalRecord = attendanceMapper.getCompanyWorkRecordCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);
		
		workRecordList = attendanceMapper.getCompanyWorkRecord(pagingVO);

		return workRecordList;
	}

	@Override
	public int getHeadCount(PaginationAttdInfoVO<?> pagingVO) {
		return attendanceMapper.getHeadCount(pagingVO);
	}

	@Override
	public Map<String, Object> getChangeCompanyAttend(PaginationAttdInfoVO<WorkRcordVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<>();
		List<WorkRcordVO> companyWorkRecordList = new ArrayList<>();
		
		// yyyy-MM-dd 형식을 yyyyMMdd 형식으로
		LocalDate startDay = LocalDate.parse(pagingVO.getStartDay(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		LocalDate endDay = LocalDate.parse(pagingVO.getEndDay(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		
		pagingVO.setStartDay(startDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setEndDay(endDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		
		// headCount 
		int headCount = attendanceMapper.getHeadCount(pagingVO);
		
		// 총 게시글 수 가져오기
		int totalRecord = attendanceMapper.getCompanyWorkRecordCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);
		
		// companyWorkRecordList
		companyWorkRecordList = attendanceMapper.getCompanyWorkRecord(pagingVO);
		
		pagingVO.setDataList(companyWorkRecordList);
		
		result.put("headCount", headCount);
		result.put("pagingVO", pagingVO);
		
		return result;
	}

	@Override
	public List<WorkRcordVO> getCompanyAttendanceExcelData(PaginationAttdInfoVO<WorkHistVO> pagingVO) {
		
		List<WorkRcordVO> workRecordList = new ArrayList<>();

		LocalDate startDay = LocalDate.parse(pagingVO.getStartDay(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		LocalDate endDay = LocalDate.parse(pagingVO.getEndDay(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		
		pagingVO.setStartDay(startDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setEndDay(endDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		
		workRecordList = attendanceMapper.getCompanyAttendanceExcelData(pagingVO);

		return workRecordList;
	}

	@Override
	public List<CompanyAnalyticsVO> companyDeptAnalytics(Map<String, Object> param) {
		return attendanceMapper.companyDeptAnalytics(param);
	}

	@Override
	public List<CompanyAnalyticsVO> companyWorkTypeAnalytics(Map<String, Object> param) {
		return attendanceMapper.companyWorkTypeAnalytics(param);
	}

	@Override
	public Map<String, Object> getCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<>();
		List<CompanyYrycSttusVO> companyVacationList = new ArrayList<>();
		
		// headCount 
		int headCount = attendanceMapper.getHeadCount(pagingVO);
		
		// 총 게시글 수 가져오기
		int totalRecord = attendanceMapper.getCountCompanyVacation(pagingVO);
		
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);
		
		// companyWorkRecordList
		companyVacationList = attendanceMapper.getCompanyVacationRecord(pagingVO);
		
		pagingVO.setDataList(companyVacationList);
		
		result.put("headCount", headCount);
		result.put("pagingVO", pagingVO);
		
		return result;
	}

	@Override
	public Map<String, Object> changeCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<>();
		List<CompanyYrycSttusVO> companyVacationList = new ArrayList<>();
		
		int year = pagingVO.getYear();
        
		LocalDate startDay = LocalDate.of(year, 1, 1);
        LocalDate endDay = LocalDate.of(year, 12, 31);
        
		pagingVO.setStartDay(startDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		pagingVO.setEndDay(endDay.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		
		// headCount 
		int headCount = attendanceMapper.getHeadCount(pagingVO);
		
		// 총 게시글 수 가져오기
		int totalRecord = attendanceMapper.getCountCompanyVacation(pagingVO);
		
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);
		
		// companyWorkRecordList
		companyVacationList = attendanceMapper.getCompanyVacationRecord(pagingVO);
		
		pagingVO.setDataList(companyVacationList);
		
		result.put("headCount", headCount);
		result.put("pagingVO", pagingVO);
		
		return result;
	}

	@Override
	public Map<String, Object> getAllEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<WorkHistMdfncRequstVO> requestList = new ArrayList<>();

		// 총 게시글 수 가져오기
		CountRequestVO countRequestVO = attendanceMapper.getAllEmpRequestListCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(countRequestVO.getTotalCount());
		
		requestList = attendanceMapper.getAllEmpRequestList(pagingVO);
		
		result.put("countRequestVO", countRequestVO);
		result.put("requestList", requestList);
		
		return result;
	}

	@Override
	public Map<String, Object> getEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<WorkHistMdfncRequstVO> requestList = new ArrayList<>();

		// 총 게시글 수 가져오기
		CountRequestVO countRequestVO = attendanceMapper.getEmpRequestListCount(pagingVO);
		// 총 게시글 수 설정, 총 페이지 수 설정
		pagingVO.setTotalRecord(countRequestVO.getTotalCount());
		
		requestList = attendanceMapper.getEmpRequestList(pagingVO);
		
		result.put("countRequestVO", countRequestVO);
		result.put("requestList", requestList);
		
		return result;
	}

	@Override
	public WorkHistMdfncRequstVO getRequestDetail(int requestNo) {
		return attendanceMapper.getRequestDetail(requestNo);
	}

	@Override
	public ServiceResult updateRequestStatus(Map<String, Object> param) {
		
		ServiceResult result = null;

	    String status = (String) param.get("status");
	    int cnt = 0;
	    
	    if("approve".equals(status)) {
	    	// 1. 요청 상태 변경 (상태)
	    	cnt = attendanceMapper.approveRequest(param);
	    	
	    	// 2. work_rcord_no, requst_time 가져오기
	    	Map<String, Object> data = attendanceMapper.getUpdateRecordData(Integer.parseInt((String) param.get("requestNo")));
	    	
	    	param.put("time", data.get("TIME"));
	    	param.put("recordNo", data.get("RECORDNO"));
	    	param.put("type", data.get("TYPE"));
	    	
	    	// 3. 근태 시간 변경
	    	attendanceMapper.updateWorkRecordTime(param);
	    	
	    	// 4. 근태 이력 변경
	    	attendanceMapper.updateWorkHistStatus(param);
	    	
	    }else {
	    	// 1. 요청 상태 변경 (거절사유, 상태)
	    	cnt = attendanceMapper.rejectRequest(param);
	    }
	    
	    if(cnt > 0) {
	    	result = ServiceResult.OK;
	    }else {
			result = ServiceResult.FAILED;
		}

		
		return result;
	}
	
	// ================= 스케쥴러 ========================

	@Override
	public int manageYearVacation(String formatDay) {
		
		// 1. 입사월일이 formatDay인 사원 데이터를 가져옴 ( 해당 연도 제외 / 퇴사 안함 / 월일 같음 ) 
		List<EmpVO> empList = attendanceMapper.getVacationEmpList(formatDay);
		
		// 2. 가져온 데이터로 연차 삽입
		int cnt = 0;
		
		for(EmpVO empVO : empList) {
			YrycSttusVO vacationVO = new YrycSttusVO();
			vacationVO.setEmpNo(empVO.getEmpNo());
			vacationVO.setIssuYr(formatDay.substring(0, 4));
			
			cnt += attendanceMapper.insertYrycSttus(vacationVO);
		}
		
		return cnt;
	}

	@Override
	public int manageAttendance(String formatDay) {
		
		//  1.직원 중에 기록이 없는사람(연차 등 제외)를 데이터를 가져옴 ( 해당 날짜 / 근태 기록이 없는 사람  )
		List<EmpVO> empList = attendanceMapper.getAttendanceEmpList(formatDay);
		
		// 2. 유형이 '01006'(결근)으로 insert
		int cnt = 0;
		
		for(EmpVO empVO : empList) {
			WorkRcordVO recordVO = new WorkRcordVO();
			
			recordVO.setEmpNo(empVO.getEmpNo());
			recordVO.setWorkYmd(formatDay);
			recordVO.setBeginTime(null);
			recordVO.setEndTime(null);
			recordVO.setWorkSttus("01006");
			
			commuteMapper.insertWorkRecord(recordVO);
			cnt += commuteMapper.insertWorkHistory(recordVO);
		}
		
		return cnt;
	}

	// ================= 스케쥴러 ========================
}
