package kr.or.ddit.employee.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PrqudoVO;

@Mapper
public interface IEstimateMapper {

	public List<PrqudoVO> estimateList(int prjctNo);

	public int generateFileGroupNo();

	public void insert(PrqudoVO prq);

	public void insertFile(FilesVO fileVO);

	public PrqudoVO selectEstimate(int prjctNo);

	public void estimateUpdate(PrqudoVO prqVO);

	public void updateFileGroupNo(PrqudoVO prqVO);

	public void deleteFileGroupNo(int fileGroupNo);

	public void deleteEstimate(int prqudoNo);

	public int updateFileDelYn(int fileNo);

}
