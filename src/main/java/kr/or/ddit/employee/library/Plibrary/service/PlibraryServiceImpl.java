package kr.or.ddit.employee.library.Plibrary.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.employee.library.Plibrary.mapper.IplibraryMapper;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Service
public class PlibraryServiceImpl implements Iplibrary {
	
	@Autowired
	private IplibraryMapper mapper;

	@Override
	public void PinsertFile(FolderFileVO folderFileVO) {
		mapper.PinsertFile(folderFileVO);

	}

	@Override
	public void PinsertFolder(FoldersVO foldersVO) {
		mapper.PinsertFolder(foldersVO);
	}

	@Override
	public List<FoldersVO> selectPfolderList(Map<String, Object> folderParam) {
		return mapper.selectPfolderList(folderParam);
	}

	@Override
	public List<FolderFileVO> selectPfileList(Map<String, Object> fileParam) {
		return mapper.selectPfileList(fileParam);
	}

	@Override
	public FoldersVO selectFolder(int upperFolder) {
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
	public void updateFileFolder(Map<String, Object> param) {
		 mapper.updateFileFolder(param);
	}

	@Override
	public void updateFolderParent(Map<String, Object> param) {
		 mapper.updateFolderParent(param);
	}

	@Override
	public FolderFileVO selectFileByFileNo(int fileNo) {
		return mapper.selectFileByFileNo(fileNo);
	}
	    @Override
	    @Transactional
	    public void deleteFolder(int folderNo) {
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
	    @Transactional
	    public void restoreFolder(int folderNo) {
//	        // 1. 폴더의 DEL_YN을 'N'으로, UPPER_FOLDER를 '10001'로 업데이트
//	        mapper.updateFolderRestore(folderNo); 
//	        // 2. 해당 폴더 내의 모든 파일의 DEL_YN을 'N'으로 업데이트
//	        mapper.updateFilesByFolderNo(folderNo, "N"); 
	        

		 	String delYn = "N";
	        mapper.updateFoldersDelYn(folderNo, delYn);
	        mapper.updateFolderFilesDelYn(folderNo, delYn);
	        mapper.updateFolderRestore(folderNo); 
	    }

	    @Override
	    public void deleteFile(int fileNo) {
	        mapper.updateFileDelYn(fileNo, "Y");
	    }

	    @Override
	    public void restoreFile(int fileNo) {
	        mapper.updateFileDelYn(fileNo, "N");
	    }

		@Override
		public List<FoldersVO> selectPyfolderList(Map<String, Object> folderParam) {
			return mapper.selectPyfolderList(folderParam);
		}

		@Override
		public List<FolderFileVO> selectPyfileList(Map<String, Object> fileParam) {
			return mapper.selectPyfileList(fileParam);
		}

		@Override
		public Long selectTotalFileSize(String empNo) {
			return mapper.selectTotalFileSize(empNo);
		}

		@Transactional
		@Override
		public void permanentlyDeleteFile(int fileNo) {
			mapper.permanentlyDeleteFile(fileNo);
		}

		@Transactional
		@Override
		public void permanentlyDeleteFolder(int folderNo) { 
			
			// 1. 하위 파일 삭제
		    mapper.deleteFilesByFolderRecursively(folderNo);
		    
		    // 2. 하위 폴더 삭제	
		    mapper.deleteFoldersRecursively(folderNo);


		}
	}
