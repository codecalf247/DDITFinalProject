package kr.or.ddit.employee.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.employee.project.mapper.IEstimateMapper;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PrqudoVO;

@Service
public class EstimateServiceImpl implements Iestimate {
	
	@Autowired
	private IEstimateMapper mapper;

	@Override
	public List<PrqudoVO> estimateList(int prjctNo) {
		return mapper.estimateList(prjctNo);
	}

	@Override
	public int generateFileGroupNo() {
		return mapper.generateFileGroupNo();
	}

	@Override
	public void insert(PrqudoVO prq) {
		mapper.insert(prq);
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		mapper.insertFile(fileVO);
	}

	@Override
	public PrqudoVO selectEstimate(int prjctNo) {
		return mapper.selectEstimate(prjctNo);
	}

	@Override
	public void estimateUpdate(PrqudoVO prqVO) {
		mapper.estimateUpdate(prqVO);
	}

	@Override
	public void updateFileGroupNo(PrqudoVO prqVO) {
		mapper.updateFileGroupNo(prqVO);
	}

	@Override
	public void deleteFileGroupNo(int fileGroupNo) {
		mapper.deleteFileGroupNo(fileGroupNo);
	}

	@Override
	public void deleteEstimate(int prqudoNo) {
		mapper.deleteEstimate(prqudoNo);
	}

	@Override
	public int updateFileDelYn(int fileNo) {
		return mapper.updateFileDelYn(fileNo);
	}

}
