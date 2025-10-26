package kr.or.ddit.employee.library.Tlibrary.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

public interface Itlibrary {

	public List<FoldersVO> selectTfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectTfileList(Map<String, Object> fileParam);

	public List<FoldersVO> getParentFolders(int upperFolder);

	public void TinsertFile(FolderFileVO folderFileVO);

	public void TinsertFolder(FoldersVO foldersVO);

	public FolderFileVO selectFileByFileNo(int fileNo);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

	public void tdeleteFolder(int folderNo);

	public void tdeleteFile(int fileNo);

	public void trestoreFolder(int folderNo);

	public void trestoreFile(int fileNo);

	public void tpermanentlyDeleteFile(int fileNo);

	public void tpermanentlyDeleteFolder(int folderNo);

	public Long selectTotalFileSize(Integer deptNo);

	public List<FoldersVO> selectTyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectTyfileList(Map<String, Object> fileParam);


}
