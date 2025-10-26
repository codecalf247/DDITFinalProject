package kr.or.ddit.vo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BlogVO {
	private int blogNo;
	private String blogTitle;
	private String blogContent;
	private String blogWriter;
	private String blogDate;
	private int blogHit;
	
	private String memProfileimg;
	private int fileCnt;
	
	private MultipartFile[] blogFile;
	private List<BlogFileVO> blogFileList;
	
	public void setBlogFile(MultipartFile[] blogFile) {
		this.blogFile = blogFile;
		
		if(blogFile != null) {
			List<BlogFileVO> blogFileList = new ArrayList<>();
			for(MultipartFile item : blogFile) {
				if(StringUtils.isBlank(item.getOriginalFilename())) {
					continue;
				}
				
				BlogFileVO blogFileVO = new BlogFileVO(item);
				blogFileList.add(blogFileVO);
			}
			this.blogFileList = blogFileList;
		}
	}
	
}







