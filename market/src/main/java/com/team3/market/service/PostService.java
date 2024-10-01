package com.team3.market.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.CategoryVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PostService {
	
	private PostDAO postDao;

	public List<CategoryVO> getCategoryList() {
		return postDao.selectCategoryList();
	}

	public List<CategoryVO> getPostList() {
		return postDao.selectPostList();
	}
}