package com.team3.market.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    /*
    @PostMapping("/insert")
    public String insertPost(Model model, PostVO post, HttpSession session, MultipartFile[] fileList) {
    	
    	MemberVO user = (MemberVO)session.getAttribute("user");
    	
    	System.out.println(post);
		
    	boolean res = postService.insertPost(post, user, fileList);

		MessageDTO message;
		
		if(res) {
			message = new MessageDTO("/post/list", "게시글을 등록했습니다.");
		}else {
			message = new MessageDTO("/post/insert", "게시글을 등록하지 못했습니다.");
		}
		
		model.addAttribute("message",message);
		
		return "/main/message";
    }
    */
    
    @PostMapping("/post/insert")
    public String insertPost(MultipartHttpServletRequest request, RedirectAttributes redirectAttributes) {
        // 게시글 관련 데이터 처리
        String postTitle = request.getParameter("post_title");
        String postContent = request.getParameter("post_content");
        String postMeId = request.getParameter("post_me_id");
        int postCoNum = Integer.parseInt(request.getParameter("post_co_num"));
        
        PostDTO postDto = new PostDTO();
        postDto.setPo_title(postTitle);
        postDto.setPo_content(postContent);
        postDto.setPo_me_id(postMeId);
        postDto.setPo_co_num(postCoNum);
        
        // 게시글 저장
        postService.createPost(postDto); // insert 후, po_num을 받음

        // 파일 저장 처리
        List<MultipartFile> files = request.getFiles("fileList");
        if (files != null && !files.isEmpty()) {
            String uploadDir = "D:\\uploads\\";
            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    try {
                        // 파일을 로컬에 저장
                        String filePath = uploadDir + file.getOriginalFilename();
                        File destFile = new File(filePath);
                        file.transferTo(destFile);

                        // 파일 정보 저장
                        FileDTO fileDto = new FileDTO();
                        fileDto.setFi_target_table("post"); // 게시글용 파일
                        fileDto.setFi_target_num(postDto.getPo_num()); // 방금 저장된 post_num
                        fileDto.setFi_name(file.getOriginalFilename());
                        fileDto.setFi_ori_name(file.getOriginalFilename());
                        fileDto.setFi_path(filePath);
                        
                        postService.saveFile(fileDto); // DB에 파일 정보 저장
                    } catch (IOException e) {
                        e.printStackTrace();
                        // 파일 저장 실패 시 처리
                        redirectAttributes.addFlashAttribute("errorMessage", "파일 업로드 중 오류가 발생했습니다.");
                        return "redirect:/post/insert";
                    }
                }
            }
        }

        redirectAttributes.addFlashAttribute("successMessage", "게시글이 성공적으로 등록되었습니다.");
        return "redirect:/post/list";
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
