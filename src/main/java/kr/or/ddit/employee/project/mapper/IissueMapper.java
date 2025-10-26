package kr.or.ddit.employee.project.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.IssueCommentVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IissueMapper {

	public List<IssueVO> issueList(int prjctNo);

	public int generateFileGroupNo();

	public void insert(IssueVO issueVO);

	public void insertFile(FilesVO fileVO);

	public IssueVO selectIssue(int issueNo);

	
	
	public List<IssueVO> issueListFilter(Map<String, Object> conditionMap);
	
	// 카운트 조회 메서드 구현
	public Map<String, Integer> getIssueCounts(int prjctNo);

	
	
	
	
	public void deleteIssueComments(int issueNo);

	public void deleteFilesByGroupNo(int fileGroupNo);

	public void deleteIssue(int issueNo);

	
	
	public void insertIssueComment(IssueCommentVO commentVO);
	public void updateIssueComment(IssueCommentVO commentVO);
	public void deleteIssueComment(int issueCmNo);

	public void updateIssue(IssueVO issueVO);

	public void deleteFile(int fileNo);

	public int selectIssueCount(PaginationInfoVO<IssueVO> pagingVO);

	public List<IssueVO> selectIssueAjaxList(PaginationInfoVO<IssueVO> pagingVO);

	public int selectIssueTotalCount(PaginationInfoVO<IssueVO> pagingVO);

	public List<IssueVO> selectIssueListWithPaging(PaginationInfoVO<IssueVO> pagingVO);


}
