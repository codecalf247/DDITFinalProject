package kr.or.ddit.employee.project.mapper;



import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectTaskVO;



@Mapper
public interface IProjectTasksMapper {

	
	// List
	public int checkProjectParticipant(@Param("prjctNo") int prjctNo, @Param("empNo") String empNo);
	
	//상태 분기 없이(= all/대기/진행중/검토중/완료 전부) 전역 카운트 조회
	public Map<String, Object> selectEachTaskCounts(  @Param("prjctNo") int prjctNo, @Param("procsTy") String procsTy,  @Param("searchWord") String searchWord);
	
	public List<ProjectTaskVO> selectTaskAjaxList(PaginationInfoVO<ProjectTaskVO> pagingVO);

	public int selectTaskCount(PaginationInfoVO<ProjectTaskVO> pagingVO);

	public ProjectTaskVO selectTaskByPk(@Param("prjctNo") int prjctNo, @Param("taskNo") int taskNo, @Param("loginEmpNo") String loginEmpNo);

	public void insertProjectParticipant(@Param("prjctNo") int prjctNo, @Param("empNo") String empNo, @Param("timhderYn") String timhderYn, @Param("prtcpntType") String prtcpntType);
	
	
	// insert
	public int generateTaskNo();					// SEQ_TASK.NEXTVAL
	public Integer generateFileGroupNo();			// SEQ_FILE_GROUP.NEXTVAL (자료실과 동일 시퀀스명 사용 권장)
	public int insertTask(ProjectTaskVO task);
	public int insertFiles(FilesVO fvo);
	public List<FilesVO> selectFilesByGroupNo(@Param("fileGroupNo") Integer fileGroupNo);


	public int updateTask(ProjectTaskVO task);
	
	
	// delete
	public ProjectTaskVO selectTask(int prjctNo, int taskNo);
	public void deleteFilesByGroupNo(Integer fileGroupNo);
	public int deleteTask(int prjctNo, int taskNo);
	
	
	
	
	
	
	
	// 칸반 
	// 칸반 초기 로딩용: 프로젝트 내 일감 전체(삭제 제외)
	public List<ProjectTaskVO> selectTasksByProject(int prjctNo);
	public int updateTaskProgressAndStatus(@Param("taskNo") int taskNo,  @Param("prjctNo") int prjctNo, @Param("progrs") int progrs,@Param("sttus") String sttus);

	



	

}
