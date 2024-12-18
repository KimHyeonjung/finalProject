package com.team3.market.service;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.MemberDAO;
import com.team3.market.dao.PostDAO;
import com.team3.market.handler.NotificationWebSocketHandler;
import com.team3.market.model.dto.CombineNotificationWithFileDTO;
import com.team3.market.model.dto.CombinePostWithFileDTO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.NotificationVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportCategoryVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.WalletVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.pagination.MyPostCriteria;
import com.team3.market.pagination.PageMaker;
import com.team3.market.utils.UploadFileUtils;

@Service
public class PostService {

	@Autowired
	PostDAO postDao;
	@Autowired
    private NotificationWebSocketHandler notificationHandler;
	
    @Autowired
    private MemberDAO memberDao;
	
    @Autowired
    private String uploadPath; // WebMvcConfig에서 설정된 경로 주입
	
	//게시글 가져오기
	public PostVO getPost(int post_num) {
		return postDao.selectPost(post_num);
	}
	
    // 카테고리 목록을 가져오는 메서드 추가
    public List<String> getCategoryList() {
        return postDao.selectCategoryList();
    }
	
	public int insertPost(PostVO post, MemberVO user, MultipartFile[] fileList) {
		
		if(post == null || user == null) {
			return 0;
		}
		if(post.getPost_title().length() == 0) {
			return 0;
		}
		
		post.setPost_member_num(user.getMember_num());
		
		
		boolean res = postDao.insertPost(post);
		
		if(!res) {
			return 0;
		}
		
		if(fileList == null || fileList.length == 0) {
			return 0;
		}
		
        for (MultipartFile file : fileList) {
        	res = uploadsFile(file, "post", post.getPost_num());
			if(!res) {
				System.out.println("파일 업로드 실패!");
			}
        }
		return post.getPost_num();
	}
	public boolean updatePost(PostVO post, MemberVO user, MultipartFile[] files, int[] existingFileNums) {
		if(post == null || user == null) {
			return false;
		}
		if(post.getPost_title().length() == 0) {
			return false;
		}
		if(!checkWriter(post.getPost_num(), user.getMember_num())) {
			return false;
		}
		boolean res = false;
		PostVO beforePost = postDao.selectPost(post.getPost_num()); //금액 비교를 위해 기존 게시물 정보 가져옴
		DecimalFormat price = new DecimalFormat("###,###");
		int type = 0; // 알림 타입
		int post_num = post.getPost_num();
		int beforePrice = beforePost.getPost_price();
		int newPrice = post.getPost_price();
		String message;
		List<WishVO> wishList = postDao.selectWishMemberListByPostNum(post.getPost_num());
		if(post.getPost_price() < beforePost.getPost_price()) {
			type = 2;
			message = "<div>" + beforePost.getPost_title() + "(" + user.getMember_nick() 
			+ ")상품 가격 하락.</div>("+ price.format(beforePrice) + "원 >> " + price.format(newPrice) + "원)";
			for(WishVO wish : wishList) {
				postDao.insertNotification(wish.getWish_member_num(), type, post_num, message);
				try {
					notificationHandler.sendNotificationToUser(wish.getMember_id(), "notification");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		if(post.getPost_price() > beforePost.getPost_price()) {
			type = 3;
			message = "<div>" + beforePost.getPost_title() + "(" + user.getMember_nick() 
			+ ")상품 가격 상승.</div>("+ price.format(beforePrice) + "원 >> " + price.format(newPrice) + "원)";
			for(WishVO wish : wishList) {
				postDao.insertNotification(wish.getWish_member_num(), type, post_num, message);
				try {
					notificationHandler.sendNotificationToUser(wish.getMember_id(), "notification");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
    	try {
    		res = postDao.updatePost(post);
		} catch (Exception e) {
			e.printStackTrace();
			res = false;
		}
    	if(!res) {
    		return false;
    	}
    	if(existingFileNums != null) {
    		for(int file_num : existingFileNums) {
    			res = deleteFile(file_num);
    			if(!res) {
    				System.out.println("파일 삭제 실패!");
    			}
    		}
    	}
    	if(files != null) {
    		for (MultipartFile file : files) {
    			res = uploadsFile(file, "post", post.getPost_num());
    			if(!res) {
    				System.out.println("파일 업로드 실패!");
    			}
    		}
    	}
    	return res;	    
	}
	public boolean uploadsFile(MultipartFile file, String target, int target_num) {
		if (!file.isEmpty()) {
			try {
				// 원본 파일명 가져오기
				String originalFileName = file.getOriginalFilename();
				// 파일명을 UUID로 변환하여 고유하게 설정
				String uuidFileName = File.separator + UUID.randomUUID().toString() + "_" + originalFileName;
				String file_name = uuidFileName.replace(File.separatorChar, '/');
				// 저장할 파일 객체 생성
				File saveFile = new File(uploadPath, uuidFileName);
				// 파일을 저장하는 부분
				file.transferTo(saveFile);
				// FileVO 객체 생성 및 데이터 설정
				FileVO fileVo = new FileVO(file_name, originalFileName, target, target_num);
				// 파일 정보를 DB에 저장
				postDao.insertFile(fileVo);
				return true;
			} catch (IOException e) {
				e.printStackTrace();
				return false;
			}
		}
		return false;
	}
	
	public Map<String, Object> getPostMap(int post_num) {
		Map<String, Object> post = postDao.selectPostMap(post_num);
		//지난 시간 구해서 map에 추가
		Date updateTime = (Date) post.get("post_refresh");
		Date nowTime = new Date();
		long TimeMs = nowTime.getTime() - updateTime.getTime();		 
		long post_timepassed = TimeMs / 1000 / 60 / 60 ;	
		post.put("post_timepassed", post_timepassed);
		 
		return post;
	}

	public void updateView(int post_num) {
		postDao.updateView(post_num);
		
	}
	// 작성자 체크	
	private boolean checkWriter(int post_num, int member_num) {
		PostVO post = postDao.selectPost(post_num);
		if(post == null) {
			return false;
		}
		return post.getPost_member_num() == member_num;
	}
	
	public boolean deletePost(int post_num, MemberVO user) {
		if(user == null || user.getMember_num() == 0) {
			return false;
		}
		//작성자인지 확인
		if(!checkWriter(post_num, user.getMember_num())) {
			return false;
		}
		// 게시글 참조 체크
		ChatRoomVO chatRoom = postDao.selectChatRoomChk(post_num); 
		WalletVO wallet = postDao.selectWalletChk(post_num);
		AfterVO after = postDao.selectAfterChk(post_num);
		ReportVO report = postDao.selectReportChk(post_num);
		// 없으면 실제 DB에서 삭제
		if(chatRoom == null && wallet == null && after == null && report == null) {
			try {
				postDao.deletePostAllWish(post_num);
				//서버에서 첨부파일 삭제
				List<FileVO> list = postDao.selectFileList(post_num, "post");
				for(FileVO file : list) {
					deleteFile(file);
				}
				return postDao.deletePost(post_num);
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		postDao.deletePostAllWish(post_num); 
		return postDao.updateDelPost(post_num);
	}
	// 파일 삭제
	private boolean deleteFile(int file_num) {
		FileVO file = postDao.selectFile(file_num);
		return deleteFile(file);
	}
	private boolean deleteFile(FileVO file) {
		if(file == null) {
			return false;
		}
		//첨부파일을 서버에서 삭제
		UploadFileUtils.delteFile(uploadPath, file.getFile_name());
		//첨부파일 정보를 DB에서 삭제
		postDao.deleteFile(file.getFile_num());
		return true;
	}

	public List<FileVO> selectFileList(int target_num, String target) {
		
		return postDao.selectFileList(target_num, target);
	}

	public List<PostVO> getPostList() {
		return postDao.selectPostList();
	}

	public List<ReportCategoryVO> getReportCategory(String type) {
		return postDao.selectReportCategory(type);
	}
	// 게시글 신고
	public int reportPost(ReportVO report, MemberVO user) {
		if(report == null || report.getReport_post_num() == 0 || user == null) {
			return 0;
		}
		// 신고자 중복 체크
		List<ReportVO> reportList = postDao.selectReportByPost(report.getReport_post_num());
		for(ReportVO reportPost : reportList) {
			if(reportPost.getReport_member_num() == user.getMember_num()) {
				return 2;
			}
		}
		report.setReport_member_num(user.getMember_num());
		try {
			return postDao.insertReportPost(report);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	// 유저 신고
	public int reportMember(ReportVO report, MemberVO user) {
		if(report == null || user == null) {
			return 0;
		}
		// 신고자 중복 체크
		List<ReportVO> reportList = postDao.selectReportByMember(report.getReport_member_num2());
		for(ReportVO reportMember : reportList) {
			if(reportMember.getReport_member_num() == user.getMember_num()) {
				return 2;
			}
		}
		report.setReport_member_num(user.getMember_num());
		try {
			return postDao.insertReportMember(report);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	public void updatePostReport(int report_post_num) {
		postDao.updatePostReport(report_post_num);		
	}

	public ReportVO getReportPost(int post_num, MemberVO user) {
		if(user == null) {
			return null;
		}
		return postDao.selectReportPost(post_num, user.getMember_num());
	}

	public WishVO getWish(int post_num, MemberVO user) {
		if(user == null) {
			return null;
		}
		return postDao.selectWish(post_num, user.getMember_num());
	}

	public boolean insertWish(int post_num, MemberVO user) {
		if(user == null) {
			return false;
		}
		return postDao.insertWish(post_num, user.getMember_num());
	}

	public boolean deleteWish(int post_num, MemberVO user) {
		if(user == null) {
			return false;
		}
		return postDao.deleteWish(post_num, user.getMember_num());
	}

	public List<PostVO> getWishPostList(MemberVO user, String sort_type) {
		if(user == null) {
			return null;
		}
		return postDao.selectWishPostList(user.getMember_num(), sort_type);
	}
	//찜 목록에서 삭제
	public boolean deleteWishList(List<String> post_nums, MemberVO user) {
		if(post_nums == null || user == null) {
			return false;
		}
		if(post_nums.size() == 0) {
			return false;
		}else {
			boolean res = false;
			for(String post_numStr : post_nums) {
				res = false;
				int post_num = Integer.parseInt(post_numStr);
				res = postDao.deleteWish(post_num, user.getMember_num());
			}
			if(res) {
				return true;
			}
			return false;
		}
	}

	public List<PostVO> getMyPostList(MyPostCriteria cri) {
		if(cri == null || cri.getMember_num() == 0) {
			return null;
		}
		return postDao.selectMyPostList(cri);
	}

	public PageMaker getPageMaker(MyPostCriteria cri) {
		if(cri == null || cri.getMember_num() == 0) {
			return null;
		}
		int totalCount = postDao.selectTotalCountMyPost(cri);
		return new PageMaker(3, totalCount, cri);
	}

	public PostVO updatePosition(PostVO post) {
		if(post == null) {
			return null;
		}
		try {
			postDao.updatePosition(post);
			return postDao.selectPost(post.getPost_num());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public boolean refresh(int post_num, MemberVO user) {
		if(user == null) {
			return false;
		}
		return postDao.updateRefresh(post_num);
	}

	public int refreshCheck(int post_num) {
		PostVO post = postDao.selectPost(post_num);
		// 현재 Date 객체 생성		
        Date refreshDate = post.getPost_refresh();
        Date writeDate = post.getPost_date();
        // Date를 LocalDate로 변환
        LocalDateTime refresh = refreshDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        LocalDateTime date = writeDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        LocalDateTime currentDateTime = LocalDateTime.now();
        
		long limit = ChronoUnit.MONTHS.between(currentDateTime, date);
		long passedDay = ChronoUnit.DAYS.between(currentDateTime, refresh);
		if(limit > 5) {
			return -1;
		}
		if(passedDay < 7) {			
			return 7 - (int)passedDay;
		}
		return -2;
	}

	public FileVO getFileThumbnail(String target, int target_num) {
		FileVO file = new FileVO(target, target_num);
		return postDao.selectFileThumbnail(file);
	}

	public ChatRoomVO getChatRoom(Map<String, Object> post, MemberVO user) {
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		return postDao.selectChatRoom(member_num, user.getMember_num(), post_num);
	}

	public boolean notifyPropose(Map<String, Object> post, MemberVO user) {
		DecimalFormat price = new DecimalFormat("###,###");
		int type = 1;
		int newPrice = (Integer) post.get("proposePrice");
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		String propStr = "<div>" + user.getMember_id() + "(" + user.getMember_nick() 
						+ ")님이 가격제안을 했습니다.</div>(희망가격: " + price.format(newPrice) + "원)";
		
		return postDao.insertNotification(member_num, type, post_num, propStr);
	}

	public boolean makeChatRoom(Map<String, Object> post, MemberVO user) {
		DecimalFormat price = new DecimalFormat("###,###");
		boolean haggle = true;
		int newPrice = (Integer) post.get("proposePrice");
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		String propStr = "가격제안 : 이 가격에 사고 싶어요.\n(" + price.format(newPrice) + "원)";
		ChatRoomVO chatRoom = new ChatRoomVO(member_num, user.getMember_num(), post_num, haggle);
		postDao.insertChatRoom(chatRoom);
		ChatVO chat = new ChatVO(chatRoom.getChatRoom_member_num2(), chatRoom.getChatRoom_num(), propStr);
		return postDao.insertChat(chat);
		
	}

	public boolean addChat(Map<String, Object> post, ChatRoomVO chatRoom) {
		chatRoom.setChatRoom_haggle(true);
		try {
			postDao.updateChatRoom(chatRoom);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		DecimalFormat price = new DecimalFormat("###,###");
		int newPrice = (Integer) post.get("proposePrice");
		String propStr = "가격제안 : 이 가격에 사고 싶어요. (" + price.format(newPrice) + "원)";
		ChatVO chat = new ChatVO(chatRoom.getChatRoom_member_num2(), chatRoom.getChatRoom_num(), propStr);
		return postDao.insertChat(chat);
	}

	public List<NotificationVO> getNotification(MemberVO user) {
		if(user == null) {
			return null;
		}
		return postDao.selectNotification(user.getMember_num());
	}

	public int getNotReadCount(MemberVO user) {
		if(user == null) {
			return 0;
		}
		return postDao.selectNotReadCount(user.getMember_num());
	}
	// 알림 읽기여부를 읽음으로 변경
	public boolean checkedNotification(int notification_num, MemberVO user) {
		if(user == null) {
			return false;
		}		
		return postDao.updateNotiReadTrue(notification_num);
	}

	public FileVO getProfileImg(String target, int target_num) {
		FileVO file = new FileVO(target, target_num);
		return postDao.selectFileProfileImg(file);
	}

	public MemberVO getMember(int member_num) {
		
		return postDao.selectMember(member_num);
	}

	public List<CombineNotificationWithFileDTO> getNotificationListWithFile(MemberVO user) {
		if(user == null) {
			return null;
		}
		return postDao.selectNotificationListWithFile(user.getMember_num());
	}

	public List<CombinePostWithFileDTO> getPostListWithFileByCategory(int category_num) {
		return postDao.selectPostListWithFileByCategory(category_num);
	}

	public String getCategoryName(int category_num) {
		return postDao.selectCategoryName(category_num);
	}

	public boolean makeChatRoom2(Map<String, Object> post, MemberVO user) {
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		ChatRoomVO chatRoom = new ChatRoomVO(member_num, user.getMember_num(), post_num);
		return postDao.insertChatRoom(chatRoom);
	}

	public void updateMemberReport(int member_num) {
		postDao.updateMemberReport(member_num);
	}

	public boolean updatePostHide(int post_num) {
		return postDao.updatePostHide(post_num);
	}

	public boolean updatePostUse(int post_num) {
		return postDao.updatePostUse(post_num);
	}

	public boolean getHaggleOrNot(int post_num, MemberVO user) {
		if(user == null) {
			return false;
		}
		boolean res = false;
		ChatRoomVO chatRoom = new ChatRoomVO(post_num, user.getMember_num());
		ChatRoomVO haggleOrNot = postDao.selectHaggleOrNot(chatRoom);	
		if(haggleOrNot == null) {
			res = false;
			return res;
		} else {
			return haggleOrNot.isChatRoom_haggle();
		}
	}

	
	public List<CombinePostWithFileDTO> searchItems(String query) {
	    return postDao.searchItems(query);
	}

	public List<CombinePostWithFileDTO> searchLocations(String query) {
	    return postDao.searchLocations(query);
	}

	
	
}