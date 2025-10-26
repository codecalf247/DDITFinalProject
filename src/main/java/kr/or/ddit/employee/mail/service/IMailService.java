package kr.or.ddit.employee.mail.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmailTrashVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.SendEmailBoxVO;

public interface IMailService {

	public EmpVO getEmpInfo(String empNo);

	public int selectInboxCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectInboxList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public int markInboxAsRead(Long recptnEmailboxNo);

	public SendEmailBoxVO getInboxDetail(Long recptnEmailboxNo);

	public int markInboxListAsRead(String empNo, List<Long> ids);

	public int markInboxListAsDeleted(String empNo, List<Long> ids);

	public int selectTrashCount(PaginationInfoVO<EmailTrashVO> pagingVO);

	public List<EmailTrashVO> selectTrashList(PaginationInfoVO<EmailTrashVO> pagingVO);

	public int restoreTrash(String empNo, List<Long> ids);

	public int eraseTrash(String empNo, List<Long> ids);

	public EmailTrashVO getTrashInboxDetail(Long emailNo);

	public int restoreTrashEmail(List<EmailTrashVO> data);

	public List<EmpVO> findAddressbookEmployees(String q, int limit);

	public ServiceResult addEmail(SendEmailBoxVO emailVO);

	public ServiceResult addReservedEmail(SendEmailBoxVO emailVO);

	public int reservedEmails(int batchsize);

	public ServiceResult saveDraft(SendEmailBoxVO emailVO);

	public int selectReserveCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectReserveList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public int eraseReservedEmails(String empNo, List<Long> ids);

	public SendEmailBoxVO selectReserveDetail(String empNo, int emailNo);

	public int selecttemporaryCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selecttemporaryList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public int eraseDrafts(String empNo, List<Long> ids);

	public SendEmailBoxVO getDraftEmail(Long draftEmailNo);

	public List<SendEmailBoxVO> getToEmail(Long draftEmailNo);

	public List<SendEmailBoxVO> getCcEmail(Long draftEmailNo);

	public int generateFileGroupNo();

	public void insertFile(FilesVO fileVO);

	public int selectRefCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectRefList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public void markRefAsRead(Long refrnEmailboxNo);

	public SendEmailBoxVO getRefDetail(Long refrnEmailboxNo);

	public int markRefListAsDeleted(String empNo, List<Long> ids);

	public int selectSendCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectSendList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<Map<String, Object>> selectReceiptsForEmail(Long emailNo);

	public int markSentListAsDeleted(String empNo, List<Long> ids);

	public SendEmailBoxVO selectSentDetail(String empNo, Long emailNo);

	public List<SendEmailBoxVO> getSentEmailUserList(int emailNo);

	


}
