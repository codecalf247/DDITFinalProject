package kr.or.ddit.employee.boards.freeBoard.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.boards.freeBoard.service.IFreeBoardService;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.CustomUser;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/boards")
public class FreeBoardCommentContoller {
	
	@Autowired
	private IFreeBoardService freeboardService;
	
	@ResponseBody
	@PostMapping("/insertCmt")
	public ResponseEntity<String> freeboardInsertComment(
			@RequestBody BoardCMVO boardCMVO,
			@AuthenticationPrincipal CustomUser user) {
		log.info("댓글 등록 요청: {}", boardCMVO);
		
		String empNo = user.getUsername();
		boardCMVO.setEmpNo(empNo);
		
		ServiceResult result = freeboardService.insertComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/selectCommentList")
	public ResponseEntity<List<BoardCMVO>> freeboardCommentList (
			@RequestBody Map<String, Integer> param
			){
		log.info("댓글 목록 요청: 게시글 번호 {}", param.get("boardNo"));
		List<BoardCMVO> commentList = freeboardService.selectCommentList(param.get("boardNo"));
		return new ResponseEntity<List<BoardCMVO>>(commentList, HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/insertSubCmt")
	public ResponseEntity<String> freeboardInsertSubComment(
			@RequestBody BoardCMVO boardCMVO,
			@AuthenticationPrincipal CustomUser user
			){
		user.getMember().getEmpNo();
		boardCMVO.setEmpNo(user.getMember().getEmpNo());
		ServiceResult result = freeboardService.insertSubComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/updateCmt")
	public ResponseEntity<String> freeboardUpdateComment(
			@RequestBody BoardCMVO boardCMVO
			){
		log.info("댓글 수정 요청: {}", boardCMVO);

		ServiceResult result = freeboardService.updateComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/updateSubCmt")
	public ResponseEntity<String> freeboardUpdateSubComment(
			@RequestBody BoardCMVO boardCMVO
			){
		ServiceResult result = freeboardService.updateSubComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	
	@ResponseBody
	@PostMapping("/deleteCmt")
	public ResponseEntity<String> freeboardDeleteComment(
			@RequestBody Map<String, Integer> param) {
		log.info("댓글 삭제 요청: 댓글 번호 {}", param.get("cmNo"));
			
		ServiceResult result = freeboardService.deleteComment(param.get("cmNo"));
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
}
