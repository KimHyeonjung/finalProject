package com.team3.market.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.team3.market.model.vo.CategoryVO;
import com.team3.market.service.CategoryService;

@Controller
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/category")
    public String showCategory(Model model) {
        // 카테고리 리스트를 가져와서 모델에 추가
        List<CategoryVO> categoryList = categoryService.getCategoryList();
        System.out.println("카테고리 데이터: " + categoryList);
        model.addAttribute("categoryList", categoryList); // JSP에서 사용할 데이터
        return "header"; // JSP 파일 이름
    }
}
