package kr.or.ddit.employee.project.service;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.mapper.IProjectPhotosMapper;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectPhotosVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectPhotosServiceImpl implements IProjectPhotosService {
	
	@Autowired
	private IProjectPhotosMapper pMapper;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	
	
	// 사진 페이지 불러오기 
	@Override
	public List<ProjectPhotosVO> selectPhotoList(int prjctNo) {
		return pMapper.selectPhotoList(prjctNo);
	}

	@Override
	public ProjectPhotosVO selectPhotoDetail(int photoNo) {
		return pMapper.selectPhotoDetail(photoNo);
	}

	
	@Transactional(rollbackFor = Exception.class)
    @Override
    public ServiceResult insertPhoto(ProjectPhotosVO photoVO, List<MultipartFile> files) {
		 log.info("==> Service.insertPhoto() 호출");
	        
		 try {
	            // 1. 파일 그룹 번호 생성
	            int fileGroupNo = pMapper.generateFileGroupNo();
	            photoVO.setFileGroupNo(fileGroupNo);
	            log.info("파일 그룹 번호 생성: {}", fileGroupNo);
	            
	            if (photoVO.getCategories() != null && !photoVO.getCategories().isEmpty()) {
	                String categoryCodes = photoVO.getCategories().stream().collect(Collectors.joining(","));
	                photoVO.setProcsTy(categoryCodes);
	                log.info("공정유형 코드(DB 저장용): {}", categoryCodes);
	            }
	            
	            // SPT_PHOTO 테이블에 사진 정보 등록
	            log.info("SPT_PHOTO 테이블에 사진 정보 등록 시도");
	            int photoInsertResult = pMapper.insertPhoto(photoVO);
	            if (photoInsertResult < 1) {
	                log.error("사진 정보 DB 등록 실패");
	                return ServiceResult.FAILED;
	            }
	            log.info("사진 정보 DB 등록 성공. SPT_PHOTO_NO: {}", photoVO.getSptPhotoNo());
	            
	            // 첨부파일 처리 및 FILES 테이블에 정보 등록
	            log.info("첨부파일 처리 시작. 총 파일 개수: {}", files.size());
	            for (MultipartFile file : files) {
	                if (!file.isEmpty()) {
	                    String originalNm = file.getOriginalFilename();
	                    String savedNm = UUID.randomUUID().toString() + "_" + originalNm;
	                    
	                    FilesVO fVO = new FilesVO();
	                    fVO.setFileGroupNo(fileGroupNo);
	                    fVO.setOriginalNm(originalNm);
	                    fVO.setSavedNm(savedNm);
	                    fVO.setFilePath("/upload/" + savedNm);
	                    fVO.setFileSize((int) file.getSize());
	                    fVO.setFileUploader(photoVO.getEmpNo());
	                    fVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fVO.getFileSize()));
	                    fVO.setFileMime(file.getContentType());
	                    
	                    log.info("파일 정보 DB 등록 시도: {}", originalNm);
	                    pMapper.insertFiles(fVO);
	                    log.info("파일 정보 DB 등록 성공. 파일 번호: {}", fVO.getFileNo());
	                    
	                    File saveFile = new File(uploadPath, savedNm);
	                    file.transferTo(saveFile);
	                    log.info("파일 시스템에 파일 저장 성공: {}", saveFile.getAbsolutePath());
	                }
	            }
	            
	            log.info("==> Service.insertPhoto() 성공적으로 완료");
	            return ServiceResult.OK;
	        } catch (IOException e) {
	            log.error("파일 처리 중 오류 발생", e);
	            throw new RuntimeException("파일 처리 중 오류가 발생했습니다.", e);
	        }
	    }

	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public ServiceResult updatePhoto(ProjectPhotosVO photoVO,
	                                 List<MultipartFile> newFiles,
	                                 List<Integer> deleteFileNos) {
	    log.info("==> Service.updatePhoto() 시작");

	    ProjectPhotosVO existing = pMapper.selectPhotoDetail(photoVO.getSptPhotoNo());
	    if (existing == null) {
	        log.error("해당 사진이 존재하지 않습니다. sptPhotoNo={}", photoVO.getSptPhotoNo());
	        return ServiceResult.FAILED;
	    }

	    // 공정유형 문자열 세팅
	    if (photoVO.getCategories() != null && !photoVO.getCategories().isEmpty()) {
	        photoVO.setProcsTy(photoVO.getCategories().stream().collect(Collectors.joining(",")));
	    } else {
	        photoVO.setProcsTy(null);
	    }

	    // 제목/공정유형 업데이트
	    int upCnt = pMapper.updatePhotoBasic(photoVO);
	    if (upCnt < 1) {
	        log.error("사진 기본정보 업데이트 실패");
	        return ServiceResult.FAILED;
	    }

	    int fileGroupNo = existing.getFileGroupNo();

	    // 선택 삭제 (DB del_yn='Y' + 물리 파일 삭제)
	    if (deleteFileNos != null && !deleteFileNos.isEmpty()) {
	        List<FilesVO> toDelete = pMapper.selectFilesByNos(deleteFileNos);
	        pMapper.deleteFilesByNos(deleteFileNos);

	        for (FilesVO f : toDelete) {
	            try {
	                String savedNm = f.getSavedNm();
	                if (savedNm != null) {
	                    File file = new File(uploadPath, savedNm);
	                    if (file.exists()) {
	                        FileUtils.forceDelete(file);
	                        log.info("파일 삭제: {}", file.getAbsolutePath());
	                    }
	                }
	            } catch (IOException e) {
	                log.warn("파일 삭제 중 예외(무시): {}", f.getSavedNm(), e);
	            }
	        }
	    }

	    // 새 파일 추가
	    if (newFiles != null && !newFiles.isEmpty()) {
	        for (MultipartFile file : newFiles) {
	            if (!file.isEmpty()) {
	                String originalNm = file.getOriginalFilename();
	                String savedNm = UUID.randomUUID().toString() + "_" + originalNm;

	                FilesVO fVO = new FilesVO();
	                fVO.setFileGroupNo(fileGroupNo);
	                fVO.setOriginalNm(originalNm);
	                fVO.setSavedNm(savedNm);
	                fVO.setFilePath("/upload/" + savedNm);
	                fVO.setFileSize((int) file.getSize());
	                fVO.setFileUploader(photoVO.getEmpNo());
	                fVO.setFileFancysize(FileUtils.byteCountToDisplaySize(fVO.getFileSize()));
	                fVO.setFileMime(file.getContentType());

	                pMapper.insertFiles(fVO);

	                File saveFile = new File(uploadPath, savedNm);
	                File parent = saveFile.getParentFile();
	                if (parent != null && !parent.exists() && !parent.mkdirs()) {
	                    log.error("업로드 경로 생성 실패: {}", parent.getAbsolutePath());
	                    throw new RuntimeException("업로드 경로를 생성할 수 없습니다.");
	                }

	                try {
	                    file.transferTo(saveFile);
	                    log.info("신규 파일 저장 완료: {}", saveFile.getAbsolutePath());
	                } catch (IOException | IllegalStateException e) {
	                    log.error("파일 저장 실패: {}", saveFile.getAbsolutePath(), e);
	                    throw new RuntimeException("파일 저장 중 오류가 발생했습니다.", e);
	                }
	            }
	        }
	    }

	    log.info("==> Service.updatePhoto() 완료");
	    return ServiceResult.OK;
	}
	
	
	
	
	
	


@Transactional(rollbackFor = Exception.class)
@Override
public ServiceResult deletePhoto(long sptPhotoNo) {
    // 1) 남아있는 파일번호 조회
    List<Integer> fileNos = pMapper.selectFileNosBySptPhotoNo((int) sptPhotoNo);

    // 2) 물리삭제를 위한 파일 메타
    List<FilesVO> files = fileNos.isEmpty() ? List.of() : pMapper.selectFilesByNos(fileNos);

    // 3) DB 논리삭제
    if (!fileNos.isEmpty()) {
        pMapper.deleteFilesByNos(fileNos);
    }

    // 4) 물리 파일 삭제(실패는 경고만)
    for (FilesVO f : files) {
        String savedNm = f.getSavedNm();
        if (savedNm == null) continue;
        try {
            File target = new File(uploadPath, savedNm);
            if (target.exists()) FileUtils.forceDelete(target);
        } catch (IOException ex) {
            log.warn("물리 파일 삭제 실패(무시): {}", savedNm, ex);
        }
    }

    // 5) 사진 행 삭제
    int cnt = pMapper.deletePhoto((int) sptPhotoNo);
    return cnt > 0 ? ServiceResult.OK : ServiceResult.FAILED;
}

@Override
public ServiceResult deleteFilesImmediately(List<Integer> fileNos) {
	if (fileNos == null || fileNos.isEmpty()) return ServiceResult.FAILED;
    try {
        // 1) 삭제 대상 조회
        List<FilesVO> toDelete = pMapper.selectFilesByNos(fileNos);

        // 2) DB 논리삭제
        pMapper.deleteFilesByNos(fileNos);

        // 3) 물리삭제(실패 무시하고 계속)
        for (FilesVO f : toDelete) {
            try {
                String savedNm = f.getSavedNm();
                if (savedNm != null) {
                    File file = new File(uploadPath, savedNm);
                    if (file.exists()) FileUtils.forceDelete(file);
                }
            } catch (IOException e) {
                log.warn("물리 파일 삭제 실패(무시): {}", f.getSavedNm(), e);
            }
        }
        return ServiceResult.OK;
    } catch (Exception e) {
        log.error("deleteFilesImmediately 오류", e);
        return ServiceResult.FAILED;
    }
}





// PAGING 처리 

@Override
public int selectPhotoCount(PaginationInfoVO<ProjectPhotosVO> pagingVO) {
	return pMapper.selectPhotoCount(pagingVO);
}

@Override
public List<ProjectPhotosVO> selectPhotoListWithPaging(PaginationInfoVO<ProjectPhotosVO> pagingVO) {
	return pMapper.selectPhotoListWithPaging(pagingVO);
}
}
	
	


	