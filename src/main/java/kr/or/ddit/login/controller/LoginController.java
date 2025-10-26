package kr.or.ddit.login.controller;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.notification.NotificationConfig;
import kr.or.ddit.employee.boards.notice.controller.MediaUtils;
import kr.or.ddit.login.service.IEmpLoginService;
import kr.or.ddit.login.service.MailService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {

	@Autowired
	private IEmpLoginService service;
	
	@Autowired
	private MailService mail;
	
	@Autowired
	private NotificationConfig noti;
	
	@Value("${upload_profile_path}")
	private String uploadPath;
	
	@GetMapping({"/","/login"})
	public String login(
			@RequestParam(value="msg", required=false) String msg ,Model model,RedirectAttributes ra) throws Exception {
//		Map<String, String> weatherMap =  new HashMap<>();
//		try {
//			weatherMap = xmlParse();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		if(weatherMap != null) {
//			model.addAttribute("SKY", weatherMap.get("SKY"));
//			model.addAttribute("PTY", weatherMap.get("PTY"));
//			model.addAttribute("T1H", weatherMap.get("T1H"));
//		}
		ra.addFlashAttribute("msg", msg);
		return "login";
	}
	
	@PostMapping("/api/findId")
	@ResponseBody
	public ResponseEntity<String> findId(
			@RequestBody EmpVO empVO
			){
		log.info(empVO.toString());
		String empNo = service.findId(empVO);
		
		return new ResponseEntity<String>(empNo,HttpStatus.OK);
	}
	
	@PostMapping("/api/changePw")
	@ResponseBody
	public ResponseEntity<ServiceResult> changePw(
			@RequestBody EmpVO empVO
			){
		ServiceResult result = null;
		String password = service.changePw(empVO);
		if(password != null && !password.isEmpty()) {
			//emailSend(password,empVO.getEmail().toString());
			mail.sendSimpleMail(empVO.getEmail(), password);
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}	

	private String weatherApi() throws Exception {
		
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		LocalDateTime now = LocalDateTime.now().minusMinutes(45);
        // base_time 구하기 (30분 단위로 맞춤)
        int hour = now.getHour();
        int minute = now.getMinute();

        // 분에 따라 조정 (00 또는 30)
        String baseTime = (minute < 30) 
                ? String.format("%02d00", hour) 
                : String.format("%02d30", hour);
		System.out.println(baseTime + " 현재 시간 분 없앤거");
        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=2fcdd9c63fc6e957bede9f15fdca49a274415d9e2f3ddbbc5d5c3d1db6e610ae"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("XML", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(today, "UTF-8")); /*‘21년 6월 28일발표*/
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(baseTime, "UTF-8")); /*05시 발표*/
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode("68", "UTF-8")); /*예보지점의 X 좌표값*/
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode("100", "UTF-8")); /*예보지점의 Y 좌표값*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
//        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
//        System.out.println(sb);
		
		return sb.toString();
	}


	private Map<String, String> xmlParse() throws Exception{
		// TODO Auto-generated method stub
		Map<String, String> weatherMap = new HashMap<>();
		String xml =  weatherApi();
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document document = builder.parse(new InputSource(new StringReader(xml)));
		String baseTime = LocalDateTime.now().plusHours(1).format(DateTimeFormatter.ofPattern("HH00"));
		log.info(baseTime);
		NodeList items = document.getElementsByTagName("item");
		System.out.println("item 개수: " + items.getLength());

		for (int i = 0; i < items.getLength(); i++) {
		    Node itemNode = items.item(i);
		    if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
		        Element element = (Element) itemNode;
		        if(element.getElementsByTagName("fcstTime").item(0).getTextContent().equals(baseTime)) {
			        String category = element.getElementsByTagName("category").item(0).getTextContent();
			        String value = element.getElementsByTagName("fcstValue").item(0).getTextContent();
//			        System.out.println(category + " = " + value);
			        weatherMap.put(category, value);
		        }
		    }
		}
		log.info(weatherMap.toString());
		return weatherMap;
	}
	
	@GetMapping("/upload/profile/{profileNm}")
	public ResponseEntity<byte[]> profileImg(@PathVariable String profileNm){
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		log.info("profileNm : " + profileNm);
		try {
			String formatName = profileNm.substring(profileNm.lastIndexOf(".")+1);
			log.info("formatName" + formatName);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(uploadPath + "/" + profileNm);
			
			if(mType != null) {  // 이미지 파일
				headers.setContentType(mType);
			}else {              // 일반적인 파일
				profileNm = profileNm.substring(profileNm.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				// 다운로드 처리 시 사용
				headers.add("Content-Disposition", "attachment;filename=\"" + 
				new String(profileNm.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			}
			entity  = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		}catch(Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			if(in != null) {
				try {
					in.close();
				}catch(IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		return entity;
	}
	@GetMapping("/accessError")
	public String accessError() {
		return "errorPage";
	}
}
