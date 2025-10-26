package kr.or.ddit.manager.admat.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.manager.admat.mapper.IAdmatMapper;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.MtrilVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class AdmatServiceImpl implements IAdmatService {

	@Autowired
	private IAdmatMapper admatMapper;

	@Override
	public void insertFile(FilesVO fileVO) {
		admatMapper.insertFile(fileVO);

	}

	@Override
	public int selectNextFileGroupNo() {
		return admatMapper.selectNextFileGroupNo();
	}

	@Override
	public int insertMtril(MtrilVO mtrilVO) {
		return admatMapper.insertMtril(mtrilVO);
	}

	@Override
	public int selectmatCount(PaginationInfoVO<MtrilVO> pagingVO) {
		return admatMapper.selectmatCount(pagingVO);
	}

	@Override
	public List<MtrilVO> selectmatList(PaginationInfoVO<MtrilVO> pagingVO) {
		return admatMapper.selectmatList(pagingVO);
	}

	@Override
	public List<CommonCodeVO> selectCommonList(String groupCd) {
		return admatMapper.selectCommonList(groupCd);
	}

	@Override
	public int deleteFilesByGroupNo(int fileGroupNo) {
		return admatMapper.deleteFilesByGroupNo(fileGroupNo);
	}
	

	@Override
	public int updateMtril(MtrilVO mtrilVO) {
		return admatMapper.updateMtril(mtrilVO);
	}
	
	@Override
    @Transactional
    public int deleteMaterial(String mtrilId, int fileGroupNo) {

        if (fileGroupNo > 0) {
            admatMapper.deleteFilesByGroupNo(fileGroupNo);
        }
        // 자재 삭제
        return admatMapper.deleteMtril(mtrilId);
    }

	


}
