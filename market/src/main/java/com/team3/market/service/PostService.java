package com.team3.market.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;

@Service
public class PostService {

	@Autowired
	PostDAO postDao;
	
    @Autowired
    private String uploadPath; // WebMvcConfig에서 설정된 경로 주입
	
	//게시글 가져오기
	public PostVO getPost(int post_num) {
		return postDao.selectPost(post_num);
	}

	public Map<String, Object> getPostMap(int post_num) {
		Map<String, Object> post = postDao.selectPostMap(post_num);
		//지난 시간 구해서 map에 추가
		Date writeTime = (Date) post.get("post_date");
		Date nowTime = new Date();
		long beforeTimeMs = nowTime.getTime() - writeTime.getTime();		 
		long beforeTime = beforeTimeMs / 1000 / 60 / 60 ;	
		post.put("beforeTime", beforeTime);
		 
		return post;
	}

	public void updateView(int post_num) {
		postDao.updateView(post_num);
		
	}

	public boolean deletePost(int post_num) {
		return postDao.deletePost(post_num);
	}

	public boolean insertPost(PostVO post, MemberVO user, MultipartFile[] fileList) {
		
		if(post == null || user == null) {
			return false;
		}
		if(post.getPost_title().length() == 0) {
			return false;
		}
		
		post.setPost_member_num(user.getMember_num());
		
		
		boolean res = postDao.insertPost(post);
		
		if(!res) {
			return false;
		}
		
		if(fileList == null || fileList.length == 0) {
			return false;
		}
		
		//FileVO file = new FileVO("UUID_파일명", "원래파일명", "post", post.getPost_num());
		//FileVO file = new FileVO(file_ori_name, file.file_name, "post", post.getPost_num());
		
        for (MultipartFile file : fileList) {
            if (!file.isEmpty()) {
                try {
                    // 원본 파일명 가져오기
                    String originalFileName = file.getOriginalFilename();

                    // 파일명을 UUID로 변환하여 고유하게 설정
                    String uuidFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                    // 저장할 파일 객체 생성
                    File saveFile = new File(uploadPath, uuidFileName);
                    
                    // 파일을 저장하는 부분
                    file.transferTo(saveFile);

                    // FileVO 객체 생성 및 데이터 설정
                    FileVO fileVO = new FileVO(uuidFileName, originalFileName, "post", post.getPost_num());

                } catch (IOException e) {
                    e.printStackTrace();
                    return false;
                }
            }
        }
		
		
		
		return true;
	}
    
    // 카테고리 목록을 가져오는 메서드 추가
    public List<String> getCategoryList() {
        return postDao.selectCategoryList();
    }

	public List<PostVO> getPostList() {
		// TODO Auto-generated method stub
		return null;
	}

}
