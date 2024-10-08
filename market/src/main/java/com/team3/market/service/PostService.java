package com.team3.market.service;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.PostVO;

@Service
public class PostService {

	@Autowired
	PostDAO postDao;
	
//	@Resource
//	String uploadPath;
	//게시글 가져오기
	public PostVO getPost(int post_num) {
		return postDao.selectPost(post_num);
	}
	
}
