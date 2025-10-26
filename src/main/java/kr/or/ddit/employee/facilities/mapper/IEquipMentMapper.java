package kr.or.ddit.employee.facilities.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface IEquipMentMapper {

 public	int selectEquipCount(PaginationInfoVO<EqpmnVO> pagingVO);

 public List<EqpmnVO> selectEquipList(PaginationInfoVO<EqpmnVO> pagingVO);

 public List<CommonCodeVO> selectCommonList(String groupId);

public int selectEquipCountByStatus(String status);

public int insertEquipHistory(EqpmnVO form);

public int updateEqpmnStatus(String eqpmnNo, String eqpmnSttus);

public int updateReturnIfRenter(String eqpmnNo, String empNo, String nowYmd, Object object);

public int countCurrentRent(String eqpmnNo);



	
	
	
}
