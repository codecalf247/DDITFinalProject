package kr.or.ddit.employee.library.Tlibrary.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Mapper
public interface ItlibraryMapper {

	public List<FoldersVO> selectTfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectTfileList(Map<String, Object> fileParam);

	public FoldersVO selectFolder(int upperFolder);

	public void TinsertFile(FolderFileVO folderFileVO);

	public void TinsertFolder(FoldersVO foldersVO);

	public FolderFileVO selectFileByFileNo(int fileNo);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

    public void updateFolderDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

    public void updateFilesByFolderNo(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

    public void updateFileDelYn(@Param("fileNo") int fileNo, @Param("delYn") String delYn);

    public void updateFolderRestore(@Param("folderNo") int folderNo);

	public void tpermanentlyDeleteFile(int fileNo);
	
	public void tpermanentlyDeleteFolder(int folderNo);

	public void deleteFilesByFolderRecursively(int folderNo);

	public void deleteFoldersRecursively(int folderNo);

	public Long selectTotalFileSize(Integer deptNo);

	public List<FoldersVO> selectTyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectTyfileList(Map<String, Object> fileParam);

	public void updateFolderDelYnByFolderNo(int folderNo);

	public void updateFoldersDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

	public void updateFolderFilesDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

}
