package kr.or.ddit.employee.library.Alibrary.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

public interface Ialibrary {

	public Long selectTotalFileSize(int deptNo);

	public List<FoldersVO> selectAfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectAfileList(Map<String, Object> fileParam);

	public List<FoldersVO> getParentFolders(int upperFolder);

	public void AinsertFile(FolderFileVO folderFileVO);

	public void AinsertFolder(FoldersVO foldersVO);

	public FolderFileVO selectFileByFileNo(int fileNo);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

	public List<FoldersVO> selectAyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectAyfileList(Map<String, Object> fileParam);

	public void adeleteFolder(int folderNo);

	public void adeleteFile(int fileNo);

	public void arestoreFolder(int folderNo);

	public void arestoreFile(int fileNo);

	public void apermanentlyDeleteFile(int fileNo);

	public void apermanentlyDeleteFolder(int folderNo);

}
