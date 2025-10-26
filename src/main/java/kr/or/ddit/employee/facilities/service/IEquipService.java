package kr.or.ddit.employee.facilities.service;

import java.util.List;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IEquipService {

	public int selectEquipCount(PaginationInfoVO<EqpmnVO> pagingVO);

	public int selectEquipCountByStatus(String status);

	public List<EqpmnVO> selectEquipList(PaginationInfoVO<EqpmnVO> pagingVO);

	public List<CommonCodeVO> selectCommonList(String groupId);

	public int rentEquipment(EqpmnVO form);

	public int returnEquipment(String eqpmnNo, String empNo, String returnCondition, String defaultString);

	



}
