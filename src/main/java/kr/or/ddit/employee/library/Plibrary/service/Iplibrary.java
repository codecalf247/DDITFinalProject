package kr.or.ddit.employee.library.Plibrary.service;


import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

public interface Iplibrary {

	public void PinsertFile(FolderFileVO folderFileVO);

	public void PinsertFolder(FoldersVO foldersVO);

	public List<FoldersVO> selectPfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectPfileList(Map<String, Object> fileParam);

	public List<FoldersVO> getParentFolders(int upperFolder);

	public FoldersVO selectFolder(int upperFolder);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

	public FolderFileVO selectFileByFileNo(int fileNo);

	public void deleteFolder(int folderNo);

	public void deleteFile(int fileNo);

	public void restoreFolder(int folderNo);

	public void restoreFile(int fileNo);

	public List<FoldersVO> selectPyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectPyfileList(Map<String, Object> fileParam);

	public Long selectTotalFileSize(String empNo);

	public void permanentlyDeleteFile(int fileNo);

	public void permanentlyDeleteFolder(int folderNo);


}
