package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BlogMemberVO {
	private int memNo;
	private String memId;
	private String memPw;
	private String memName;
	private String memEmail;
	private String memProfileimg;
	private String memRegdate;
	private String memUpddate;
	private MultipartFile memFile;
	private List<BlogMemberAuthVO> authList;
}
