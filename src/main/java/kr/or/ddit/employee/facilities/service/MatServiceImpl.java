package kr.or.ddit.employee.facilities.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.facilities.mapper.IMatMapper;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class MatServiceImpl implements IMatService{

	

	@Autowired
	private IMatMapper matMapper;

	@Override
	public int selectFileGroupNo() {
		return matMapper.selectFileGroupNo();
	}

	@Override
	public int selectmaterialCount(PaginationInfoVO<MtrilVO> pagingVO) {
		return matMapper.selectmaterialCount(pagingVO);
	}

	@Override
	public List<MtrilVO> selectmaterialList(PaginationInfoVO<MtrilVO> pagingVO) {
		return matMapper.selectmaterialList(pagingVO);
	}

	@Override
	public List<CommonCodeVO> selectCmList(String string) {
		return matMapper.selectCmList(string);
	}

	 // ===== 입고 =====
    @Override
    @Transactional
    public void stockIn(MtrilVO vo) {
        // 재고 증가
        int u = matMapper.updateStockPlus(vo);
        if (u == 0) {
            // 자재ID가 없거나 업데이트 실패
            throw new IllegalStateException("입고 대상 자재를 찾을 수 없습니다.");
        }
        // 이력 기록 (INOUT_TY='1', INOUT_DT=SYSDATE)
        matMapper.insertHist(vo);
    }

    
    // ===== 출고 =====
    @Override
    @Transactional
    public void stockOut(MtrilVO vo) {
        // 재고 안전 감소 (부족하면 0행 업데이트)
        int u = matMapper.updateStockMinusSafe(vo);
        if (u == 0) {
            throw new IllegalStateException("재고가 부족합니다.");
        }
        // 이력 기록 (INOUT_TY='0', INOUT_DT=SYSDATE)
        matMapper.insertHist(vo);
    }

}
