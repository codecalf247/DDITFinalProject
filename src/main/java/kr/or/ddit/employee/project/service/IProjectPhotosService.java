package kr.or.ddit.employee.project.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPerticipantVO;
import kr.or.ddit.vo.ProjectPhotosVO;

public interface IProjectPhotosService {

	
	// 사진 페이지 가져오기 
	public List<ProjectPhotosVO> selectPhotoList(int prjctNo);

	// 사진 상세 페이지용
	public ProjectPhotosVO selectPhotoDetail(int photoNo);

	// 사진 등록용
	public ServiceResult insertPhoto(ProjectPhotosVO photoVO, List<MultipartFile> files);

	// 사진 업데이트
	public ServiceResult updatePhoto(ProjectPhotosVO photoVO, List<MultipartFile> newFiles, List<Integer> deleteFileNos);

	public ServiceResult deletePhoto(long sptPhotoNo);

	public ServiceResult deleteFilesImmediately(List<Integer> fileNos);

	
	
	//Paging 처리
	public int selectPhotoCount(PaginationInfoVO<ProjectPhotosVO> pagingVO);								// 페이징을 위한 전체 레코드 수 조회
	public List<ProjectPhotosVO> selectPhotoListWithPaging(PaginationInfoVO<ProjectPhotosVO> pagingVO);		// 페이징이 적용된 목록 조회


	
}
