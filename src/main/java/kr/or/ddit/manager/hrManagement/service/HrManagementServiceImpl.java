package kr.or.ddit.manager.hrManagement.service;

import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.employee.attendance.mapper.IAttendanceMapper;
import kr.or.ddit.employee.main.mapper.IWidgetMapper;
import kr.or.ddit.login.service.MailService;
import kr.or.ddit.manager.hrManagement.mapper.IHrManagementMapper;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpAuthVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.attendance.YrycSttusVO;
import kr.or.ddit.vo.main.WidgetVO;

@Service
public class HrManagementServiceImpl implements IHrManagementService{

	@Autowired
	private IHrManagementMapper mapper;
	
	@Autowired
	private IWidgetMapper widgetMapper;

	@Autowired
	private IAttendanceMapper attendanceMapper;
	
	@Autowired
	private MailService mail;
	
	@Value("${upload_profile_path}")
	private String uploadPath;
	
	@Autowired
	private PasswordEncoder pe;
	
	@Override
	@Transactional
	public int insert(EmpVO emp) {
		// TODO Auto-generated method stub
		int cnt = mapper.selectEmpNo();
		EmpAuthVO authVO = new EmpAuthVO();
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM"));
		if(cnt > 0) {	// 요번 달 입사자가 있는 상태
			int total = cnt +1;	// 가입자에서 새로 가입하는 사람 +1
			String totalnum = String.format("%03d", total); 	// 사원번호는 년월+total
			emp.setEmpNo(today+totalnum);	// 사원번호에 세팅
			if(emp.getDeptNo() != 11) {	// 인사팀
				switch (emp.getJbgdCd()) {
				case "15002":	// 팀장
					authVO.setAuthNm("ROLE_MEMBER");
					authVO.setEmpNo(emp.getEmpNo());
					emp.setUserFolderUsgqty(20);
					break;
				case "15003":	// 대리
					authVO.setAuthNm("ROLE_MEMBER");
					authVO.setEmpNo(emp.getEmpNo());
					emp.setUserFolderUsgqty(10);
					break;
				case "15004":	// 주임
					authVO.setAuthNm("ROLE_MEMBER");
					authVO.setEmpNo(emp.getEmpNo());
					emp.setUserFolderUsgqty(10);
					break;
				default:	// 사원
					authVO.setAuthNm("ROLE_MEMBER");
					authVO.setEmpNo(emp.getEmpNo());
					emp.setUserFolderUsgqty(10);
					break;
				}	//대표는 가입할일이 없다.
			}else {
				authVO.setAuthNm("ROLE_MEMBER");
				authVO.setEmpNo(emp.getEmpNo());
			}
		}else {
			emp.setEmpNo(today+"001");	// 처음 번호
		}
		
		emp.setWnmpyEmail(emp.getEmpNo()+"@groovier.com");	// 사내번호 하드세팅
		
		/*
		 * 	 파일 업로드 세팅
		 */
		File file = new File(uploadPath);
		if(!file.exists()) {
			file.mkdirs();
		}
		
		String profileImg = null;
		try {
			MultipartFile imgFile = emp.getProfileImage();
			
			if(imgFile != null && !imgFile.getOriginalFilename().equals("")) {
				String fileName = emp.getEmpNo() +  "_" + imgFile.getOriginalFilename();
				profileImg = uploadPath + fileName;
				imgFile.transferTo(new File(profileImg));
				emp.setProfileFilePath("/upload/profile/"+fileName);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		/* -- 파일업로드 끝  - - - - - -*/
		emp.setPassword(pe.encode(emp.getEmpNo())); 
		int result = mapper.insertEmp(emp);
		mapper.insertAuth(authVO);
		if(result > 0) {
			mail.sendJoinMail(emp.getEmail(), emp.getEmpNo(), emp.getEmpNo());  
		}
		
		// ==================== 위젯 삽입 ==========================
        List<WidgetVO> widgetList = new ArrayList<>();
        String empNo = emp.getEmpNo();
        
        widgetList.add(new WidgetVO(1, empNo, 2, 0));
        widgetList.add(new WidgetVO(2, empNo, 0, 0));
        widgetList.add(new WidgetVO(3, empNo, 0, 20));
        widgetList.add(new WidgetVO(4, empNo, 0, 10));
        widgetList.add(new WidgetVO(5, empNo, 4, 24));
        widgetList.add(new WidgetVO(6, empNo, 2, 24));
        
        for(WidgetVO w : widgetList) {
        	widgetMapper.insertWidgets(w);
        }
		
		// ==================== 위젯 삽입 ==========================
        // ==================== 연차 삽입 ==========================

        int year = LocalDate.now().getYear();
        YrycSttusVO yrycVO = new YrycSttusVO();
        yrycVO.setEmpNo(empNo);
        yrycVO.setIssuYr(String.valueOf(year));
        
        attendanceMapper.insertYrycSttus(yrycVO);
        
        // ==================== 연차 삽입 ==========================
		return result;
	}

	@Override
	public List<DeptVO> selectalldept() {
		// TODO Auto-generated method stub
		List<DeptVO> deptList = mapper.selectDeptNm();
		return deptList;
	}

	@Override
	public List<EmpVO> selectAllEmp(PaginationInfoVO<EmpVO> pagingVO) {
		// TODO Auto-generated method stub
		
		return mapper.selectAllEmp(pagingVO);
	}

	@Override
	public int selectEmpCount(PaginationInfoVO<EmpVO> pagingVO) {
		// TODO Auto-generated method stub
		return mapper.selectEmpCount(pagingVO);
	}

	@Override
	public EmpVO selectOne(String empNo) {
		// TODO Auto-generated method stub
		return mapper.selectOne(empNo);
	}

	@Override
	@Transactional
	public int update(EmpVO empvo) {
	    // 0) 기존 데이터 조회 (없으면 0 반환)
	    EmpVO prev = mapper.selectOne(empvo.getEmpNo());
	    if (prev == null) return 0;

	    // 1) 프로필 이미지 교체(있을 때만)
	    try {
	        MultipartFile imgFile = empvo.getProfileImage();
	        if (imgFile != null && !imgFile.isEmpty()
	                && imgFile.getOriginalFilename() != null
	                && !imgFile.getOriginalFilename().isBlank()) {

	            // 저장 디렉토리 보장
	            File dir = new File(uploadPath);
	            if (!dir.exists()) dir.mkdirs();

	            String cleanName = org.springframework.util.StringUtils.cleanPath(imgFile.getOriginalFilename());
	            String fileName  = empvo.getEmpNo() + "_" + cleanName;
	            File saveFile    = java.nio.file.Paths.get(uploadPath, fileName).toFile();

	            imgFile.transferTo(saveFile);

	            // 새 웹 경로 세팅
	            empvo.setProfileFilePath("/upload/profile/" + fileName);

	            // (중요) 이전 파일 삭제는 prev에서 꺼내야 함
	            String oldWebPath = prev.getProfileFilePath();
	            if (oldWebPath != null && !oldWebPath.isBlank()) {
	                String oldName = oldWebPath.substring(oldWebPath.lastIndexOf('/') + 1);
	                File oldFile   = java.nio.file.Paths.get(uploadPath, oldName).toFile();
	                if (oldFile.exists()) oldFile.delete();
	            }
	        } else {
	            // 새 파일 없으면 null로 둬서 동적 SQL에서 컬럼 업데이트 생략
	            empvo.setProfileFilePath(null);
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 파일 실패해도 나머지는 진행
	        // 실패 시에도 컬럼을 건드리지 않도록
	        empvo.setProfileFilePath(null);
	    }

	    // 2) 비밀번호: 전달되면 변경, 아니면 유지(동적 SQL에서 생략)
	    if (empvo.getPassword() != null && !empvo.getPassword().isBlank()) {
	        empvo.setPassword(pe.encode(empvo.getPassword()));
	    } else {
	        empvo.setPassword(null);
	    }

	    // 3) 사내이메일은 보존(수정 안 하기로 했으면 null로 두기 → UPDATE 생략)
	    if (empvo.getWnmpyEmail() == null || empvo.getWnmpyEmail().isBlank()) {
	        empvo.setWnmpyEmail(null);
	    }

	    // 4) 권한 재설정 (인사팀=11이면 제거, 아니면 직급에 따라 1건 부여)
	    mapper.deleteAuthByEmpNo(empvo.getEmpNo());
	    if (empvo.getDeptNo() != 0 && empvo.getDeptNo() != 11) {
	        EmpAuthVO role = new EmpAuthVO();
	        role.setEmpNo(empvo.getEmpNo());
	        switch (empvo.getJbgdCd()) {
	            case "15002": 
	            	role.setAuthNm("ROLE_MEMBER"); 
	            	empvo.setUserFolderUsgqty(20);	// 용량 고정
	            break; // 팀장
	            default:      
		            role.setAuthNm("ROLE_MEMBER");
		            empvo.setUserFolderUsgqty(10);  // 용량 고정
	            break; // 대리/주임/사원
	        }
	        mapper.insertAuth(role);
	    }

	    // 5) 최종 업데이트 (널/빈값은 동적 SQL에서 건너뜀)
	    int updated = mapper.updateEmp(empvo); // ← empvo로 수정
	    return updated;
	}

	@Override
	public int delete(EmpVO empvo) {
		// TODO Auto-generated method stub
		
		
		return mapper.deleteEmp(empvo);
	}

	@Override
	public int reactivate(EmpVO empvo) {
		// TODO Auto-generated method stub
		return mapper.reactivate(empvo);
	}

}
