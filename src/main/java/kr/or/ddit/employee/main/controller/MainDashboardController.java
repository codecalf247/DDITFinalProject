package kr.or.ddit.employee.main.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.main.service.IWidgetService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SchdulVO;
import kr.or.ddit.vo.main.AttendanceWidgetVO;
import kr.or.ddit.vo.main.ProjectWidgetVO;
import kr.or.ddit.vo.main.ResponseWidgetVO;
import kr.or.ddit.vo.main.TaskWidgetVO;
import kr.or.ddit.vo.main.TodoWidgetVO;
import kr.or.ddit.vo.main.WidgetVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main")
public class MainDashboardController {

	@Autowired
	private IWidgetService widgetService;

	@GetMapping("/dashboard")
	public String mainDashboard(Model model, @AuthenticationPrincipal CustomUser user) {

		log.info("mainDashboard() 실행...!");
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername(); // 로그인 사용자 정보

		// 사용자 전체 위젯 조회
		List<WidgetVO> widgets = widgetService.getAllWidget(empNo);
		model.addAttribute("widgets", widgets);

		for (WidgetVO w : widgets) {

			// 캘린더 위젯이 있다면
			if (w.getWidgetTy().equals("26001")) {
				// 캘린더 정보 전달
				List<SchdulVO> schdulList = widgetService.getSchdulWidget(empVO);
				model.addAttribute("schdulList", schdulList);
			}

			// 출퇴근 위젯이 있다면
			else if (w.getWidgetTy().equals("26002")) {
				// 출퇴근 정보 전달
				AttendanceWidgetVO attendanceWidgetVO = widgetService.getAttendanceWidget(empNo);
				model.addAttribute("attendanceWidgetVO", attendanceWidgetVO);
			}

			// 투두리스트 위젯이 있다면
			else if (w.getWidgetTy().equals("26003")) {
				// 투두리스트 정보 전달
				List<TodoWidgetVO> todoList = widgetService.getTodoWidget(empNo);
				model.addAttribute("todoList", todoList);
			}

			// 공지사항 위젯이 있다면
			else if (w.getWidgetTy().equals("26004")) {
				// 공지사항 정보 전달
				List<BoardVO> noticeList = widgetService.getNoticeWidget();
				model.addAttribute("noticeList", noticeList);
			}

			// 프로젝트 위젯이 있다면
			else if (w.getWidgetTy().equals("26005")) {
				// 진행중인 프로젝트 정보 전달
				List<ProjectWidgetVO> projectList = widgetService.getProjectWidget(empNo);
				model.addAttribute("projectList", projectList);
			}
			
			// 나의 일감 위젯이 있다면
			else if  (w.getWidgetTy().equals("26006")) {
				// 나의 일감 정보 전달
				List<TaskWidgetVO> taskList = widgetService.getTaskWidget(empNo);
				model.addAttribute("taskList", taskList);
			}
		}

		return "main/dashboard";
	}

	// 캘린더 목록
	@ResponseBody
	@PostMapping("/schdulList")
	public ResponseEntity<List<SchdulVO>> schdulList(@AuthenticationPrincipal CustomUser user) {
		List<SchdulVO> schdulList = widgetService.getSchdulWidget(user.getMember());
		return new ResponseEntity<List<SchdulVO>>(schdulList, HttpStatus.OK);
	}

	// 일정 등록
	@ResponseBody
	@PostMapping("/addEvent")
	public ResponseEntity<SchdulVO> addEvent(@AuthenticationPrincipal CustomUser user, @RequestBody SchdulVO schdulVO) {

		// 유저 정보 가져오기
		EmpVO emp = user.getMember();

		// 일정에 정보 저장
		schdulVO.setEmpNo(emp.getEmpNo()); // 사원번호
		schdulVO.setAlldayAt("false");
		// 일정 유형이 부서면
		if (schdulVO.getSchdulTy().equals("11002")) {
			// 부서번호 삽입
			schdulVO.setDeptNo(emp.getDeptNo());
		}

		// 일정 insert
		widgetService.insertSchdule(schdulVO);

		// 일정 번호로 데이터 가져와서 return
		SchdulVO schdul = widgetService.getSchdulByNo(schdulVO.getSchdulNo());

		return new ResponseEntity<SchdulVO>(schdul, HttpStatus.OK);
	}

	// 일정 수정
	@ResponseBody
	@PostMapping("/updateEvent")
	public ResponseEntity<String> updateEvent(@AuthenticationPrincipal CustomUser user,
			@RequestBody SchdulVO schdulVO) {

		// 유저 정보 가져오기
		EmpVO emp = user.getMember();

		// 캘린더의 사원번호가 다를 때
		if (!emp.getEmpNo().equals(schdulVO.getEmpNo())) {
			return new ResponseEntity<String>(ServiceResult.FAILED.toString(), HttpStatus.OK);
		}

		// 일정 update
		ServiceResult result = widgetService.updateSchdul(schdulVO);

		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}

	// 일정 삭제
	@ResponseBody
	@PostMapping("/deleteEvent")
	public ResponseEntity<String> deleteEvent(
			@RequestBody String eventId) {

		int schdulNo = Integer.parseInt(eventId);
		
		// 일정 delete
		ServiceResult result = widgetService.deleteSchdul(schdulNo);

		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	// 투두리스트 추가
	@ResponseBody
	@PostMapping("/addTodo")
	public ResponseEntity<TodoWidgetVO> addTodo(@AuthenticationPrincipal CustomUser user, @RequestBody String content) {

		// 유저 정보 가져오기
		EmpVO emp = user.getMember();
		
		// todoVO 생성
		TodoWidgetVO todoVO = new TodoWidgetVO();

		// 객체에 사원번호 저장
		todoVO.setEmpNo(emp.getEmpNo()); // 사원번호
		
		// 내용저장
		todoVO.setTodoCn(content); // 사원번호

		// todo insert
		widgetService.insertTodo(todoVO);

		// todo 번호로 데이터 가져와서 return
		TodoWidgetVO result = widgetService.getTodoByNo(todoVO.getTodoNo());

		return new ResponseEntity<TodoWidgetVO>(result, HttpStatus.OK);
	}
	
	// 투두리스트 체크 업데이트
	@ResponseBody
	@PostMapping("/updateTodoCheck")
	public ResponseEntity<String> updateTodoCheck(@RequestBody TodoWidgetVO todo) {

		// todo 번호로 데이터 가져와서 return
		ServiceResult result = widgetService.updateTodoCheck(todo);

		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	// 투두리스트 삭제(논리)
	@ResponseBody
	@PostMapping("/deleteTodo")
	public ResponseEntity<String> deleteTodo(@RequestBody List<Integer> todoIds) {

		// DB 삭제 처리
		ServiceResult result = widgetService.deleteTodo(todoIds);

		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}

	// 위젯 생성
	@ResponseBody
	@PostMapping("/createWidget")
	public ResponseEntity<ResponseWidgetVO<?>> createWidget(@AuthenticationPrincipal CustomUser user, @RequestBody WidgetVO widgetVO) {
		
		log.info(widgetVO.getWidgetTy());
		
		String type = widgetVO.getWidgetTy();
		EmpVO empVO = user.getMember();
		String empNo = user.getUsername();
		ResponseWidgetVO<Object> responseWidgetVO = new ResponseWidgetVO<>();
		
		responseWidgetVO.setWidgetVO(widgetService.getWidgetByType(type));
		log.info(type);
		switch (type) {
			case "26001": {
				responseWidgetVO.setData(widgetService.getSchdulWidget(empVO));
				break;
			}
			case "26002": {
				responseWidgetVO.setData(widgetService.getAttendanceWidget(empNo));
				break;
			}
			case "26003": {
				responseWidgetVO.setData(widgetService.getTodoWidget(empNo));
				break;
			}
			case "26004": {
				responseWidgetVO.setData(widgetService.getNoticeWidget());
				break;
			}
			case "26005": {
				responseWidgetVO.setData(widgetService.getProjectWidget(empNo));
				break;
			}
			case "26006": {
				responseWidgetVO.setData(widgetService.getTaskWidget(empNo));
				break;
			}
		}
		
		return new ResponseEntity<>(responseWidgetVO, HttpStatus.OK);
	}
	
	// 사용자 위젯 수정
	@ResponseBody
	@PostMapping("/modifyWidget")
	public ResponseEntity<String> modifyWidget(@AuthenticationPrincipal CustomUser user, @RequestBody List<WidgetVO> widgets) {

		String empNo = user.getUsername();
		
		// DB 삭제 처리
		ServiceResult result = widgetService.modifyWidget(widgets, empNo);

		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
}



