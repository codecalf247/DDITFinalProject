package kr.or.ddit.employee.cmmn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.cmmn.mapper.ICMMNMapper;
import kr.or.ddit.vo.CommonCodeVO;

@Service
public class CMMNServiceImpl implements ICMMNService{
	
	@Autowired
	private ICMMNMapper CMMNMapper;

	@Override
	public String getCMMNId(String CMMNCdNm) {
		return CMMNMapper.getCMMNID(CMMNCdNm);
	}

	@Override
	public String getCMMNName(String CMMNId) {
		return CMMNMapper.getCMMNName(CMMNId);
	}

	@Override
	public String getCMMNIdByGroupId(String groupId, String cMMNCdNm) {
		Map<String, Object> map = new HashMap<>();
		map.put("groupId", groupId);
		map.put("cMMNCdNm", cMMNCdNm);
		return CMMNMapper.getCMMNIdByGroupId(map);
	}

	@Override
	public String getCMMNNamebyGroupId(String groupId, String cMMNId) {
		Map<String, Object> map = new HashMap<>();
		map.put("groupId", groupId);
		map.put("CMMNId", cMMNId);
		return CMMNMapper.getCMMNNamebyGroupId(map);
	}

	@Override
	public List<CommonCodeVO> getCMMNListbyGroupId(String groupId) {
		return CMMNMapper.getCMMNListbyGroupId(groupId);
	}

}
