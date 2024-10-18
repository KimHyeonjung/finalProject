package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.PostVO;

public interface PostDAO {

	PostVO selectPost(int post_num);

	Map<String, Object> selectPostMap(int post_num);

	void updateView(int post_num);

	boolean deletePost(int post_num);

    boolean insertPost(PostVO post);
    
    List<String> selectCategoryList();
    
    // 파일 정보를 DB에 저장하는 메서드
    boolean insertFile(FileVO file);
}
