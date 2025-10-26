package kr.or.ddit.manager.adequip.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IAdequipService {

  public int generateFileGroupNo();

public void insertFile(FilesVO fileVO);

public int insertEquip(EqpmnVO eqpmnVO);

public int selectEqpmnCount(PaginationInfoVO<EqpmnVO> pagingVO);

public List<EqpmnVO> selectEqpmnList(PaginationInfoVO<EqpmnVO> pagingVO);

public List<CommonCodeVO> selectCommonList(String string);

public ServiceResult updateEqpmn(EqpmnVO eqpmnVO);

public void deleteEqpmnCascade(String eqpmnNo, int fileGroupNo);

	
}
