package kr.or.ddit.employee.cmmn.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommonCodeVO;

@Mapper
public interface ICMMNMapper {

	public String getCMMNID(String cMMNCdNm);
	
	public String getCMMNName(String cMMNId);

	public String getCMMNIdByGroupId(Map<String, Object> map);

	public String getCMMNNamebyGroupId(Map<String, Object> map);

	public List<CommonCodeVO> getCMMNListbyGroupId(String groupId);

}
