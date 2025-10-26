package kr.or.ddit.employee.mail.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.mail.mapper.IMailMapper;
import kr.or.ddit.vo.EmailTrashVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.SendEmailBoxVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailServiceImpl implements IMailService {

	@Autowired
	private IMailMapper mailMapper;
	
	@Autowired
	private NotificationConfig noti; 

	@Override
	public EmpVO getEmpInfo(String empNo) {
		return mailMapper.getEmpInfo(empNo);
	}

	@Override
	public int selectInboxCount(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectInboxCount(pagingVO);
	}

	@Override
	public List<SendEmailBoxVO> selectInboxList(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectInboxList(pagingVO);
	}

	@Override
	public int markInboxAsRead(Long recptnEmailboxNo) {
		if (recptnEmailboxNo == null)
			return 0;
		return mailMapper.markInboxAsRead(recptnEmailboxNo);
	}

	@Override
	public SendEmailBoxVO getInboxDetail(Long recptnEmailboxNo) {
		if (recptnEmailboxNo == null)
			return null;
		return mailMapper.getInboxDetail(recptnEmailboxNo);
	}

	@Override
	public int markInboxListAsRead(String empNo, List<Long> ids) {
		if (StringUtils.isBlank(empNo) || ids == null || ids.isEmpty()) {
			return 0;
		}
		return mailMapper.markInboxListAsRead(empNo, ids);
	}

	@Override
	public int markInboxListAsDeleted(String empNo, List<Long> ids) {
		if (empNo == null || empNo.isBlank() || ids == null || ids.isEmpty()) {
			return 0;
		}
		return mailMapper.markInboxListAsDeleted(empNo, ids);
	}

	@Override
	public int selectTrashCount(PaginationInfoVO<EmailTrashVO> pagingVO) {
		return mailMapper.selectTrashCount(pagingVO);
	}

	@Override
	public List<EmailTrashVO> selectTrashList(PaginationInfoVO<EmailTrashVO> pagingVO) {
		return mailMapper.selectTrashList(pagingVO);
	}

	@Override
	public int restoreTrash(String empNo, List<Long> ids) {
		if (ids == null || ids.isEmpty())
			return 0;
		return mailMapper.restoreTrash(empNo, ids);
	}

	  @Override
	    @Transactional
	    public int eraseTrash(String empNo, List<Long> ids) {
	        if (StringUtils.isBlank(empNo) || ids == null || ids.isEmpty()) {
	            return 0;
	        }
	        int deleted = 0;

	        // 받은메일함(RECPTN_EMAILBOX)에서 소유자 검증 후 삭제
	        deleted += mailMapper.eraseTrashReceives(empNo, ids);

	        // 보낸메일함(DSPTCH_EMAILBOX)에서 소유자 검증 후 삭제
	        deleted += mailMapper.eraseTrashSents(empNo, ids);

	        // 참조메일함(REFRN_EMAILBOX)에서 소유자 검증 후 삭제
	        deleted += mailMapper.eraseTrashRefs(empNo, ids);

	        log.debug("eraseTrash: empNo={}, ids={}, deleted={}", empNo, ids, deleted);
	        return deleted;
	    }

	@Override
	public EmailTrashVO getTrashInboxDetail(Long emailNo) {
		return mailMapper.getTrashInboxDetail(emailNo);
	}

	@Override
	public int restoreTrashEmail(List<EmailTrashVO> data) {

		int count = 0;

		for (EmailTrashVO e : data) {
			switch (e.getType()) {
			case 1: { // 수신
				mailMapper.restoreReceiveEmail(e.getBoxNo());
				break;
			}
			case 2: { // 송신
				mailMapper.restoreSendEmail(e.getBoxNo());
				break;
			}
			case 3: { // 참조
				mailMapper.restoreReferenceEmail(e.getBoxNo());
				break;
			}
			}
			count++;
		}

		return count;
	}

	@Override
	 public List<EmpVO> findAddressbookEmployees(String q, int limit) {
        // 검색어 정리
        String query = (q == null) ? "" : q.trim();

        // limit 안전 범위 보정 (디폴트 50, 상한 200)
        int safeLimit = (limit <= 0) ? 50 : Math.min(limit, 200);

        // Mapper 호출 (XML에서 EMP INNER JOIN DEPT 후 empNm/deptNm/email만 조회)
        return mailMapper.selectAddressbookEmployees(query, safeLimit);
    }

		
	@Transactional
	@Override
	public ServiceResult addEmail(SendEmailBoxVO emailVO) {
	    int status = 0;
	    ServiceResult result = null;

	    // 1. Email 테이블에 이메일 데이터 등록
	    status += mailMapper.insertEmail(emailVO);
	    if (emailVO.getEmailNo() == null) return ServiceResult.FAILED;

	    // 2. DSPTCH_EMAILBOX 테이블에 발신 메일함 데이터 등록(발신 메일함)
	    status += mailMapper.insertDsptch(emailVO);

	    // ✅ 중복 알림 방지용 Set (empNo 기준)
	    Set<String> notified = new HashSet<>();

	    // 3. EMAIL_RCVER 테이블에 이메일 데이터 등록(메일 수신자) + 알림
	    int count = 0;
	    for (String toEmail : emailVO.getToEmails()) {
	        if (StringUtils.isBlank(toEmail)) continue;
	        String trimmed = toEmail.trim();

	        count += mailMapper.insertEmailRcver(trimmed, emailVO.getEmailNo());

	        // 수신자 알림 (중복 방지)
	        List<EmpVO> getnotimember = mailMapper.getEmpNoFromEmail(trimmed);
	        for (EmpVO empno : getnotimember) {
	            String empNo = empno.getEmpNo();
	            if (StringUtils.isNotBlank(empNo) && notified.add(empNo)) {
	                noti.notify(empNo, "12005", "메일", "/mail/inbox");
	            }
	        }
	    }
	    if (count == emailVO.getToEmails().size()) {
	        status += 1;
	    }
	    log.info("상태 : {} ", status);

	    // 4. RECPTN_EMAILBOX 테이블에 이메일 데이터 등록(수신 메일함)
	    List<Long> toEmailNoList = mailMapper.selectToEmailList(emailVO.getEmailNo());
	    count = 0;
	    if (toEmailNoList != null && !toEmailNoList.isEmpty()) {
	        for (Long toEmailNo : toEmailNoList) {
	            count += mailMapper.insertRecptn(toEmailNo, emailVO.getEmailNo());
	        }
	    }
	    if (count == (toEmailNoList == null ? 0 : toEmailNoList.size())) {
	        status += 1;
	    }
	    log.info("상태 : {} ", status);

	    // 5. EMAIL_CC 테이블에 이메일 데이터 등록(메일 참조자) + 알림
	    List<String> ccEmails = emailVO.getCcEmails();
	    log.info(ccEmails != null ? ccEmails.toString() : "ccEmails is null");

	    if (ccEmails != null && !ccEmails.isEmpty()) {
	        count = 0;
	        for (String ccEmail : ccEmails) {
	            if (StringUtils.isBlank(ccEmail)) continue;
	            String trimmed = ccEmail.trim();

	            count += mailMapper.insertCc(trimmed, emailVO.getEmailNo());

	            // 참조자 알림 (중복 방지)
	            List<EmpVO> getnotimember = mailMapper.getEmpNoFromEmail(trimmed);
	            for (EmpVO empno : getnotimember) {
	                String empNo = empno.getEmpNo();
	                if (StringUtils.isNotBlank(empNo) && notified.add(empNo)) {
	                    noti.notify(empNo, "12005", "메일", "/mail/inbox");
	                }
	            }
	        }
	        if (count == ccEmails.size()) {
	            status += 1;
	        }
	    } else {
	        // 참조자가 없으면 성공으로 간주
	        status += 1;
	    }

	    // 6. REFRN_EMAILBOX 테이블에 이메일 데이터 등록(참조 메일함)
	    if (ccEmails != null && !ccEmails.isEmpty()) {
	        List<Long> ccEmailNoList = mailMapper.selectCcEmailList(emailVO.getEmailNo());
	        count = 0;
	        if (ccEmailNoList != null && !ccEmailNoList.isEmpty()) {
	            for (Long ccEmailNo : ccEmailNoList) {
	                count += mailMapper.insertRefrn(ccEmailNo, emailVO.getEmailNo());
	            }
	        }
	        if (count == (ccEmailNoList == null ? 0 : ccEmailNoList.size())) {
	            status += 1;
	        }
	    } else {
	        status += 1;
	    }

	    // 최종 결과
	    if (status >= 4) {
	        log.info("성공 =======================================");
	        result = ServiceResult.OK;
	    } else {
	        result = ServiceResult.FAILED;
	    }

	    return result;
	}


	 // ===== 예약 저장 =====
		@Transactional
		@Override
		public ServiceResult addReservedEmail(SendEmailBoxVO emailVO) {
		    int status = 0;

		    if (StringUtils.isBlank(emailVO.getWrterEmpNo())) return ServiceResult.FAILED;
		    if (StringUtils.isBlank(emailVO.getResveDsptchDt())) return ServiceResult.FAILED;

		    // 1) EMAIL
		    status += mailMapper.insertEmail(emailVO);
		    if (emailVO.getEmailNo() == null) return ServiceResult.FAILED;

		    // 2) TO 수신자 정리 + 저장
		    List<String> toRaw = emailVO.getToEmails();
		    if (toRaw == null) return ServiceResult.FAILED;

		    List<String> toList = toRaw.stream()
		            .filter(StringUtils::isNotBlank)
		            .map(String::trim)
		            .distinct()
		            .toList();

		    if (toList.isEmpty()) return ServiceResult.FAILED;

		    int count = 0;
		    for (String toEmail : toList) {
		        count += mailMapper.insertEmailRcver(toEmail, emailVO.getEmailNo());
		    }
		    if (count == toList.size()) status += 1;

		    // 3) CC 참조자 (옵션)
		    List<String> ccRaw = emailVO.getCcEmails();
		    List<String> ccList = (ccRaw == null ? List.<String>of() :
		            ccRaw.stream()
		                .filter(StringUtils::isNotBlank)
		                .map(String::trim)
		                .distinct()
		                .toList());

		    if (ccList.isEmpty()) {
		        status += 1; // 참조 없음도 성공으로 카운트
		    } else {
		        count = 0;
		        for (String ccEmail : ccList) {
		            count += mailMapper.insertCc(ccEmail, emailVO.getEmailNo());
		        }
		        if (count == ccList.size()) status += 1;
		    }

		    return (status >= 3) ? ServiceResult.OK : ServiceResult.FAILED;
		}

    
		// ===== 예약 도래 메일 발송(스케줄러가 호출) =====
		@Transactional
	    @Override
	    public int reservedEmails(int batchsize) {

	        List<Long> emailNos = mailMapper.selectDueReservedEmailNos(batchsize);
	        if (emailNos == null || emailNos.isEmpty()) {
	            return 0;
	        }

	        int processed = 0;
	        for (Long emailNo : emailNos) {
	            try {
	                // 보낸메일함
	                mailMapper.insertDsptchByEmailNo(emailNo);

	                // 받은메일함
	                List<Long> toEmailNoList = mailMapper.selectToEmailList(emailNo);
	                if (toEmailNoList != null) {
	                    for (Long rcvrNo : toEmailNoList) {
	                        mailMapper.insertRecptn(rcvrNo, emailNo);
	                    }
	                }

	                // 참조메일함
	                List<Long> ccEmailNoList = mailMapper.selectCcEmailList(emailNo);
	                if (ccEmailNoList != null) {
	                    for (Long ccNo : ccEmailNoList) {
	                        mailMapper.insertRefrn(ccNo, emailNo);
	                    }
	                }

	                // 예약 플래그 해제
	                mailMapper.clearReserveFlag(emailNo);

	                // =============================
	                // ✅ 예약 발송 알림 (TO/CC 통합 + empNo 없으면 이메일로 역매핑)
	                // =============================
	                try {
	                    Set<String> notified = new HashSet<>();

	                    List<SendEmailBoxVO> tos = mailMapper.getToEmail(emailNo);
	                    List<SendEmailBoxVO> ccs = mailMapper.getCcEmail(emailNo);

	                    List<SendEmailBoxVO> targets = new ArrayList<>();
	                    if (tos != null) targets.addAll(tos);
	                    if (ccs != null) targets.addAll(ccs);

	                    for (SendEmailBoxVO v : targets) {
	                        // 1) rcverEmpNo가 있으면 우선 사용
	                        String empNo = StringUtils.trimToEmpty(v.getRcverEmpNo());
	                        if (StringUtils.isNotBlank(empNo)) {
	                            if (notified.add(empNo)) {
	                                noti.notify(empNo, "12005", "메일", "/mail/inbox");
	                            }
	                            continue;
	                        }

	                        // 2) 없으면 rcverEmail로 역매핑
	                        String email = StringUtils.trimToEmpty(v.getRcverEmail());
	                        if (StringUtils.isBlank(email)) continue;

	                        List<EmpVO> mems = mailMapper.getEmpNoFromEmail(email);
	                        if (mems == null || mems.isEmpty()) continue;

	                        for (EmpVO m : mems) {
	                            String eno = StringUtils.trimToEmpty(m.getEmpNo());
	                            if (StringUtils.isNotBlank(eno) && notified.add(eno)) {
	                                noti.notify(eno, "12005", "메일", "/mail/inbox");
	                            }
	                        }
	                    }
	                } catch (Exception notifyEx) {
	                    log.warn("[예약발송 알림] 처리 중 예외 emailNo={}, ex={}", emailNo, notifyEx.toString());
	                }
	                // =============================

	                processed++;
	            } catch (Exception e) {
	                log.warn("[예약발송] emailNo={} 처리 실패: {}", emailNo, e.getMessage());
	                // 건별 스킵
	            }
	        }
	        return processed;
	    }

	@Override
	public ServiceResult saveDraft(SendEmailBoxVO emailVO) {
		 int cnt = mailMapper.insertDraftEmail(emailVO);
		    return cnt > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}

	@Override
	public int selectReserveCount(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectReserveCount(pagingVO);
	}

	@Override
	public List<SendEmailBoxVO> selectReserveList(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return  mailMapper.selectReserveList(pagingVO);
	}

	@Override
	public int eraseReservedEmails(String empNo, List<Long> ids) {
		 if (ids == null || ids.isEmpty()) return 0;

	        // 자식(수신/참조) 먼저 삭제
	        mailMapper.deleteReservedEmailReceivers(empNo, ids);
	        mailMapper.deleteReservedEmailCcs(empNo, ids);

	        // EMAIL 삭제 (반환값: 삭제된 EMAIL 건수)
	        return mailMapper.deleteReservedEmails(empNo, ids);
	}

	@Override
    @Transactional(readOnly = true)
    public SendEmailBoxVO selectReserveDetail(String empNo, int emailNo) {
        // 로그인 정보 없으면 null
        if (StringUtils.isBlank(empNo)) return null;

        // Mapper는 파라미터명을 xml과 맞춰야 합니다: #{empNo}, #{emailNo}
        // xml이 Long을 기대한다면 캐스팅
        return mailMapper.selectReserveDetail(empNo, (long) emailNo);
    }

	@Override
	public int selecttemporaryCount(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		 return mailMapper.selecttemporaryCount(pagingVO);
		
	}

	@Override
	public List<SendEmailBoxVO> selecttemporaryList(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selecttemporaryList(pagingVO);
		
	}

	@Override
	@Transactional
	public int eraseDrafts(String empNo, List<Long> ids) {
	    if (empNo == null || empNo.isBlank() || ids == null) return 0;

	    // null 제거 + 중복 제거(첫 등장 순서 유지)
	    List<Long> cleaned = new ArrayList<>(ids.size());
	    Set<Long> seen = new HashSet<>();
	    for (Long id : ids) {
	        if (id == null) continue;
	        if (seen.add(id)) {        // 처음 본 id만 추가
	            cleaned.add(id);
	        }
	    }
	    if (cleaned.isEmpty()) return 0;

	    // 작성자 본인 & 임시저장건만 삭제
	    return mailMapper.eraseDraftEmails(empNo, cleaned);
	
	}

	@Override
	public SendEmailBoxVO getDraftEmail(Long draftEmailNo) {
		return mailMapper.getDraftEmail(draftEmailNo);
	}

	@Override
	public List<SendEmailBoxVO> getToEmail(Long draftEmailNo) {
		return mailMapper.getToEmail(draftEmailNo);
	}

	@Override
	public List<SendEmailBoxVO> getCcEmail(Long draftEmailNo) {
		return mailMapper.getCcEmail(draftEmailNo);
	}

	@Override
	public int generateFileGroupNo() {
		return mailMapper.generateFileGroupNo();
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		mailMapper.insertFile(fileVO);
	}

	@Override
	public int selectRefCount(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectRefCount(pagingVO);
	}

	@Override
	public List<SendEmailBoxVO> selectRefList(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectRefList(pagingVO);
	}

	@Override
	public void markRefAsRead(Long refrnEmailboxNo) {
		mailMapper.markRefAsRead(refrnEmailboxNo);
	}

	@Override
	public SendEmailBoxVO getRefDetail(Long refrnEmailboxNo) {
		return mailMapper.getRefDetail(refrnEmailboxNo);
	}

	@Override
	public int markRefListAsDeleted(String empNo, List<Long> ids) {
		 if (StringUtils.isBlank(empNo) || ids == null || ids.isEmpty()) {
	            return 0;
	        }
	        return mailMapper.markRefListAsDeleted(empNo, ids);
	}

	@Override
	public int selectSendCount(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectSendCount(pagingVO);
	}

	@Override
	public List<SendEmailBoxVO> selectSendList(PaginationInfoVO<SendEmailBoxVO> pagingVO) {
		return mailMapper.selectSendList(pagingVO);
	}

	 @Override
	    public List<Map<String, Object>> selectReceiptsForEmail(Long emailNo) {
	        return mailMapper.selectReceiptsForEmail(emailNo);
	    }

	@Override
	public int markSentListAsDeleted(String empNo, List<Long> ids) {
		if (StringUtils.isBlank(empNo) || ids == null || ids.isEmpty()) {
	        return 0;
	    }
	    return mailMapper.markSentListAsDeleted(empNo, ids);
	}

	@Override
	public SendEmailBoxVO selectSentDetail(String empNo, Long emailNo) {
		  // 사용자 번호와 메일 번호가 유효한지 확인
	    if (StringUtils.isBlank(empNo) || emailNo == null) {
	        return null;
	    }
	    // 매퍼를 호출하여 보낸 메일 상세 정보 조회
	    return mailMapper.selectSentDetail(empNo, emailNo);
	}

	@Override
	public List<SendEmailBoxVO> getSentEmailUserList(int emailNo) {
		return mailMapper.getSentEmailUserList(emailNo);
	}
}
 
	

	
