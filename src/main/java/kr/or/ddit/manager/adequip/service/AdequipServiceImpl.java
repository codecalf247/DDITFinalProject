package kr.or.ddit.manager.adequip.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.manager.adequip.mapper.IEquipMapper;
import kr.or.ddit.vo.CommonCodeVO;
import kr.or.ddit.vo.EqpmnVO;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class AdequipServiceImpl implements IAdequipService   {

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private IEquipMapper equipMapper;
	
	@Override
	public int generateFileGroupNo() {
		return equipMapper.generateFileGroupNo();
	}

	@Override
	public void insertFile(FilesVO fileVO) {
		equipMapper.insertFile(fileVO);
		
	}

	@Override
	public int insertEquip(EqpmnVO eqpmnVO) {
		return equipMapper.insertEquip(eqpmnVO);
	}

	@Override
	public int selectEqpmnCount(PaginationInfoVO<EqpmnVO> pagingVO) {
		return equipMapper.selectEqpmnCount(pagingVO);
	}

	@Override
	public List<EqpmnVO> selectEqpmnList(PaginationInfoVO<EqpmnVO> pagingVO) {
		return equipMapper.selectEqpmnList(pagingVO);
	}

	@Override
	public List<CommonCodeVO> selectCommonList(String groupId) {
		return equipMapper.selectCommonList(groupId);
	}

	@Override
	public ServiceResult updateEqpmn(EqpmnVO eqpmnVO) {
		ServiceResult result = null;
		MultipartFile uploadFiles = eqpmnVO.getUploadFile();
		// 파일 업로드 (수정)
		try {
			uploadEqpmnFile(uploadFiles, eqpmnVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		int status = equipMapper.updateEqpmn(eqpmnVO);
		if(status > 0){
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	private void uploadEqpmnFile(MultipartFile uploadFiles, EqpmnVO eqpmnVO) throws Exception {
		if(uploadFiles != null && uploadFiles.getOriginalFilename() != null && !uploadFiles.getOriginalFilename().equals("")) {
			String path = uploadPath + "eqpmn/" + eqpmnVO.getEqpmnNo();
			File file = new File(path);
			if(!file.exists()) {
				file.mkdirs();
			}
			
			String fileName = UUID.randomUUID() + uploadFiles.getOriginalFilename();
			path += "/" + fileName;
			
			FilesVO fVO = eqpmnVO.getFilesVO();
			fVO.setFileGroupNo(eqpmnVO.getFileGroupNo());
			fVO.setSavedNm(fileName);
			fVO.setFileUploader(eqpmnVO.getEmpNo());
			fVO.setFilePath("/upload/eqpmn/" + eqpmnVO.getEqpmnNo() + "/" + fileName);
			
			equipMapper.deleteEqpmnFile(eqpmnVO.getFileGroupNo());
			equipMapper.insertFile(fVO);
			
			File nFile = new File(path);
			uploadFiles.transferTo(nFile);
		}
	}

	@Override
	@Transactional
	public void deleteEqpmnCascade(String eqpmnNo, int fileGroupNo) {
	    // 1) 파일 그룹이 있으면 파일 먼저 소프트삭제
	    if (fileGroupNo > 0) {
	        int affectedFiles = equipMapper.deleteEqpmnFile(fileGroupNo);
	    }

	    // 2) 장비 삭제
	    int affectedEqpmn = equipMapper.deleteEqpmn(eqpmnNo);
	    if (affectedEqpmn == 0) {
	        // 삭제대상이 없으면 롤백 유도
	        throw new IllegalStateException("장비 삭제 대상이 없습니다. eqpmnNo=" + eqpmnNo);
	    }		
		
	}

}













