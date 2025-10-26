package kr.or.ddit.jwt.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main")
public class MainController {

	@GetMapping("index")
	public String index() {
		return "main/index";
	}
	@GetMapping("attd")
	public String attd() {
		return "main/attendence";
	}
	
	@GetMapping("login.do")
	public String login() {
		return "main/login";
	}

}
