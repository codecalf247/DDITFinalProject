package kr.or.ddit.employee.facilities.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.employee.facilities.service.IMeetService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/meeting")
public class MeetingRoomController {

    @Autowired
    private IMeetService meetService;

    /** 실제 저장 경로 (properties 없으면 기본값 사용) */
    @Value("${app.upload-dir:D:/upload/mtg/}")
    private String uploadDir;

    @GetMapping("/roomlist")
    public String roomlist() {
        log.info("회의실 페이지실행....!");
        return "facilities/roomlist";
    }

  

    @GetMapping("/reserve")
    public String reserve() {
        log.info("회의실 예약 페이지실행....!");
        return "facilities/reserve";
    }
}
