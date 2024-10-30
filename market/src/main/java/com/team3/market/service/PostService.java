package com.team3.market.service;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.PostDAO;
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
    private String uploadPath; // WebMvcConfig에서 설정된 경로 주입
	
//	@Resource
//	String uploadPath;
	//게시글 가져오기
	public PostVO getPost(int post_num) {
		return postDao.selectPost(post_num);
	}
	
    // 카테고리 목록을 가져오는 메서드 추가
    public List<String> getCategoryList() {
        return postDao.selectCategoryList();
    }
	
	public boolean insertPost(PostVO post, MemberVO user, MultipartFile[] fileList) {
		
		if(post == null || user == null) {
			return false;
		}
		if(post.getPost_title().length() == 0) {
			return false;
		}
		
		post.setPost_member_num(user.getMember_num());
		
		
		boolean res = postDao.insertPost(post);
		
		if(!res) {
			return false;
		}
		
		if(fileList == null || fileList.length == 0) {
			return false;
		}
		
		//FileVO file = new FileVO("UUID_파일명", "원래파일명", "post", post.getPost_num());
		//FileVO file = new FileVO(file_ori_name, file.file_name, "post", post.getPost_num());
		
        for (MultipartFile file : fileList) {
            if (!file.isEmpty()) {
                try {
                    // 원본 파일명 가져오기
                    String originalFileName = file.getOriginalFilename();

                    // 파일명을 UUID로 변환하여 고유하게 설정
                    String uuidFileName = UUID.randomUUID().toString() + "_" + originalFileName;

                    // 저장할 파일 객체 생성
                    File saveFile = new File(uploadPath, uuidFileName);
                    
                    // 파일을 저장하는 부분
                    file.transferTo(saveFile);

                    // FileVO 객체 생성 및 데이터 설정
                    FileVO fileVO = new FileVO(uuidFileName, originalFileName, "post", post.getPost_num());
                    
                    // 파일 정보를 DB에 저장
                    postDao.insertFile(fileVO);

                } catch (IOException e) {
                    e.printStackTrace();
                    return false;
                }
            }
        }
		
		
		
		return true;
	}
	
	public boolean insertReview(AfterVO review, MemberVO user) {
		
		review.setAfter_member_num(user.getMember_num());
		
		return postDao.insertAfter(review);
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
	private void deleteFile(FileVO file) {
		if(file == null) {
			return;
		}
		//첨부파일을 서버에서 삭제
		UploadFileUtils.delteFile(uploadPath, file.getFile_name());
		//첨부파일 정보를 DB에서 삭제
		postDao.deleteFile(file.getFile_num());
	}

	public List<FileVO> selectFileList(int target_num, String target) {
		
		return postDao.selectFileList(target_num, target);
	}

	public List<PostVO> getPostList() {
		return postDao.selectPostList();
	}

	public List<ReportCategoryVO> getReportCategory() {
		return postDao.selectReportCategory();
	}
	// 게시글 신고
	public int reportPost(ReportVO report, MemberVO user) {
		if(report == null || report.getReport_post_num() == 0 || user == null) {
			return 0;
		}
		// 신고자 중복 체크
		List<ReportVO> reportPostList = postDao.getReport(report.getReport_post_num());
		for(ReportVO reportPost : reportPostList) {
			if(reportPost.getReport_member_num() == user.getMember_num()) {
				return 2;
			}
		}
		try {
			return postDao.insertReportPost(report, user.getMember_num());
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

	public FileVO getFile(int target_num, String target) {
		
		return postDao.selectFile(target_num, target);
	}

	public ChatRoomVO getChatRoom(Map<String, Object> post, MemberVO user) {
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		return postDao.selectChatRoom(member_num, user.getMember_num(), post_num);
	}

	public boolean notify(Map<String, Object> post, MemberVO user) {
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
		int newPrice = (Integer) post.get("proposePrice");
		int post_num = (Integer) post.get("post_num");
		int member_num = (Integer) post.get("member_num");
		String propStr = "가격제안 : 이 가격에 사고 싶어요.\n(" + price.format(newPrice) + "원)";
		ChatRoomVO chatRoom = new ChatRoomVO(member_num, user.getMember_num(), post_num);
		postDao.insertChatRoom(chatRoom);
		ChatVO chat = new ChatVO(chatRoom.getChatRoom_member_num2(), chatRoom.getChatRoom_num(), propStr);
		return postDao.insertChat(chat);
		
	}

	public boolean addChat(Map<String, Object> post, ChatRoomVO chatRoom) {
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

	public FileVO getProfileImg(int target_num, String target) {
		
		return postDao.selectFile(target_num, target);
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

	
	
}