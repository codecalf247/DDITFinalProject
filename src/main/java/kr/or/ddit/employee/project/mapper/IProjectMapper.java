package kr.or.ddit.employee.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectVO;

@Mapper
public interface IProjectMapper {

	
	// 프로젝트 넘버 가져오기
	public ProjectVO selectProjectByNo(int projectNo);
	
	
	// 프로젝트 목록 조회
	public List<ProjectVO> selectProjectList(PaginationInfoVO<ProjectVO> pagingVO);

	
	// 프로젝트 등록
	public int insertProject(ProjectVO pVO);

	
	// 프로젝트 수정 
	public int updateProject(ProjectVO pVO);
	public int updateProjectBasic(ProjectVO pVO);
	
	
	
	
	// pagination용
	public int selectProjectListCount(PaginationInfoVO<ProjectVO> pagingVO);


	
	
	// 참가자
    public List<ProjectPerticipantVO> selectParticipantsByProject(@Param("prjctNo") int prjctNo);	// 참여자 컬렉션 조회(프로젝트별) 

    public void insertProjectParticipants(ProjectPerticipantVO ppVO);    							// 프로젝트 담당자 지정


	public List<CommonCodeVO> selectCommonCodes(String cmmnCdGroupId);


	
	
	
	
	
	
	// 프로젝트 일감용 메서드
	public List<ProjectPerticipantVO> selectParticipantsByProjectForTasks(int prjctNo);

	// 프로젝트 이슈용 메서드
	public List<ProjectPerticipantVO> selectProjectIssuesParticipants(int prjctNo);


	public boolean isProjectParticipant(int prjctNo, String username);



  
    
    




	
	




}
