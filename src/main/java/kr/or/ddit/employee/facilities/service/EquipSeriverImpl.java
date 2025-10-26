package kr.or.ddit.employee.facilities.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.facilities.mapper.IEquipMentMapper;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class EquipSeriverImpl implements IEquipService {

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private IEquipMentMapper equipMapper;
	
	
	
	@Override
	public int selectEquipCount(PaginationInfoVO<EqpmnVO> pagingVO) {
		return equipMapper.selectEquipCount(pagingVO);
	}

	@Override
	public List<EqpmnVO> selectEquipList(PaginationInfoVO<EqpmnVO> pagingVO) {
		return equipMapper.selectEquipList(pagingVO);
	}

	@Override
	public List<CommonCodeVO> selectCommonList(String groupId) {
		return equipMapper.selectCommonList(groupId);
	}

	 @Override
	    public int selectEquipCountByStatus(String status) {
	        return equipMapper.selectEquipCountByStatus(status);
	    }

	@Override
	@Transactional
	public int rentEquipment(EqpmnVO form) {
		  
        int hist = equipMapper.insertEquipHistory(form);

        // 2) 상태 업데이트: 13002(대여중)
        int upd  = equipMapper.updateEqpmnStatus(form.getEqpmnNo(), "13002");

        return (hist > 0 && upd > 0) ? 1 : 0;
    }

	@Override
    @Transactional
    public int returnEquipment(String eqpmnNo, String empNo, String returnCondition, String memo) {
        // 반납 일자(YYYYMMDD) — rturn_dt 컬럼이 DATE면 TO_CHAR/TO_DATE로 XML에서 맞춰도 무방
        String nowYmd = new SimpleDateFormat("yyyyMMdd").format(new Date());

        // 1) 대여자 본인 & 미반납(OPEN) 이력에 한해서만 반납 처리
        int updated = equipMapper.updateReturnIfRenter(eqpmnNo, empNo, nowYmd, (memo == null ? "" : memo));
        if (updated > 0) {
            // 2) 장비 상태 갱신
            String newStatus = "고장".equals(returnCondition) ? "13003" : "13001";
            equipMapper.updateEqpmnStatus(eqpmnNo, newStatus);
            return 1; // 성공
        }

        // 3) 업데이트 0건 → 현재 대여중인지 여부로 코드 판정
        int renting = equipMapper.countCurrentRent(eqpmnNo);
        if (renting > 0) return -1; // 대여자 아님(타인이 대여중)
        return -2;                  // 현재 대여중 아님
    }

	
	
	
}
