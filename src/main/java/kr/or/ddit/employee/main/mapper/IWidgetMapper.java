package kr.or.ddit.employee.main.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SchdulVO;
import kr.or.ddit.vo.main.AttendanceWidgetVO;
import kr.or.ddit.vo.main.ProjectWidgetVO;
import kr.or.ddit.vo.main.TaskWidgetVO;
import kr.or.ddit.vo.main.TodoWidgetVO;
import kr.or.ddit.vo.main.WidgetVO;

@Mapper
public interface IWidgetMapper {

	// 사용자 위젯 정보를 가져오는 메서드
	public List<WidgetVO> getAllWidget(String empNo);

	// 출퇴근 위젯 정보를 가져오는 메서드
	public AttendanceWidgetVO getAttendanceWidget(String empNo);

	// 투두리스트 위젯 정보를 리스트로 가져오는 메서드
	public List<TodoWidgetVO> getTodoWidget(String empNo);

	// 공지사항 위젯 정보를 리스트로 가져오는 메서드
	public List<BoardVO> getNoticeWidget();

	// 캘린더 위젯 정보를 리스트로 가져오는 메서드
	public List<SchdulVO> getSchdulWidget(EmpVO empVO);
	
	// 캘린더 일정을 삽입하는 메서드
	public int insertSchdule(SchdulVO schdulVO);

	// 일정 번호로 데이터를 가져오는 메서드
	public SchdulVO getSchdulByNo(int schdulNo);

	// 캘린더 일정을 수정하는 메서드
	public int updateSchdul(SchdulVO schdulVO);

	// 캘린더 일정을 삭제하는 메서드
	public int deleteSchdul(int schdulNo);

	// 투두리스트 데이터를 삽입하는 메서드
	public int insertTodo(TodoWidgetVO todoVO);

	// 투두번호로 데이터를 가져오는 메서드
	public TodoWidgetVO getTodoByNo(int todoNo);

	// 투두 채크박스를 업데이트 하는 메서드
	public int updateTodoCheck(TodoWidgetVO todo);

	// 투두리스트 데이터 삭제 메서드
	public int deleteTodo(List<Integer> todoIds);

	// 프로젝트 위젯 정보를 가져오는 메서드
	public List<ProjectWidgetVO> getProjectWidget(String empNo);

	// 나의 일감 위젯 정보를 가져오는 메서드
	public List<TaskWidgetVO> getTaskWidget(String empNo);
	
	// 타입으로 위젯의 기본 정보를 가져오는 메서드
	public WidgetVO getWidgetByType(String type);
	
	// 사용자의 모든 위젯을 삭제하는 메서드
	public void deleteAllWidget(String empNo);
	
	// 저장된 위젯 데이터를 삽입하는 메서드
	public int insertWidgets(WidgetVO widget);
}
