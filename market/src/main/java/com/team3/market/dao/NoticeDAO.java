package com.team3.market.dao;


import java.util.List;

import com.team3.market.model.vo.NoticeVO;

public interface NoticeDAO {

	List<NoticeVO> selectNotice();

	boolean insertNotice(NoticeVO notice);

	NoticeVO selectNoticeById(Integer notice_num);

	int updateNotice(NoticeVO notice);

	boolean deleteNotice(Integer notice_num);

	int updatePinStatus(NoticeVO notice);


}
