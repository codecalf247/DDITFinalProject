package kr.or.ddit.employee.attendance.service;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.attendance.CompanyAnalyticsVO;
import kr.or.ddit.vo.attendance.CompanyAttendSearchVO;
import kr.or.ddit.vo.attendance.CompanyYrycSttusVO;
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistMdfncRequstVO;
import kr.or.ddit.vo.attendance.WorkHistVO;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import kr.or.ddit.vo.attendance.YrycSttusVO;

public interface IAttendanceService {

	// 날짜로 사원의 주간 데이터를 가져오는 메서드
	public List<WorkRcordVO> getWeeklyWorkRecord(Map<String, Object> param);
	
	// 사원의 주/월간 데이터를 가져오는 메서드 
	public Map<String, Object> getRangeData(Map<String, Object> param);

	// 기간내에 사원의 근무 이력 데이터를 가져오는 메서드
	public List<WorkHistVO> getRangeWorkHistory(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 근무 이력 수정 요청을 보내는 메서드
	public ServiceResult updateRequest(Map<String, Object> param);
	
	// 근무 기록으로 근무 수정 요청 데이터를 가져오는 메서드
	public WorkHistMdfncRequstVO getRequest(int workRcordNo);
	
	// 요청 첨부파일 다운로드 메서드
	public ResponseEntity<byte[]> downloadFile(String fileName);

	// 엑셀 다운로드 용으로 기간 내의 데이터를 전부 가져오는 메서드
	public List<WorkHistVO> getExcelData(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 사원의 최근 년간 연차 내역을 가져오는 메서드
	public List<YrycSttusVO> getVacation(Map<String, Object> param);

	// 사원의 지정된 연도의 년간 연차 내역을 가져오는 메서드
	public Map<String, Object> getVacationRangeData(Map<String, Object> param);

	// 부서 리스트 가져오는 메서드
	public List<DeptVO> getDeptList();
	
	// 회사의 근태 기록을 가져오는 메서드
	public List<WorkRcordVO> getCompanyWorkRecord(PaginationAttdInfoVO<WorkRcordVO> pagingVO);
	
	// 기간 내의 회사인원 수를 구하는 메서드
	public int getHeadCount(PaginationAttdInfoVO<?> pagingVO);
	
	// 검색결과로 회사의 근태 기록을 가져오는 메서드
	public Map<String, Object> getChangeCompanyAttend(PaginationAttdInfoVO<WorkRcordVO> pagingVO);

	// 엑셀 다운로드 용으로 기간 내의 회사 근태 데이터를 전부 가져오는 메서드
	public List<WorkRcordVO> getCompanyAttendanceExcelData(PaginationAttdInfoVO<WorkHistVO> pagingVO);
	
	// 회사의 부서별 통계 데이터를 가져오는 메서드
	public List<CompanyAnalyticsVO> companyDeptAnalytics(Map<String, Object> param);
	
	// 회사의 근무 형태별 통계 데이터를 가져오는 메서드
	public List<CompanyAnalyticsVO> companyWorkTypeAnalytics(Map<String, Object> param);

	// 회사의 올해 총 사원 연차 현황을 가져오는 메서드
	public Map<String, Object> getCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO);
	
	// 회사의 지정된 년도의 총 사원 연차 현황을 가져오는 메서드
	public Map<String, Object> changeCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO);

	// 모든 사원의 근태 요청 리스트를 가져오는 메서드
	public Map<String, Object> getAllEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);

	// 사원의 근태 요청 리스트를 가져오는 메서드
	public Map<String, Object> getEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);
	
	// 사원의 수정요청 상세 정보를 가져오는 메서드
	public WorkHistMdfncRequstVO getRequestDetail(int requestNo);
	
	// 근태 수정 요청 처리를 하는 메서드
	public ServiceResult updateRequestStatus(Map<String, Object> param);

	// ============= 스케쥴러 =======================
	// 하루마다 연차를 삽입하는 메서드
	public int manageYearVacation(String formatDay);
	
	// 하루마다 근태를 수정하는 메서드
	public int manageAttendance(String formatDay);
	
	// ============= 스케쥴러 =======================

}
