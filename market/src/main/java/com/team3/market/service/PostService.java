package com.team3.market.service;

import java.io.File;
import java.io.IOException;
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
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.AfterVO;
import com.team3.market.model.vo.Chat_roomVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;
import com.team3.market.model.vo.WalletVO;
import com.team3.market.model.vo.WishVO;
import com.team3.market.pagination.MyPostCriteria;
import com.team3.market.pagination.PageMaker;

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

	public boolean deletePost(int post_num, MemberVO user) {
		if(user == null || user.getMember_num() == 0) {
			return false;
		}
		// 참조 체크
		Chat_roomVO chatRoom = postDao.selectChatRoomChk(post_num); 
//		WishVO wish = postDao.selectWishChk(post_num);
		WalletVO wallet = postDao.selectWalletChk(post_num);
		AfterVO after = postDao.selectAfterChk(post_num);
		ReportVO report = postDao.selectReportChk(post_num);
		if(chatRoom == null && wallet == null && after == null && report == null) {
			try {
				postDao.deletePostAllWish(post_num);
				return postDao.deletePost(post_num);
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		postDao.deletePostAllWish(post_num); 
		return postDao.updateDelPost(post_num);
	}

	public List<PostVO> getPostList() {
		return postDao.selectPostList();
	}

	public List<Report_categoryVO> getReport_category() {
		return postDao.selectReport_category();
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
	
	
}