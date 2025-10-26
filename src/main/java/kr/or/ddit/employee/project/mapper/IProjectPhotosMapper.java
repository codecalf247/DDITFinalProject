package kr.or.ddit.employee.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.FilesVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.ProjectPhotosVO;


@Mapper
public interface IProjectPhotosMapper {

	public List<ProjectPhotosVO> selectPhotoList(int prjctNo);

	public ProjectPhotosVO selectPhotoDetail(int photoNo);

	
	
	public int insertPhoto(ProjectPhotosVO photoVO);

	public int generateFileGroupNo();

	public void insertFiles(FilesVO fVO);

	
	
	// 기본 정보 업데이트 (제목 + 베지) 
	public int updatePhotoBasic(ProjectPhotosVO photoVO);
	// 파일 실제 경로 찾기 
	public List<FilesVO> selectFilesByNos(List<Integer> deleteFileNos);
	// 파일 삭제하기
	public void deleteFilesByNos(List<Integer> deleteFileNos);

	
	// sptPhotoNo로 파일번호 목록(DEL_YN='N') 조회
	public List<Integer> selectFileNosBySptPhotoNo(int photoNo);
	// 사진 묶음(SPT_PHOTO) 삭제
	public int deletePhoto(int photoNo);

	
	// paging 
	public int selectPhotoCount(PaginationInfoVO<ProjectPhotosVO> pagingVO);
	public List<ProjectPhotosVO> selectPhotoListWithPaging(PaginationInfoVO<ProjectPhotosVO> pagingVO);

	

	
}
