package kr.or.ddit.employee.library.Alibrary.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.library.Alibrary.mapper.IalibraryMapper;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Service
public class AlibraryServiceImpl implements Ialibrary {
	
	@Autowired
	private IalibraryMapper mapper;

	@Override
	public Long selectTotalFileSize(int deptNo) {
		return mapper.selectTotalFileSize(deptNo);
	}

	@Override
	public List<FoldersVO> selectAfolderList(Map<String, Object> folderParam) {
		return mapper.selectAfolderList(folderParam);
	}

	@Override
	public List<FolderFileVO> selectAfileList(Map<String, Object> fileParam) {
		return mapper.selectAfileList(fileParam);
	}
	
	private FoldersVO selectFolder(int upperFolder) {
		return mapper.selectFolder(upperFolder);
	}

	@Override
	public List<FoldersVO> getParentFolders(int folderNo) {
		List<FoldersVO> path = new ArrayList<>();
        FoldersVO currentFolder = selectFolder(folderNo);

        while (currentFolder != null) {
            path.add(currentFolder);
            // 상위 폴더가 null이 아니면 계속 상위 폴더를 찾음
            if (currentFolder.getUpperFolder() != null) {
                currentFolder = selectFolder(currentFolder.getUpperFolder());
            } else {
                // 최상위 폴더에 도달하면 반복문 종료
                currentFolder = null;
            }
        }
		
		Collections.reverse(path);
		return path;
	}

	@Override
	public void AinsertFile(FolderFileVO folderFileVO) {
		mapper.AinsertFile(folderFileVO);
	}

	@Override
	public void AinsertFolder(FoldersVO foldersVO) {
		mapper.AinsertFolder(foldersVO);
	}

	@Override
	public FolderFileVO selectFileByFileNo(int fileNo) {
		return mapper.selectFileByFileNo(fileNo);
	}

	@Override
	public void updateFileFolder(Map<String, Object> param) {
		mapper.updateFileFolder(param);
	}

	@Override
	public void updateFolderParent(Map<String, Object> param) {
		mapper.updateFolderParent(param);
	}

	@Override
	public List<FoldersVO> selectAyfolderList(Map<String, Object> folderParam) {
		return mapper.selectAyfolderList(folderParam);
	}

	@Override
	public List<FolderFileVO> selectAyfileList(Map<String, Object> fileParam) {
		return mapper.selectAyfileList(fileParam);
	}

	 @Override
	    @Transactional
	    public void adeleteFolder(int folderNo) {
//	        // 1. 폴더와 하위 폴더의 DEL_YN을 'Y'로 업데이트
//	        mapper.updateFolderDelYn(folderNo, delYn);
//	        // 2. 해당 폴더 내의 모든 파일의 DEL_YN을 'Y'로 업데이트
//	        mapper.updateFilesByFolderNo(folderNo, delYn);
//	        // 3. 현재 폴더만 del_yn 을 'Y'로 변경
//	        mapper.updateFolderDelYnByFolderNo(folderNo);

		 	String delYn = "D";
	        mapper.updateFoldersDelYn(folderNo, delYn);
	        mapper.updateFolderFilesDelYn(folderNo, delYn);
	        mapper.updateFolderDelYnByFolderNo(folderNo);
	 }

	@Override
	public void adeleteFile(int fileNo) {
	  mapper.updateFileDelYn(fileNo, "Y");
	}

	@Override
	public void arestoreFolder(int folderNo) {
		String delYn = "N";
        mapper.updateFoldersDelYn(folderNo, delYn);
        mapper.updateFolderFilesDelYn(folderNo, delYn);
        mapper.updateFolderRestore(folderNo); ;

	}

	@Override
	public void arestoreFile(int fileNo) {
	   mapper.updateFileDelYn(fileNo, "N");

	}

	@Override
	public void apermanentlyDeleteFile(int fileNo) {
		mapper.apermanentlyDeleteFile(fileNo);

	}

	@Override
	public void apermanentlyDeleteFolder(int folderNo) {
		// 1. 하위 파일 삭제
	    mapper.deleteFilesByFolderRecursively(folderNo);
	    
	    // 2. 하위 폴더 삭제	
	    mapper.deleteFoldersRecursively(folderNo);

	}

}
