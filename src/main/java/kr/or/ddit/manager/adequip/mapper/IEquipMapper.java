package kr.or.ddit.manager.adequip.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper 
public interface IEquipMapper {

	public int generateFileGroupNo();

	public void insertFile(FilesVO fileVO);

	public int insertEquip(EqpmnVO eqpmnVO);

	public int selectEqpmnCount(PaginationInfoVO<EqpmnVO> pagingVO);

	public List<EqpmnVO> selectEqpmnList(PaginationInfoVO<EqpmnVO> pagingVO);

	public List<CommonCodeVO> selectCommonList(String groupId);

	public int deleteEqpmnFile(int fileGroupNo);
	
	public int updateEqpmn(EqpmnVO eqpmnVO);

	public int deleteEqpmn(String eqpmnNo);


}
