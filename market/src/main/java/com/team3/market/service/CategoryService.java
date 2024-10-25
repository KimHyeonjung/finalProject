package com.team3.market.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.CategoryDAO;
import com.team3.market.model.vo.CategoryVO;

@Service
public class CategoryService {

    @Autowired
    CategoryDAO categoryDao;

    
    public List<CategoryVO> getCategoryList() {
        return categoryDao.selectCategoryList();
    }


	public CategoryVO getCategoryByNum(int category_num) {
		
		return categoryDao.getCategoryByNum(category_num);
	}
}