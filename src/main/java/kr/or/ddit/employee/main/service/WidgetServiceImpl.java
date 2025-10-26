package kr.or.ddit.employee.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.main.mapper.IWidgetMapper;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SchdulVO;
import kr.or.ddit.vo.main.AttendanceWidgetVO;
import kr.or.ddit.vo.main.ProjectWidgetVO;
import kr.or.ddit.vo.main.TaskWidgetVO;
import kr.or.ddit.vo.main.TodoWidgetVO;
import kr.or.ddit.vo.main.WidgetVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional
public class WidgetServiceImpl implements IWidgetService {
	
	@Autowired
	private IWidgetMapper mapper;
	
	@Override
	public List<WidgetVO> getAllWidget(String empNo) {
		return mapper.getAllWidget(empNo);
	}

	@Override
	public AttendanceWidgetVO getAttendanceWidget(String empNo) {
		return mapper.getAttendanceWidget(empNo);
	}

	@Override
	public List<TodoWidgetVO> getTodoWidget(String empNo) {
		return mapper.getTodoWidget(empNo);
	}

	@Override
	public List<BoardVO> getNoticeWidget() {
		return mapper.getNoticeWidget();
	}

	@Override
	public List<SchdulVO> getSchdulWidget(EmpVO empVO) {
		return mapper.getSchdulWidget(empVO);
	}

	@Override
	public int insertSchdule(SchdulVO schdulVO) {
		return mapper.insertSchdule(schdulVO);
	}

	@Override
	public SchdulVO getSchdulByNo(int schdulNo) {
		return mapper.getSchdulByNo(schdulNo);
	}

	@Override
	public ServiceResult updateSchdul(SchdulVO schdulVO) {
		
		ServiceResult result = null;
		
		int status = mapper.updateSchdul(schdulVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult deleteSchdul(int schdulNo) {
		
		ServiceResult result = null;
		
		int status = mapper.deleteSchdul(schdulNo);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public int insertTodo(TodoWidgetVO todoVO) {
		return mapper.insertTodo(todoVO);
	}

	@Override
	public TodoWidgetVO getTodoByNo(int todoNo) {
		return mapper.getTodoByNo(todoNo);
	}

	@Override
	public ServiceResult updateTodoCheck(TodoWidgetVO todo) {
		
		ServiceResult result = null;
		
		int status = mapper.updateTodoCheck(todo);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult deleteTodo(List<Integer> todoIds) {
		ServiceResult result = null;
		
		int status = mapper.deleteTodo(todoIds);
		
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<ProjectWidgetVO> getProjectWidget(String empNo) {
		return mapper.getProjectWidget(empNo);
	}

	@Override
	public List<TaskWidgetVO> getTaskWidget(String empNo) {
		return mapper.getTaskWidget(empNo);
	}

	@Override
	public WidgetVO getWidgetByType(String type) {
		return mapper.getWidgetByType(type);
	}

	@Override
	public ServiceResult modifyWidget(List<WidgetVO> widgets, String empNo) {
		
		// 1. 사용자 위젯 전부 삭제 
		mapper.deleteAllWidget(empNo);
		
		// 2. 받아온 위젯 데이터로 다시 삽입
		if(widgets != null && !widgets.isEmpty() ) {
 			for(WidgetVO w : widgets) {
				mapper.insertWidgets(w);
			}
		}
		return ServiceResult.OK;
	}
	
}
