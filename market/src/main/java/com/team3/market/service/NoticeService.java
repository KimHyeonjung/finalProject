package com.team3.market.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team3.market.dao.NoticeDAO;
import com.team3.market.model.vo.NoticeVO;

@Service
public class NoticeService {
	
	@Autowired
	NoticeDAO noticeDao;

	public List<NoticeVO> getNotice() {
        return noticeDao.selectNotice();
    }
	

    // 공지사항 등록
    public boolean insertNotice(NoticeVO notice) {
    	if (notice == null || notice.getNotice_title() == null || notice.getNotice_title().length() == 0) {
            return false;
        }
    	
    	notice.setNotice_date(new Date());
        boolean res = noticeDao.insertNotice(notice);

        if (!res) {
            return false;
        }

        return true;
    }

    // 공지사항 ID로 조회
    public NoticeVO getNoticeById(Integer notice_num) {
        return noticeDao.selectNoticeById(notice_num);
    }

    // 공지사항 수정
    public boolean updateNotice(NoticeVO notice) {
    	if (notice == null || notice.getNotice_title() == null || notice.getNotice_title().isEmpty()) {
            System.out.println("Notice title is null or empty.");
            return false;
        }
    	
    	notice.setNotice_date(new Date());
    	
    	
    	int rowsAffected = noticeDao.updateNotice(notice);
    	
    	System.out.println("Update Rows Affected: " + rowsAffected);
        
    	return rowsAffected > 0;
    }
    
    public boolean updatePinStatus(int noticeNum, boolean noticePin) {
        NoticeVO notice = new NoticeVO();
        notice.setNotice_num(noticeNum);
        notice.setNotice_pin(noticePin);
        return noticeDao.updatePinStatus(notice) > 0;
    }

    // 공지사항 삭제
    public boolean deleteNotice(Integer notice_num) {
    	 if (notice_num == null) {
             return false;
         }

         boolean res = noticeDao.deleteNotice(notice_num);

         return res;
     }


    public boolean updatePinStatus(NoticeVO notice) {
        // notice가 null이거나, notice_num이 0 이하인 경우 업데이트를 하지 않음
        if (notice == null || notice.getNotice_num() <= 0) {
            System.out.println("Notice ID is invalid.");
            return false;
        }
        
        // 공지사항 고정 상태를 업데이트하고 업데이트된 행 수를 반환받음
        int rowsAffected = noticeDao.updatePinStatus(notice);
        System.out.println("Update Rows Affected: " + rowsAffected);
        
        return rowsAffected > 0;
    }

}
