package kr.or.ddit.employee.mail.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmailTrashVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.SendEmailBoxVO;

@Mapper
public interface IMailMapper {

	public EmpVO getEmpInfo(String empNo);

	public List<SendEmailBoxVO> getInboxList(String empNo);

	public int selectInboxCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectInboxList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public int markInboxAsRead(Long recptnEmailboxNo);

	public SendEmailBoxVO getInboxDetail(Long recptnEmailboxNo);

	public int markInboxListAsRead(String empNo, List<Long> ids);

	public int markInboxListAsDeleted(String empNo, List<Long> ids);

	public int selectTrashCount(PaginationInfoVO<EmailTrashVO> pagingVO);

	public List<EmailTrashVO> selectTrashList(PaginationInfoVO<EmailTrashVO> pagingVO);

	public SendEmailBoxVO getTrashDetail(String empNo, Long recptnEmailboxNo);

	public int restoreTrash(String empNo, List<Long> ids);

	public EmailTrashVO getTrashInboxDetail(Long emailNo);

	public int restoreTrashEmail(List<EmailTrashVO> data);

	public void restoreSendEmail(int boxNo);

	public void restoreReceiveEmail(int boxNo);

	public void restoreReferenceEmail(int boxNo);

	public List<EmpVO> selectAddressbookEmployees(String q, int limit);

	public int insertEmail(SendEmailBoxVO emailVO);

	public int insertDsptch(SendEmailBoxVO emailVO);

	public int insertEmailRcver(String toEmail, Long emailNo);

	public List<Long> selectToEmailList(Long emailNo);

	public int insertRecptn(Long toEmailNo, Long emailNo);

	public int insertCc(String ccEmail, Long emailNo);

	public List<Long> selectCcEmailList(Long emailNo);

	public int insertRefrn(Long ccEmailNo, Long emailNo);

	public List<Long> selectDueReservedEmailNos(int batchsize);

	public void insertDsptchByEmailNo(Long emailNo);

	public void clearReserveFlag(Long emailNo);

	public int insertDraftEmail(SendEmailBoxVO emailVO);

	public int selectReserveCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selectReserveList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public void deleteReservedEmailReceivers(String empNo, List<Long> ids);

	public void deleteReservedEmailCcs(String empNo, List<Long> ids);

	public int deleteReservedEmails(String empNo, List<Long> ids);

	public SendEmailBoxVO selectReserveDetail(String empNo, long emailNo);

	public int selecttemporaryCount(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public List<SendEmailBoxVO> selecttemporaryList(PaginationInfoVO<SendEmailBoxVO> pagingVO);

	public int eraseDraftEmails(String empNo, List<Long> cleaned);

	public SendEmailBoxVO getDraftEmail(Long draftEmailNo);

	public List<SendEmailBoxVO> getToEmail(Long draftEmailNo);

	public List<SendEmailBoxVO> getCcEmail(Long draftEmailNo);

	public void insertFile(FilesVO fileVO);

	public int generateFileGroupNo();

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

	public List<EmpVO> getEmpNoFromEmail(String trim);

	public int eraseTrashReceives(String empNo, List<Long> ids);

	public int eraseTrashSents(String empNo, List<Long> ids);

	public int eraseTrashRefs(String empNo, List<Long> ids);

}
