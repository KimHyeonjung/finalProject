package com.team3.market.service;

import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

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
	@Resource
	String uploadPath;
	
//	@Resource
//	String uploadPath;
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
		if (post == null || user == null) {
			return false;
		}
		boolean res;
		try {
			post.setPost_member_num(user.getMember_num());
			res = postDao.insertPost(post);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		if(!res) {
			return false;
		}

		if(fileList == null || fileList.length == 0) {
			return true;
		}
		
		//첨부파일 추가
		for(MultipartFile file : fileList) {
			UploadFile(file, post.getPost_num());
		}
		
		return false;
	}

	private void UploadFile(MultipartFile file, int post_num) {
		
		if (file == null || file.getOriginalFilename().length() == 0) {
			return;
		}
		
		try {
			String file_ori_name = file.getOriginalFilename();
			//첨부파일을 서버에 업로드 후 경로가 포함된 파일명을 가져옴
			String file_name = 
			UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
			FileVO fileVo = new FileVO(file_name, file_ori_name, post_num);
			postDao.insertFile(fileVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
