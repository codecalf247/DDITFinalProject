package kr.or.ddit.employee.project.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.project.mapper.IissueMapper;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.IssueCommentVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;

@Service
public class IssueServiceImpl implements IissueService {
	
	@Autowired
	private IissueMapper mapper;

	@Override
	public List<IssueVO> issueList(int prjctNo) {
		return mapper.issueList(prjctNo);
	}

	@Override
	public int generateFileGroupNo() {
		return mapper.generateFileGroupNo();
	}

	@Override
	public void insert(IssueVO issueVO) {
		mapper.insert(issueVO);
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		mapper.insertFile(fileVO);
	}

	@Override
	public IssueVO selectIssue(int issueNo) {
		return mapper.selectIssue(issueNo);
	}

	@Override
	public List<IssueVO> issueListFilter(Map<String, Object> conditionMap) {
		return mapper.issueListFilter(conditionMap);
	}

	@Override
	public Map<String, Integer> getIssueCounts(int prjctNo) {
		return mapper.getIssueCounts(prjctNo);
	}

	@Transactional
	@Override
	public void deleteIssue(int issueNo) {
		// 1. 해당 이슈에 달린 댓글 모두 삭제 (또는 DEL_YN 업데이트)
		mapper.deleteIssueComments(issueNo);
		
		// 2. 파일의 DEL_YN을 'Y'로 업데이트 (논리적 삭제)
		IssueVO issue = mapper.selectIssue(issueNo); // 파일 그룹 번호를 가져오기 위해 상세 조회 필요
		if (issue != null && issue.getFileGroupNo() > 0) {
			mapper.deleteFilesByGroupNo(issue.getFileGroupNo());
		}
		
		// 3. 이슈 자체 삭제 (또는 DEL_YN 업데이트)
		mapper.deleteIssue(issueNo);
	}

	@Override
	public void insertIssueComment(IssueCommentVO commentVO) {
		mapper.insertIssueComment(commentVO);
	}

	@Override
	public void deleteIssueComment(int issueCmNo) {
		mapper.deleteIssueComment(issueCmNo);
		
	}

	@Override
	public void updateIssueComment(IssueCommentVO commentVO) {
		mapper.updateIssueComment(commentVO);
		
	}

	@Override
	public void updateIssue(IssueVO issueVO) {
		mapper.updateIssue(issueVO);
		
	}

	@Override
	public void deleteFile(int fileNo) {
		
		mapper.deleteFile(fileNo);
	}

	@Override
	public PaginationInfoVO<IssueVO> selectIssueAjaxList(PaginationInfoVO<IssueVO> pagingVO) {
		// 1. 전체 레코드 수 조회
		int totalRecord = mapper.selectIssueCount(pagingVO);
		
		pagingVO.setTotalRecord(totalRecord);
		
		if (totalRecord > 0) {
			
			List<IssueVO> list = mapper.selectIssueAjaxList(pagingVO);
			pagingVO.setDataList(list);
		}
		return pagingVO;
	}

	@Override
	public int selectIssueTotalCount(PaginationInfoVO<IssueVO> pagingVO) {
		 return mapper.selectIssueTotalCount(pagingVO);
	}

	@Override
	public List<IssueVO> selectIssueListWithPaging(PaginationInfoVO<IssueVO> pagingVO) {
		  return mapper.selectIssueListWithPaging(pagingVO);
	}

}