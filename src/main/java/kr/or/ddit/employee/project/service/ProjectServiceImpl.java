package kr.or.ddit.employee.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.cmmn.service.ICMMNService;
import kr.or.ddit.employee.project.mapper.IProjectMapper;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectServiceImpl implements IProjectService {

	
	@Autowired
	private IProjectMapper pMapper;
	
	@Autowired
	private ICMMNService cmmnService;
	@Autowired
	private NotificationConfig noti;


	
	// 프로젝트 넘버 가져오기 
	@Override
	public ProjectVO selectProjectByNo(int projectNo) {
		ProjectVO project = pMapper.selectProjectByNo(projectNo);
		if(project != null) {
			List<ProjectPerticipantVO> ppl = pMapper.selectParticipantsByProject(projectNo);
			project.setParticipantsList(ppl);
			
		}
		return project;
	}
	
	
	
	// 프로젝트 목록 조회
	@Override
	public List<ProjectVO> selectProjectList(PaginationInfoVO<ProjectVO> pagingVO) {
		return pMapper.selectProjectList(pagingVO);
	}
	
	
	// 프로젝트 등록 
	@Override
	@Transactional(rollbackFor = Exception.class)
	public ServiceResult insertProject(ProjectVO pVO) {
		
		// 상태 공통 코드 매핑
		// String prjctSttus = cmmnService.getCMMNIdByGroupId("17", pVO.getPrjctSttus());
		// pVO.setPrjctSttus(prjctSttus);
		
		// 전화번호 하이픈 제거 
		String tel = pVO.getCstmrTel();
		tel = tel.replaceAll("-", "");
		pVO.setCstmrTel(tel);
		
	
		// 1. 프로젝트 정보 등록 
		int status = pMapper.insertProject(pVO);
		if(status <= 0) return ServiceResult.FAILED;
		
		
	
			// 참여자 등록 (null 방지) 
			if(pVO.getParticipantsList() != null && !pVO.getParticipantsList().isEmpty()) {
				int prjctNo = pVO.getPrjctNo(); // selectKey로 세팅됨
				for(ProjectPerticipantVO ppVO : pVO.getParticipantsList()) {
					// ppVO가 null일수도 있게 때문에 방지용 
					if(ppVO == null) continue;
					ppVO.setPrjctNo(prjctNo);
					pMapper.insertProjectParticipants(ppVO);
				}
		
			}
			return ServiceResult.OK;
		
	}


	// 검색용 
	@Override
	public int selectProjectListCount(PaginationInfoVO<ProjectVO> pagingVO) {
		return pMapper.selectProjectListCount(pagingVO);
	}

	
	
	
//	// 수정 : 프로젝트 + (선택) 참여자 갱신
//	@Override
//	@Transactional(rollbackFor = Exception.class)
//	public ServiceResult updateProject(ProjectVO pVO) {
//		
//		  if (pVO.getPrjctSttus() != null) {
//	            String prjctSttus = cmmnService.getCMMNIdByGroupId("17", pVO.getPrjctSttus());
//	            pVO.setPrjctSttus(prjctSttus);
//	        }
//	        if (pVO.getCstmrTel() != null) {
//	            pVO.setCstmrTel(pVO.getCstmrTel().replaceAll("-", ""));
//	        }
//	        int cnt = pMapper.updateProjectBasic(pVO);
//	        return cnt > 0 ? ServiceResult.OK : ServiceResult.FAILED;
//	    }

	
// 프로젝트 일반 정보 업데이트 
	@Override
	public ServiceResult updateProjectBasic(ProjectVO pVO) {
//		if (pVO.getPrjctSttus() != null) {
//			String prjctSttus = cmmnService.getCMMNIdByGroupId("17", pVO.getPrjctSttus());
//			pVO.setPrjctSttus(prjctSttus);
//		}
		if (pVO.getCstmrTel() != null) {
			pVO.setCstmrTel(pVO.getCstmrTel().replaceAll("-", ""));
		}
		int cnt = pMapper.updateProjectBasic(pVO);
		return cnt > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
// 프로젝트 참가자 추가 
	@Override
	public ServiceResult addParticipants(int prjctNo, List<ProjectPerticipantVO> newParticipants) {
		for (ProjectPerticipantVO participant : newParticipants) {
			participant.setPrjctNo(prjctNo);
			pMapper.insertProjectParticipants(participant);
			noti.notify(participant.getEmpNo(), "11001", "프로젝트 참가", "/project/dashboard?prjctNo="+ prjctNo);
		}
		return ServiceResult.OK;
	}
	
	// 참여자 단독 조회 
	@Override
	public List<ProjectPerticipantVO> selectParticipantsByProject(int prjctNo) {
		return pMapper.selectParticipantsByProject(prjctNo);
	}



	@Override
	public List<CommonCodeVO> selectCommonCodes(String cmmnCdGroupId) {
		return pMapper.selectCommonCodes(cmmnCdGroupId);
	}



	@Override
	public List<ProjectPerticipantVO> selectParticipantsByProjectForTasks(int prjctNo) {
		return pMapper.selectParticipantsByProjectForTasks(prjctNo);
	}



	@Override
	public List<ProjectPerticipantVO> selectProjectIssuesParticipants(int prjctNo) {
		return pMapper.selectProjectIssuesParticipants(prjctNo);
	}



	@Override
	public boolean isProjectParticipant(int prjctNo, String username) {
		return pMapper.isProjectParticipant(prjctNo,username);
	}




	


	



}
	
	
	
	

