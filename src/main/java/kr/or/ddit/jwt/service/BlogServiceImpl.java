package kr.or.ddit.jwt.service;

import java.io.File;
import java.io.IOException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.jwt.mapper.IBlogMapper;
import kr.or.ddit.util.TokenProvider;
import kr.or.ddit.vo.BlogFileVO;
import kr.or.ddit.vo.BlogMemberVO;
import kr.or.ddit.vo.BlogVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class BlogServiceImpl implements IBlogService {

	@Autowired
	private IBlogMapper blogMapper;
	
	@Autowired
	private PasswordEncoder pe;
	
	@Autowired
	private TokenProvider tokenProvider;
	
	@Value("${upload_profile_path}")
	private String UPLOAD_PROFILE_PATH;
	@Value("${upload_blog_path}")
	private String UPLOAD_BLOG_PATH;
	
	@Override
	public ServiceResult idCheck(String memId) {
		ServiceResult result = null;
		
		BlogMemberVO memberVO = blogMapper.idCheck(memId);
		if(memberVO != null) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}

	@Override
	public ServiceResult signup(BlogMemberVO memberVO) {
		ServiceResult result = null;
		
		// 프로필 이미지 처리
		// 회원가입 시, 프로필 이미지로 파일을 업로드 하는데 이때 업로드 할 서버 경로
		File file = new File(UPLOAD_PROFILE_PATH);
		if(!file.exists()) {
			file.mkdirs();
		}
		
		String uploadPath = "";
		String profileImg = "";	// 회원정보에 추가될 프로필 이미지 경로
		try {
			// 넘겨받은 회원정보에서 파일 데이터 가져오기
			MultipartFile profileImgFile = memberVO.getMemFile();
			
			if(profileImgFile != null && profileImgFile.getOriginalFilename() != null &&
					!profileImgFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString();
				// UUID_원본파일명
				fileName += "_" + profileImgFile.getOriginalFilename();
				uploadPath = UPLOAD_PROFILE_PATH + "/" + fileName;
				profileImgFile.transferTo(new File(uploadPath));	// 파일 복사
				profileImg = "/upload/blog/profile/" + fileName;	// 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI
			}
			
			memberVO.setMemProfileimg(profileImg);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		// 시큐리티 암호화 설정
		String password = memberVO.getMemPw();
		password = pe.encode(password);
		memberVO.setMemPw(password);
		
		int status = blogMapper.signup(memberVO);
		if(status > 0) {
			// 회원 권한 등록
			blogMapper.addMemberAuth(memberVO.getMemNo());
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public String signin(BlogMemberVO memberVO) {
		String token = null;
		
		BlogMemberVO member = blogMapper.signin(memberVO);
		
		// 로그인을 진행할 때, 넘겨준 아이디 비밀번호 중 아이디로 회원 정보를 조회 후 일치하는 회원정보를 가져옵니다.
		// 이때, 아이디로만 회원정보를 조회해서 가져오는 이유는 암호화된 비밀번호를 평문으로 입력한 비밀번호와 비교할 수 있는 프로세스를
		// 시큐리티가 제공해주는데 우리는 해당 프로세스를 직접 핸들링 할 수 없기 때문에 아이디와 일치하는 회원정보를 먼저 가져와서
		// 아래 조건처럼 전달한 비밀번호의 평문과 암호화된 비밀번호가 저장된 데이터를 비교할 수 있도록 PasswordEncoder 객체의 matches()
		// 메소드를 활용합니다.
		// 회원정보가 null이 아니고, 입력한 비밀번호의 평문과 암호화된 비밀번호를 비교했을 때 일치하다면 정말로 일치하는 회원정보니까 인증 성공으로
		// 보고 토큰을 발행해서 응답으로 전달할 준비를 합니다.
		if(member != null && pe.matches(memberVO.getMemPw(), member.getMemPw())) {
			// JWT 토큰 생성 시, 유효시간을 현재 시간 + 30분으로 설정
			token = tokenProvider.generateToken(member, Duration.ofMinutes(30));
		}
		
		return token;
	}

	@Override
	public ServiceResult insert(BlogVO blogVO) {
		ServiceResult result = null;
		
		int status = blogMapper.insert(blogVO);
		if(status > 0) {
			try {
				blogFileUpload(blogVO.getBlogFileList(), blogVO.getBlogNo());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	private void blogFileUpload(List<BlogFileVO> blogFileList, int blogNo) throws Exception {
		if(blogFileList != null && blogFileList.size() > 0) {
			for(BlogFileVO blogFileVO : blogFileList) {
				String saveName = UUID.randomUUID().toString();
				saveName += "_" + blogFileVO.getFileName().replaceAll(" ", "_");
				String saveLocate = UPLOAD_BLOG_PATH + "/" + blogNo;
				File file = new File(saveLocate);
				if(!file.exists()) {
					file.mkdirs();
				}
				saveLocate += "/" + saveName;
				
				blogFileVO.setBlogNo(blogNo);
				blogFileVO.setFileSavepath(saveLocate);
				blogMapper.insertBlogFile(blogFileVO);
				
				File saveFile = new File(saveLocate);
				blogFileVO.getItem().transferTo(saveFile);
			}
		}
	}

	@Override
	public int selectBlogCount(PaginationInfoVO<BlogVO> pagingVO) {
		return blogMapper.selectBlogCount(pagingVO);
	}

	@Override
	public List<BlogVO> selectBlogList(PaginationInfoVO<BlogVO> pagingVO) {
		List<BlogVO> resultList = new ArrayList<>();
		
		List<BlogVO> blogList = blogMapper.selectBlogList(pagingVO);
		if(blogList != null && blogList.size() > 0) {
			int startRow = pagingVO.getStartRow();
			int endRow = pagingVO.getEndRow();
			for(int i = 0; i < blogList.size(); i++) {
				if((i+1) >= startRow && (i+1) <= endRow) {
					resultList.add(blogList.get(i));
				}
			}
		}
		
		return resultList;
	}

	@Override
	public BlogVO detail(int blogNo) {
		// TODO Auto-generated method stub
		blogMapper.incrementHit(blogNo);
		return blogMapper.detail(blogNo);
	}

	@Override
	public BlogFileVO getFileInfo(int fileNo) {
		// TODO Auto-generated method stub
		return blogMapper.getFileInfo(fileNo);
	}

}
















