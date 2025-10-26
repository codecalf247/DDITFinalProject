package kr.or.ddit.employee.project.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectFileVO;
import kr.or.ddit.vo.ProjectPerticipantVO;

@Mapper
public interface IProjectFileMapper {

	//pagination용
	public int selectFileCount(PaginationInfoVO<ProjectFileVO> pagingVO);
	public List<ProjectFileVO> selectFileAjaxList(PaginationInfoVO<ProjectFileVO> pagingVO);
	
	
	public int checkProjectParticipant(@Param("prjctNo") int prjctNo, @Param("empNo") String empNo);

	public int generateFileGroupNo();

	public int insertProjectFile(ProjectFileVO pFile);

	public void insertFiles(FilesVO fVO);

	public ProjectFileVO selectProjectFileDetail(int prjctFileNo);
	
	// 파일 목록 조회
	public List<ProjectFileVO> selectFileList(Map<String, Object> paramMap);

	
	// 파일 다운로드용 
	public FilesVO selectFileByNo(int fileNo);

	
	// 자료 수정
	public int updateProjectFile(ProjectFileVO pFile);

	public int deleteFileByFileNo(int fileNo);


	public List<ProjectPerticipantVO> selectProjectPrtcptn(int prjctFileNo);

	
	
	public int deleteProjectFile(int fileNo);

}
