package com.team3.market.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.utils.UploadFileUtils;

@Service
public class PostService {

	@Autowired
	PostDAO postDao;
	
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
