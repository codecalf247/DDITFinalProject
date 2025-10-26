package kr.or.ddit.file.service;

import kr.or.ddit.vo.FilesVO;

public interface IFileService {
	
	// 파일 그룹 번호를 생성하는 메서드
	public int createFileGroupNo();
	
	// 파일을 삽입하는 메서드
	public int insertFile(FilesVO file);
	
	// 저장된 파일명으로 파일 정보를 가져오는 메서드
	public FilesVO selectFileBySavedNm(String savedNm);
}
