package kr.or.ddit.employee.attendance.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.attendance.CompanyAnalyticsVO;
import kr.or.ddit.vo.attendance.CompanyYrycSttusVO;
import kr.or.ddit.vo.attendance.CountRequestVO;
import kr.or.ddit.vo.attendance.PaginationAttdInfoVO;
import kr.or.ddit.vo.attendance.WorkHistMdfncRequstVO;
import kr.or.ddit.vo.attendance.WorkHistVO;
import kr.or.ddit.vo.attendance.WorkRcordVO;
import kr.or.ddit.vo.attendance.WorkWeekRcordVO;
import kr.or.ddit.vo.attendance.YrycSttusVO;

@Mapper
public interface IAttendanceMapper {

	// 한 주간의 사원 근태 데이터를 일별로 가져오는 메서드
	public List<WorkRcordVO> getWeeklyWorkRecord(Map<String, Object> param);
	
	// 한 달간의 사원 근태 데이터를 주별로 가져오는 메서드
	public List<WorkWeekRcordVO> getMonthlyWorkRecord(Map<String, Object> param);

	// 기간내에 사원의 근무 이력 데이터를 가져오는 메서드
	public List<WorkHistVO> getRangeWorkHistory(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 조건에 맞는 이력 수를 가져오는 메서드
	public int getWorkHistoryCount(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 요청을 저장하는 메서드
	public int insertRequest(WorkHistMdfncRequstVO requestVO);
	
	// 근무 기록으로 근무 수정 요청 데이터를 가져오는 메서드
	public WorkHistMdfncRequstVO getRequest(int workRcordNo);

	// 엑셀 다운로드 용으로 기간 내의 데이터를 전부 가져오는 메서드
	public List<WorkHistVO> getExcelData(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 기간 내에 사원의 연차 내역을 가져오는 메서드
	public List<YrycSttusVO> getVacation(Map<String, Object> param);

	// 부서 리스트 가져오는 메서드
	public List<DeptVO> getDeptList();
	
	// 회사의 근태 기록을 가져오는 메서드
	public List<WorkRcordVO> getCompanyWorkRecord(PaginationAttdInfoVO<WorkRcordVO> pagingVO);
	
	// 기간 내의 회사인원 수를 구하는 메서드
	public int getHeadCount(PaginationAttdInfoVO<?> pagingVO);

	// 회사의 근태 기록 수를 가져오는 메서드
	public int getCompanyWorkRecordCount(PaginationAttdInfoVO<WorkRcordVO> pagingVO);

	// 엑셀 다운로드 용으로 기간 내의 회사 근태 데이터를 전부 가져오는 메서드
	public List<WorkRcordVO> getCompanyAttendanceExcelData(PaginationAttdInfoVO<WorkHistVO> pagingVO);

	// 회사의 부서별 통계 데이터를 가져오는 메서드
	public List<CompanyAnalyticsVO> companyDeptAnalytics(Map<String, Object> param);

	// 회사의 근무 형태별 통계 데이터를 가져오는 메서드
	public List<CompanyAnalyticsVO> companyWorkTypeAnalytics(Map<String, Object> param);

	// 회사 전체 연차 기록 수를 가져오는 메서드 
	public int getCountCompanyVacation(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO);

	// 회사의 년도별 총 사원 연차 현황을 가져오는 메서드
	public List<CompanyYrycSttusVO> getCompanyVacationRecord(PaginationAttdInfoVO<CompanyYrycSttusVO> pagingVO);

	// 모든 사원의 근태 요청 리스트를 가져오는 메서드
	public List<WorkHistMdfncRequstVO> getAllEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);
	
	// 모든 사원의 근태 요청 리스트를 수를 가져오는 메서드
	public CountRequestVO getAllEmpRequestListCount(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);

	// 사원의 근태 요청 리스트를 가져오는 메서드
	public List<WorkHistMdfncRequstVO> getEmpRequestList(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);

	// 사원의 근태 요청 리스트를 수를 가져오는 메서드
	public CountRequestVO getEmpRequestListCount(PaginationAttdInfoVO<WorkHistMdfncRequstVO> pagingVO);

	// 사원의 수정요청 상세 정보를 가져오는 메서드
	public WorkHistMdfncRequstVO getRequestDetail(int requestNo);
	
	// 요청 승인
	public int approveRequest(Map<String, Object> param);
	
	// 요청 거절
	public int rejectRequest(Map<String, Object> param);
	
	// 근태 시간 변경
	public void updateWorkRecordTime(Map<String, Object> param);

	// 요청 번호로 기록번호와 시간 가져오기
	public Map<String, Object> getUpdateRecordData(int requestNo);

	public void updateWorkHistStatus(Map<String, Object> param);
	
	// 연차를 추가할 사원 리스트 가져오기
	public List<EmpVO> getVacationEmpList(String formatDay);

	// 사원번호와 년도로 연차 추가
	public int insertYrycSttus(YrycSttusVO vacationVO);

	// 결근 처리할 사원 리스트 가져오기
	public List<EmpVO> getAttendanceEmpList(String formatDay);

}


