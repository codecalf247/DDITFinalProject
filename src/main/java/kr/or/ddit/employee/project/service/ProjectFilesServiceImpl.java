package kr.or.ddit.employee.project.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.mapper.IProjectFileMapper;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectFileVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectFilesServiceImpl implements IProjectFilesService {
	
	@Autowired
	private IProjectFileMapper pfMapper;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	
	
	
	// 프로젝트 참여자인지 판단
	@Override
	public int checkProjectParticipant(int prjctNo, String empNo) {
		return pfMapper.checkProjectParticipant(prjctNo, empNo);
	}

	// 트랜잭션 처리를 위해 어노테이션 추가 
	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertProjectFiles(ProjectFileVO pFile, List<MultipartFile> uploadFiles, String empNo) {
//		int prjctNo = pfMapper.getPrjctNo();
		
		
		int fileGroupNo = pfMapper.generateFileGroupNo();
		pFile.setFileGroupNo(fileGroupNo);
		
		
		log.info(pFile.toString());
		pFile.setEmpNo(empNo);
		
		// PRJCT_FILE 테이블에 자료 정보 등록
		pfMapper.insertProjectFile(pFile);
		
		// 파일 insert (저장 및 DB 정보 저장)
		if (uploadFiles != null && !uploadFiles.isEmpty()) {
			for(MultipartFile file : uploadFiles) {
				if(!file.isEmpty()) {
					String originalFileName = file.getOriginalFilename();
					String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
					
					FilesVO fVO = new FilesVO();
					fVO.setFileGroupNo(fileGroupNo);
					fVO.setOriginalNm(originalFileName);
					fVO.setSavedNm(saveFileName);
					// 파일 경로에 파일 이름까지 포함
					fVO.setFilePath("/upload/" + saveFileName);
					fVO.setFileSize((int) file.getSize());
					fVO.setFileUploader(empNo);
					fVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fVO.getFileSize()));
					fVO.setFileMime(file.getContentType());
					log.info("fvo:",fVO.toString());
					// DB에 파일 정보 삽입
					pfMapper.insertFiles(fVO);
					
					// 실제 파일을 로컬 디스크에 저장
					File saveFile = new File(uploadPath + saveFileName);
					try {
						file.transferTo(saveFile);
					} catch (IOException e) {
						log.error("파일 저장 실패", e);
						// IO 예외 발생 시 런타임 예외를 던져 트랜잭션 롤백
						throw new RuntimeException("파일 저장 중 오류가 발생했습니다.", e);
					}
				}
			}
		}
		
		// 모든 작업이 성공하면 1 반환
		return 1;
	}

	@Override
	public ProjectFileVO selectProjectFileDetail(int prjctFileNo) {
		return pfMapper.selectProjectFileDetail(prjctFileNo);
	}

	@Override
	public List<ProjectFileVO> selectFileList(int prjctNo, String fileTy) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("prjctNo", prjctNo);
		paramMap.put("fileTy", fileTy);
		
		return pfMapper.selectFileList(paramMap);
	}

	@Override
	public FilesVO selectFileByNo(int fileNo) {
		return pfMapper.selectFileByNo(fileNo);
	}

	
	// 자료 수정 기능 
	@Transactional(rollbackFor = Exception.class)
	@Override
	public ServiceResult updateProjectFiles(ProjectFileVO pFile, List<MultipartFile> uploadFiles, List<Integer> deleteFileNoList) {
		 try {
			 
			 log.info("업데이트 전 pFile 객체 정보:{}", pFile);
			 
	         // 1. 게시글 정보 업데이트
			  int updatePostResult = pfMapper.updateProjectFile(pFile);
			 log.info("업데이트 전 pFile 객체 정보:{}", updatePostResult);

			  // 2. 삭제 대상 파일 처리 (DB 논리적 삭제 및 물리적 삭제)
		        if (deleteFileNoList != null && !deleteFileNoList.isEmpty()) {
		            for (Integer fileNo : deleteFileNoList) {
		                FilesVO fileToDelete = pfMapper.selectFileByNo(fileNo);
		                if (fileToDelete != null) {
		                    // 파일 논리적 삭제
		                    pfMapper.deleteFileByFileNo(fileNo);
		                    
		                    // 물리적 파일 삭제
		                    File file = new File(uploadPath, fileToDelete.getSavedNm());
		                    if (file.exists()) {
		                        file.delete();
		                    }
		                }
		            }
		        }
	           // 3. 새로 업로드된 파일 처리
		        if (uploadFiles != null && !uploadFiles.isEmpty() && !uploadFiles.get(0).isEmpty()) {
		        	int fileGroupNo = pFile.getFileGroupNo();
//	               if (fileGroupNo == 0) {
//	                   fileGroupNo = pfMapper.generateFileGroupNo();
//	                   pFile.setFileGroupNo(fileGroupNo);
//	               }

	               for (MultipartFile file : uploadFiles) {
	                   if (!file.isEmpty()) {
	                       String originalFileName = file.getOriginalFilename();
	                       String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	                       
	                       FilesVO fVO = new FilesVO();
	                       fVO.setFileGroupNo(fileGroupNo);
	                       fVO.setOriginalNm(originalFileName);
	                       fVO.setSavedNm(saveFileName);
	                       fVO.setFilePath("/upload/" + saveFileName);
	                       fVO.setFileSize((int) file.getSize());
	                       
	                       fVO.setFileUploader(pFile.getFileUploader());
	                       fVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fVO.getFileSize()));
	                       fVO.setFileMime(file.getContentType());
	                       
	                       pfMapper.insertFiles(fVO); // DB에 새 파일 정보 삽입
	                       
	                       File saveFile = new File(uploadPath, saveFileName);
	                       file.transferTo(saveFile); // 물리적 파일 저장
	                    }
	                }
	            }
	            return ServiceResult.OK;
	        } catch (IOException e) {
	            log.error("자료 수정 중 파일 처리 오류 발생", e);
	            throw new RuntimeException("자료 수정 중 오류가 발생했습니다.", e);
	        }
	    }

	@Transactional(rollbackFor = Exception.class)
	@Override
	public ServiceResult deleteFileByFileNo(int fileNo) {
	    try {
	        FilesVO fileToDelete = pfMapper.selectFileByNo(fileNo);
	        if (fileToDelete == null) {
	            return ServiceResult.FAILED;
	        }

	        int updateResult = pfMapper.deleteFileByFileNo(fileNo);
	        if (updateResult > 0) {
	            File file = new File(uploadPath + File.separator + fileToDelete.getSavedNm());
	            if (file.exists()) {
	                file.delete();
	            }
	            return ServiceResult.OK;
	        }
	        return ServiceResult.FAILED;
	    } catch (Exception e) {
	        log.error("파일 삭제 중 오류 발생", e);
	        throw new RuntimeException("파일 삭제 중 오류가 발생했습니다.", e);
	    }
	}

	@Override
	public List<ProjectPerticipantVO> selectProjectPrtcptn(int prjctFileNo) {
		return pfMapper.selectProjectPrtcptn(prjctFileNo);
	}

	@Override
	@Transactional
	public ServiceResult deleteProjectFile(int fileNo) {
		// 1. 삭제할 자료의 파일 그룹 번호를 가져옴
	    ProjectFileVO pFile = pfMapper.selectProjectFileDetail(fileNo);
	    if (pFile == null) {
	        return ServiceResult.FAILED;
	    }
	    
	    // 2. 해당 자료에 연결된 모든 첨부파일을 논리적으로 삭제
	    //    이미 구현된 deleteFileByFileNo 쿼리를 재사용
	    if (pFile.getFileList() != null && !pFile.getFileList().isEmpty()) {
	        for (FilesVO file : pFile.getFileList()) {
	        	pfMapper.deleteFileByFileNo(file.getFileNo());
	        }
	    }

	    // 3. 자료(prjct_file)를 물리적으로 삭제
	    int result = pfMapper.deleteProjectFile(fileNo);

	    // 삭제 성공 여부에 따라 결과를 반환합니다.
	    return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
}

	@Override
	public int selectFileCount(PaginationInfoVO<ProjectFileVO> pagingVO) {
		return pfMapper.selectFileCount(pagingVO);
	}

	@Override
	public List<ProjectFileVO> selectFileAjaxList(PaginationInfoVO<ProjectFileVO> pagingVO) {
		return pfMapper.selectFileAjaxList(pagingVO);
	}
}
	