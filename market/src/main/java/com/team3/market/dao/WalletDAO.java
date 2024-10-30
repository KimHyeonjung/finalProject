package com.team3.market.dao;

import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PointVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface WalletDAO {
    // 결제 정보를 저장하는 메서드
    void insertPoint(PointVO pointVO);

    MemberVO selectMemberById(int member_num);
    
	void updatePoint(MemberVO memberVO);

	List<PointVO> selectPointHistory(int member_num);

}
