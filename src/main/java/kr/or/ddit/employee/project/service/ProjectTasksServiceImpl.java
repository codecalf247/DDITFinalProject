package kr.or.ddit.employee.project.service;


import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.project.mapper.IProjectTasksMapper;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectTaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectTasksServiceImpl implements IProjectTasksService {
	
	@Autowired
	private IProjectTasksMapper ptMapper;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	

	@Override
	public int checkProjectParticipant(int prjctNo, String empNo) {
		return ptMapper.checkProjectParticipant(prjctNo, empNo);
	}

	@Override
	public PaginationInfoVO<ProjectTaskVO> selectTaskAjaxList(PaginationInfoVO<ProjectTaskVO> pagingVO) {
		  int totalRecord = ptMapper.selectTaskCount(pagingVO);
		  
	        pagingVO.setTotalRecord(totalRecord);
	        if (totalRecord > 0) {
	            List<ProjectTaskVO> list = ptMapper.selectTaskAjaxList(pagingVO);
	            pagingVO.setDataList(list);
	        }
	        return pagingVO;
	    
	}

	
	
		@Transactional(rollbackFor = Exception.class)
	    @Override
	    public ServiceResult insertTask(ProjectTaskVO task, List<MultipartFile> files) {
	       
		
		    //  부모(참여자) 존재 보장
		   
		    // FK: TASK.(PRJCT_NO, EMP_NO) -> PRJCT_PRTCPNT.(PRJCT_NO, EMP_NO)
		    // -> 작성자(task.empNo)가 해당 프로젝트 참여자여야 함
		 
		    int writerCnt = ptMapper.checkProjectParticipant(task.getPrjctNo(), task.getEmpNo());
		    if (writerCnt == 0) {
		        // TIMHDER_YN: NOT NULL -> 기본 'N'
		        // PRJCT_PRTCPNT_TYPE: NULL 가능 -> 일단 null (정책 있으면 "현"/"디자인" 등 사용)
		        ptMapper.insertProjectParticipant(task.getPrjctNo(), task.getEmpNo(), "N", null);
		    }

		    // (선택) 담당자도 참여자에 없으면 넣어 두면 이후 권한/조회가 깔끔해짐
		    if (task.getTaskCharger() != null && !task.getTaskCharger().isEmpty()) {
		        int chargerCnt = ptMapper.checkProjectParticipant(task.getPrjctNo(), task.getTaskCharger());
		        if (chargerCnt == 0) {
		            ptMapper.insertProjectParticipant(task.getPrjctNo(), task.getTaskCharger(), "N", null);
		        }
		    }

		    // ===== 1) 업로드 존재 여부 정확히 판단
		    boolean hasUpload = false;
		    if (files != null) {
		        for (MultipartFile mf : files) {
		            if (mf != null && !mf.isEmpty()) { hasUpload = true; break; }
		        }
		    }

		    // ===== 2) 파일그룹 번호 생성(업로드 있을 때만)
		    Integer fileGroupNo = null;
		    if (hasUpload) {
		        fileGroupNo = ptMapper.generateFileGroupNo();
		        task.setFileGroupNo(fileGroupNo);
		    } else {
		        task.setFileGroupNo(null);
		    }

		    // ===== 3) TASK insert
		    int row = ptMapper.insertTask(task);
		    if (row < 1) throw new RuntimeException("TASK 저장 실패");

		    // ===== 4) 파일 메타/실파일 저장
		    if (hasUpload) {
		        for (MultipartFile mf : files) {
		            if (mf == null || mf.isEmpty()) continue;

		            String original = mf.getOriginalFilename();
		            String saveName = java.util.UUID.randomUUID() + "_" + original;
		            int size = (int) mf.getSize();

		            FilesVO fvo = new FilesVO();
		            fvo.setFileGroupNo(fileGroupNo);
		            fvo.setOriginalNm(original);
		            fvo.setSavedNm(saveName);
		            fvo.setFilePath("/upload/" + saveName); // 정적 매핑 경로
		            fvo.setFileSize(size);
		            fvo.setFileFancysize(org.apache.commons.io.FileUtils.byteCountToDisplaySize(size));
		            fvo.setFileMime(mf.getContentType());
		            fvo.setFileUploader(task.getEmpNo());

		            int fr = ptMapper.insertFiles(fvo);
		            if (fr < 1) throw new RuntimeException("파일 메타 저장 실패");

		            // 저장 경로 안전(슬래시 보정)
		            String base = uploadPath;
		            if (!base.endsWith("/") && !base.endsWith(File.separator)) {
		                base += File.separator;
		            }
		            File dest = new File(base + saveName);
		            try {
		                mf.transferTo(dest);
		            } catch (IOException e) {
		                log.error("파일 저장 실패", e);
		                throw new RuntimeException("파일 저장 실패", e);
		            }
		        }
		    }
		    return ServiceResult.OK;
		}
		
		
		
	 @Override
	 public ProjectTaskVO selectTaskByPk(int prjctNo, int taskNo, String loginEmpNo) {
		 return ptMapper.selectTaskByPk(prjctNo, taskNo, loginEmpNo);
	 }

	 @Override
	 @Transactional(rollbackFor = Exception.class)
	 public ServiceResult updateTask(ProjectTaskVO task) {
	     int r = ptMapper.updateTask(task);
	     return r > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	 }

	 
	 

	@Override
	public Map<String, Integer> selectEachTaskCounts(int prjctNo, String procsTy, String searchWord) {
		Map<String, Object> raw = ptMapper.selectEachTaskCounts(prjctNo, procsTy, searchWord);

        Map<String, Integer> out = new HashMap<>();
        out.put("all",      toInt(raw, "ALL_COUNT"));
        out.put("wait",     toInt(raw, "WAIT_COUNT"));
        out.put("progress", toInt(raw, "PROGRESS_COUNT"));
        out.put("review",   toInt(raw, "REVIEW_COUNT"));
        out.put("done",     toInt(raw, "DONE_COUNT"));
        return out;
    }

	
	  private int toInt(Map<String, Object> map, String key) {
	        Object v = (map == null ? null : map.get(key));
	        if (v == null) return 0;
	        if (v instanceof Number) return ((Number) v).intValue();
	        try { return Integer.parseInt(String.valueOf(v)); } catch (Exception e) { return 0; }
	    }

	  @Override
	  public List<FilesVO> selectFilesByGroupNo(Integer fileGroupNo) {
		  if (fileGroupNo == null || fileGroupNo <= 0) {
		        return java.util.Collections.emptyList();
		    }
		    return ptMapper.selectFilesByGroupNo(fileGroupNo);
	  }

	  
	  
	  
	  // 칸반
	  @Override
	  public int updateTaskProgressAndStatus(int taskNo, int prjctNo, int progrs, String sttus, String empNo) {
		  return ptMapper.updateTaskProgressAndStatus(taskNo, prjctNo, progrs, sttus);
	  }
	  
	  @Override
	  public List<ProjectTaskVO> selectTasksByProject(int prjctNo) {
		  List<ProjectTaskVO> list = ptMapper.selectTasksByProject(prjctNo);
		    return (list == null) ? Collections.emptyList() : list;
		}

	@Transactional
	@Override
	public ServiceResult deleteTask(int prjctNo, int taskNo) {
		// 1. 일감 조회
	    ProjectTaskVO task = ptMapper.selectTask(prjctNo, taskNo);
	    if (task == null) {
	        return ServiceResult.FAILED;
	    }

	    // 2. 파일 그룹 삭제
	    Integer fileGroupNo = task.getFileGroupNo();
	    if (fileGroupNo != null && fileGroupNo > 0) {
	    	ptMapper.deleteFilesByGroupNo(fileGroupNo);
	    }

	    // 3. 일감 삭제
	    int result = ptMapper.deleteTask(prjctNo, taskNo);

	    return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	
	
}
	