package kr.or.ddit.employee.library.Plibrary.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Mapper
public interface IplibraryMapper {

	public void PinsertFile(FolderFileVO folderFileVO);

	public void PinsertFolder(FoldersVO foldersVO);

	public List<FoldersVO> selectPfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectPfileList(Map<String, Object> fileParam);

	public List<FoldersVO> getParentFolders(int upperFolder);

	public FoldersVO selectFolder(int folderNo);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

	public FolderFileVO selectFileByFileNo(int fileNo);

	// 폴더의 DEL_YN 업데이트 (삭제)
    public void updateFolderDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);
    
    // 특정 폴더 내의 모든 파일의 DEL_YN 업데이트 (삭제/복원)
    public void updateFilesByFolderNo(@Param("folderNo") int folderNo, @Param("delYn") String delYn);
    
    // 파일의 DEL_YN 업데이트 (삭제/복원)
    public void updateFileDelYn(@Param("fileNo") int fileNo, @Param("delYn") String delYn);
    
    // 폴더의 DEL_YN과 UPPER_FOLDER를 업데이트 (복원)
    public void updateFolderRestore(@Param("folderNo") int folderNo);

	public List<FoldersVO> selectPyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectPyfileList(Map<String, Object> fileParam);

	public Long selectTotalFileSize(String empNo);

	public void permanentlyDeleteFile(int fileNo);

	public void permanentlyDeleteFolder(int folderNo);

	public void deleteFilesByFolderRecursively(int folderNo);

	public void deleteFoldersRecursively(int folderNo);

	public void updateFolderDelYnByFolderNo(int folderNo);

	
	
	//////////////////////
	// 밑에꺼도 추가해줭
	//////////////////////
	public void updateFoldersDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

	public void updateFolderFilesDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);
}
	