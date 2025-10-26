package kr.or.ddit.employee.library.Alibrary.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FoldersVO;

@Mapper
public interface IalibraryMapper {

	public Long selectTotalFileSize(Integer deptNo);

	public List<FoldersVO> selectAfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectAfileList(Map<String, Object> fileParam);

	public FoldersVO selectFolder(int upperFolder);

	public void AinsertFile(FolderFileVO folderFileVO);

	public void AinsertFolder(FoldersVO foldersVO);

	public FolderFileVO selectFileByFileNo(int fileNo);

	public void updateFileFolder(Map<String, Object> param);

	public void updateFolderParent(Map<String, Object> param);

	public List<FoldersVO> selectAyfolderList(Map<String, Object> folderParam);

	public List<FolderFileVO> selectAyfileList(Map<String, Object> fileParam);

	public void updateFolderDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

	public void updateFileDelYn(@Param("fileNo") int fileNo, @Param("delYn") String delYn);

	public void updateFilesByFolderNo(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

	public void updateFolderRestore(@Param("folderNo") int folderNo);

	public void apermanentlyDeleteFile(int fileNo);

	public void deleteFilesByFolderRecursively(int folderNo);

	public void deleteFoldersRecursively(int folderNo);

	public void updateFolderDelYnByFolderNo(int folderNo);

	public void updateFoldersDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

	public void updateFolderFilesDelYn(@Param("folderNo") int folderNo, @Param("delYn") String delYn);

}
