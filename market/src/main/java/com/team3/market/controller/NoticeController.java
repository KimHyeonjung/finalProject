package com.team3.market.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.team3.market.model.dto.MessageDTO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.NoticeVO;
import com.team3.market.service.NoticeService;


@Controller
@RequestMapping("/notice")
public class NoticeController {

	@Autowired
	NoticeService noticeService;
	
	@GetMapping("/list")
	public String getNoticeList(Model model) {
		List<NoticeVO> allNotices = noticeService.getNotice();
		
		List<NoticeVO> pinnedNotices = new ArrayList<>();
	    List<NoticeVO> regularNotices = new ArrayList<>();
	    
	    for (NoticeVO notice : allNotices) {
	        if (notice.isNotice_pin()) { // 고정된 공지사항인지 확인
	            pinnedNotices.add(notice);
	        } else {
	            regularNotices.add(notice);
	        }
	    }
	    
	    model.addAttribute("pinnedNotices", pinnedNotices);
	    model.addAttribute("regularNotices", regularNotices);
        return "/notice/list";
    }
	@GetMapping("/insert")
	public String insert(HttpSession session, Model model) {
	    MemberVO user = (MemberVO) session.getAttribute("user");
	    
	    // 관리자 권한이 없는 경우 접근 제한
	    if (user == null || !user.isAdmin()) {
			model.addAttribute("message", new MessageDTO("/notice/list", "권한이 없습니다."));
			return "/main/message";
		}
	    
	    return "/notice/insert"; 
	}


	@PostMapping("/insert")
	public String insertNotice(NoticeVO notice, HttpSession session, Model model) {
	    MemberVO user = (MemberVO) session.getAttribute("user");
	    
	    
	    if (user == null || !user.isAdmin()) {
	        model.addAttribute("message", new MessageDTO("/notice/list", "권한이 없습니다."));
	        return "/main/message";
	    }

	    
	    notice.setNotice_member_num(user.getMember_num());

	    if (noticeService.insertNotice(notice)) {
			model.addAttribute("message", new MessageDTO("/notice/list", "공지사항이 등록되었습니다."));
		} else {
			model.addAttribute("message", new MessageDTO("/notice/insert", "공지사항 등록에 실패했습니다."));
		}

	    return "/main/message";
	}

   
    @GetMapping("/detail")
    public String detail(Integer notice_num, Model model) {
        NoticeVO notice = noticeService.getNoticeById(notice_num);
        model.addAttribute("notice", notice);
        return "/notice/detail";
    }


    @GetMapping("/update")
    public String update(Integer notice_num, Model model) {
        NoticeVO notice = noticeService.getNoticeById(notice_num);
        model.addAttribute("notice", notice);
        return "/notice/update";
    }


    @PostMapping("/update")
    public String updateNotice(NoticeVO notice, Model model) {
    	MessageDTO message;
        if (noticeService.updateNotice(notice)) {
            message = new MessageDTO("/notice/detail?notice_num=" + notice.getNotice_num(), "공지사항이 수정되었습니다.");
        } else {
            message = new MessageDTO("/notice/update?notice_num=" + notice.getNotice_num(), "공지사항 수정에 실패했습니다.");
        }
        model.addAttribute("message", message);
        return "/main/message";
    }

    @PostMapping("/delete")
    public String delete(Integer notice_num, Model model) {
    	MessageDTO message;
        if (noticeService.deleteNotice(notice_num)) {
            message = new MessageDTO("/notice/list", "공지사항이 삭제되었습니다.");
        } else {
            message = new MessageDTO("/notice/detail?notice_num=" + notice_num, "공지사항 삭제에 실패했습니다.");
        }
        model.addAttribute("message", message);
        return "/main/message";
    }
    @PostMapping("/pin")
    public String pin(@RequestParam("notice_num") Integer notice_num, 
                      @RequestParam("notice_pin") boolean notice_pin, 
                      HttpSession session, 
                      Model model) {

        MemberVO user = (MemberVO) session.getAttribute("user");

        // 관리자 권한 확인
        if (user == null || !"ADMIN".equals(user.getMember_auth())) {
            model.addAttribute("message", new MessageDTO("/notice/list", "권한이 없습니다."));
            return "/main/message";
        }

        // 고정 상태 업데이트
        NoticeVO notice = new NoticeVO();
        notice.setNotice_num(notice_num);
        notice.setNotice_pin(notice_pin);

        boolean result = noticeService.updatePinStatus(notice);
        System.out.println("Notice ID: " + notice_num);
        System.out.println("Notice Pin Status: " + notice_pin);
        System.out.println("Update Result: " + result);

        if (result) {
            model.addAttribute("message", new MessageDTO("/notice/detail?notice_num=" + notice_num, "공지사항 고정 상태가 변경되었습니다."));
        } else {
            model.addAttribute("message", new MessageDTO("/notice/detail?notice_num=" + notice_num, "공지사항 고정 상태 변경에 실패했습니다."));
        }
        return "/main/message";
    }
}
