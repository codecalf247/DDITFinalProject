package kr.or.ddit.employee.project.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectTaskVO;

public interface IProjectTasksService {

	
	public int checkProjectParticipant(int prjctNo, String empNo);
	
	// 상태 버튼 AJAX로 페이지 불러오기 
	public PaginationInfoVO<ProjectTaskVO> selectTaskAjaxList(PaginationInfoVO<ProjectTaskVO> pagingVO);

	public ServiceResult insertTask(ProjectTaskVO task, List<MultipartFile> files);

	public ProjectTaskVO selectTaskByPk(int prjctNo, int taskNo, String loginEmpNo);

	public ServiceResult updateTask(ProjectTaskVO task);

	public Map<String, Integer> selectEachTaskCounts(int prjctNo, String procsTy, String searchWord);

	// 상세 첨부파일 조회
	List<FilesVO> selectFilesByGroupNo(Integer fileGroupNo);
	
	// 삭제
	public ServiceResult deleteTask(int prjctNo, int taskNo);
	
	
	
	
	
	
	
	
	// 칸반 
	public List<ProjectTaskVO> selectTasksByProject(int prjctNo);
	public int updateTaskProgressAndStatus(int taskNo, int prjctNo, int progrs, String sttus, String empNo);


	
	

	

	
}
