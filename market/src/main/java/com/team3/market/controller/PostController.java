package com.team3.market.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.team3.market.model.vo.PostVO;
import com.team3.market.service.PostService;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	PostService postService;
	
    @GetMapping("/insert")
    public String insert(Model model) {
        // 카테고리 목록을 가져와서 뷰에 전달
        List<String> categoryList = postService.getCategoryList();
        model.addAttribute("categoryList", categoryList);	
        
        return "/post/insert";
    }
	
    // 게시글 생성 처리
    @PostMapping("/insert")
    public String insertPost(PostVO post) {
        boolean res = postService.insertPost(post); // 서비스 계층에서 게시글 생성 요청
        if (res) {
            return "redirect:/post/list";  // 게시글 리스트 페이지로 리다이렉트
        } else {
            return "redirect:/post/insert";  // 생성 실패 시 다시 작성 폼으로 리다이렉트
        }
    }
	
	@GetMapping("/detail")
	public String detail(Model model) {
		postService.updateView(1);
//		PostVO post = postService.getPost(1);
		Map<String, Object> post = postService.getPostMap(1);
		model.addAttribute("post", post);
		
		return "/post/detail";
	}
	
	@GetMapping("/delete/{post_num}")
	public String delete(@PathVariable("post_num") int post_num) {
		boolean res = postService.deletePost(post_num);
		if(res) {
			return "redirect:/post/list";
		} else {
			return "redirect:/post/detail/"+ post_num;
		}
	}
	
}
