package com.team3.market.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.team3.market.model.vo.CategoryVO;

@Mapper
public interface CategoryDAO {
    List<CategoryVO> selectCategoryList();

	CategoryVO getCategoryByNum(int category_num);
}