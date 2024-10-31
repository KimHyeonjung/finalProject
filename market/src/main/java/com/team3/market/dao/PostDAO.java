package com.team3.market.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.NotificationVO;
import com.team3.market.model.dto.CombineNotificationWithFileDTO;
import com.team3.market.model.dto.CombinePostWithFileDTO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.ReportCategoryVO;
import com.team3.market.model.vo.WalletVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.pagination.MyPostCriteria;

public interface PostDAO {

	PostVO selectPost(int post_num);

	Map<String, Object> selectPostMap(int post_num);

	void updateView(int post_num);

	boolean deletePost(int post_num);

	List<PostVO> selectPostList();

	List<ReportCategoryVO> selectReportCategory();

	int insertReportPost(@Param("report")ReportVO report, @Param("member_num")int member_num);

	void updatePostReport(int report_post_num);

	List<ReportVO> getReport(int report_post_num);

	ReportVO selectReportPost(@Param("post_num")int post_num, @Param("member_num")int member_num);

	WishVO selectWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	boolean insertWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	boolean deleteWish(@Param("post_num")int post_num, @Param("member_num")int member_num);

	List<PostVO> selectWishPostList(@Param("member_num")int member_num, @Param("sort_type")String sort_type);
	
    boolean insertPost(PostVO post);
    
    List<String> selectCategoryList();
	
    // 파일 정보를 DB에 저장하는 메서드
    boolean insertFile(FileVO file);

	List<PostVO> selectMyPostList(MyPostCriteria cri);

	int selectTotalCountMyPost(MyPostCriteria cri);

	void updatePosition(PostVO post);

	boolean updateRefresh(int post_num);

	boolean updateDelPost(int post_num);

	ChatRoomVO selectChatRoomChk(int post_num);
	WalletVO selectWalletChk(int post_num);
	AfterVO selectAfterChk(int post_num);
	ReportVO selectReportChk(int post_num);

	void deletePostAllWish(int post_num);

	void deleteFile(int file_num);

	List<FileVO> selectFileList(@Param("target_num")int target_num, @Param("target")String target);

	FileVO selectFile(@Param("target_num")int target_num, @Param("target")String target);

	ChatRoomVO selectChatRoom(@Param("member_num")int member_num, @Param("member_num2")int member_num2, @Param("post_num")int post_num);

	boolean insertNotification(@Param("member_num")int member_num, @Param("type")int type, @Param("post_num")int post_num, @Param("propStr")String propStr);

	boolean insertChatRoom(ChatRoomVO chatRoom);

	boolean insertChat(ChatVO chat);
	
	boolean insertAfter(AfterVO after);
	//boolean updateMemberScore(MemberVO member); // 회원 평점을 업데이트하는 메서드

	List<NotificationVO> selectNotification(int member_num);

	boolean updateNotiReadTrue(int notification_num);

	int selectNotReadCount(int member_num);

	MemberVO selectMember(int member_num);

	List<CombineNotificationWithFileDTO> selectNotificationListWithFile(int member_num);

	List<CombinePostWithFileDTO> selectPostListWithFileByCategory(int category_num);

	String selectCategoryName(int category_num);
	
	
    // post_num을 통해 post_member_num을 조회하는 메서드
    int findPostMemberNum(int post_num);

    // member_score를 업데이트하는 메서드
    boolean updateMemberScore(@Param("member_num") int member_num, @Param("after_review_sum") float afterReviewSum);
	
}
