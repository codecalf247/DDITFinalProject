package kr.or.ddit.employee.project.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectFileVO;
import kr.or.ddit.vo.ProjectPerticipantVO;

public interface IProjectFilesService {
	
	// pagination record count용
	public int selectFileCount(PaginationInfoVO<ProjectFileVO> pagingVO);
	// ajax 탭별 자료 목록 조회
	public List<ProjectFileVO> selectFileAjaxList(PaginationInfoVO<ProjectFileVO> pagingVO);
	
	// 프로젝트 참여자인지 판단
	public int checkProjectParticipant(int prjctNo, String empNo);

	
	// 프로젝트 자료 INSERT
	public int insertProjectFiles(ProjectFileVO pFile, List<MultipartFile> uploadFiles, String empNo);

	// 프로젝트 자료 상세
	public ProjectFileVO selectProjectFileDetail(int prjctFileNo);

	// 카테고리별 파일 목록 조회
	public List<ProjectFileVO> selectFileList(int prjctNo, String fileTy);

	// 다운로드를 위해 파일 번호 조회
	public FilesVO selectFileByNo(int fileNo);

	// 업데이트 처리
	public ServiceResult updateProjectFiles(ProjectFileVO pFile, List<MultipartFile> uploadFiles, List<Integer> deleteFileNoList);
	// 업데이트 시 첨부파일 AJAX 삭제 
	public ServiceResult deleteFileByFileNo(int fileNo);


	public List<ProjectPerticipantVO> selectProjectPrtcptn(int prjctFileNo);


	public ServiceResult deleteProjectFile(int fileNo);


	

	
}
