package com.team3.market.dao;

import java.util.List;

import com.team3.market.model.vo.CategoryVO;

public interface PostDAO {

	List<CategoryVO> selectCategoryList();

	List<CategoryVO> selectPostList();
}