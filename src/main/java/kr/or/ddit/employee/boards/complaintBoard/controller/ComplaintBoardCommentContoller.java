package kr.or.ddit.employee.boards.complaintBoard.controller;

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

import kr.or.ddit.ServiceResult;
import kr.or.ddit.employee.boards.complaintBoard.service.IComplaintBoardService;
import kr.or.ddit.vo.BoardCMVO;
import kr.or.ddit.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/boards")
public class ComplaintBoardCommentContoller {
	
	@Autowired
	private IComplaintBoardService complaintService;
	
	@ResponseBody
	@PostMapping("/complaint/insertCmt")
	public ResponseEntity<String> complaintInsertComment(
			@RequestBody BoardCMVO boardCMVO,
			@AuthenticationPrincipal CustomUser user) {
		log.info("댓글 등록 요청: {}", boardCMVO);
		
		String empNo = user.getUsername();
		boardCMVO.setEmpNo(empNo);
		
		ServiceResult result = complaintService.insertComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/complaint/selectCommentList")
	public ResponseEntity<List<BoardCMVO>> complaintCommentList (
			@RequestBody Map<String, Integer> param
			){
		log.info("댓글 목록 요청: 게시글 번호 {}", param.get("boardNo"));
		List<BoardCMVO> commentList = complaintService.selectCommentList(param.get("boardNo"));
		return new ResponseEntity<List<BoardCMVO>>(commentList, HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/complaint/insertSubCmt")
	public ResponseEntity<String> complaintInsertSubComment(
			@RequestBody BoardCMVO boardCMVO,
			@AuthenticationPrincipal CustomUser user
			){
		user.getMember().getEmpNo();
		boardCMVO.setEmpNo(user.getMember().getEmpNo());
		ServiceResult result = complaintService.insertSubComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/complaint/updateCmt")
	public ResponseEntity<String> complaintboardUpdateComment(
			@RequestBody BoardCMVO boardCMVO
			){
		log.info("댓글 수정 요청: {}", boardCMVO);

		ServiceResult result = complaintService.updateComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/complaint/updateSubCmt")
	public ResponseEntity<String> complaintUpdateSubComment(
			@RequestBody BoardCMVO boardCMVO
			){
		ServiceResult result = complaintService.updateSubComment(boardCMVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	
	@ResponseBody
	@PostMapping("/complaint/deleteCmt")
	public ResponseEntity<String> complaintDeleteComment(
			@RequestBody Map<String, Integer> param) {
		log.info("댓글 삭제 요청: 댓글 번호 {}", param.get("cmNo"));
			
		ServiceResult result = complaintService.deleteComment(param.get("cmNo"));
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
}
