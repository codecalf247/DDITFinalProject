package kr.or.ddit.file.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.vo.FilesVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class FileServiceImpl implements IFileService {
	
	@Autowired
	private IFileMapper fileMapper;
	
	@Override
	public int createFileGroupNo() {
		return fileMapper.createFileGroupNo();
	}

	@Override
	public int insertFile(FilesVO file) {
		return fileMapper.insertFile(file);
	}

	@Override
	public FilesVO selectFileBySavedNm(String savedNm) {
		return fileMapper.selectFileBySavedNm(savedNm);
	}

}
