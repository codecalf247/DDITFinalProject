package kr.or.ddit.employee.library.Tlibrary.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.library.Tlibrary.mapper.ItlibraryMapper;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Service
public class TlibraryServiceImpl implements Itlibrary {
	
	@Autowired
	private ItlibraryMapper mapper;

	@Override
	public List<FoldersVO> selectTfolderList(Map<String, Object> folderParam) {
		return mapper.selectTfolderList(folderParam);
	}

	@Override
	public List<FolderFileVO> selectTfileList(Map<String, Object> fileParam) {
		return mapper.selectTfileList(fileParam);
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
	public void TinsertFile(FolderFileVO folderFileVO) {
		mapper.TinsertFile(folderFileVO);
	}

	@Override
	public void TinsertFolder(FoldersVO foldersVO) {
		mapper.TinsertFolder(foldersVO);
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

	@Transactional
	@Override
	public void tdeleteFolder(int folderNo) {
		String delYn = "D";
        mapper.updateFoldersDelYn(folderNo, delYn);
        mapper.updateFolderFilesDelYn(folderNo, delYn);
        mapper.updateFolderDelYnByFolderNo(folderNo);
    }

	@Override
	public void tdeleteFile(int fileNo) {
		  mapper.updateFileDelYn(fileNo, "Y");
	}

	@Override
	public void trestoreFolder(int folderNo) {
		String delYn = "N";
        mapper.updateFoldersDelYn(folderNo, delYn);
        mapper.updateFolderFilesDelYn(folderNo, delYn);
        mapper.updateFolderRestore(folderNo); 
	        
	    }

	@Override
	public void trestoreFile(int fileNo) {
		   mapper.updateFileDelYn(fileNo, "N");
	}

	@Override
	public void tpermanentlyDeleteFile(int fileNo) {
		mapper.tpermanentlyDeleteFile(fileNo);
	}

	@Override
	public void tpermanentlyDeleteFolder(int folderNo) {
		// 1. 하위 파일 삭제
	    mapper.deleteFilesByFolderRecursively(folderNo);
	    
	    // 2. 하위 폴더 삭제	
	    mapper.deleteFoldersRecursively(folderNo);

	}

	@Override
	public Long selectTotalFileSize(Integer deptNo) {
		return mapper.selectTotalFileSize(deptNo);
	}

	@Override
	public List<FoldersVO> selectTyfolderList(Map<String, Object> folderParam) {
		return mapper.selectTyfolderList(folderParam);
	}

	@Override
	public List<FolderFileVO> selectTyfileList(Map<String, Object> fileParam) {
		return mapper.selectTyfileList(fileParam);
	}




}
