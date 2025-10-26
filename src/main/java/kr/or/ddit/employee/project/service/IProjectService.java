package kr.or.ddit.employee.project.service;


import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectVO;

public interface IProjectService {

	
	// 프로젝트 ID 가져오기 
	public ProjectVO selectProjectByNo(int projectNo);

	// 프로젝트 목록 가져오기
	public List<ProjectVO> selectProjectList(PaginationInfoVO<ProjectVO> pagingVO);
	
	// 프로젝트 등록용
	public ServiceResult insertProject(ProjectVO pVO);
	
	// 프로젝트 업데이트용 
	

	
	// Pagination용
	public int selectProjectListCount(PaginationInfoVO<ProjectVO> pagingVO);

	
	
	
	
// 업데이트 -----------------------------------------------------------------------------------
	
	// 프로젝트 업데이트 
//	public ServiceResult updateProject(ProjectVO pVO);
	
	// 프로젝트 참가자 불러오기 
	public List<ProjectPerticipantVO> selectParticipantsByProject(int prjctNo);

	// 프로젝트 기본 정보 업데이트 
	public ServiceResult updateProjectBasic(ProjectVO pVO);

	// 프로젝트 참여자 추가 
	public ServiceResult addParticipants(int prjctNo, List<ProjectPerticipantVO> list);

	
	
	
	public List<CommonCodeVO> selectCommonCodes(String string);

	
	
	
	
	// 프로젝트 일감용 메서드
	public List<ProjectPerticipantVO> selectParticipantsByProjectForTasks(int prjctNo);

	
	// 프로젝트 이슈용 메서
	public List<ProjectPerticipantVO> selectProjectIssuesParticipants(int prjctNo);

	public boolean isProjectParticipant(int prjctNo, String username);

	
	


	
	
	

}
