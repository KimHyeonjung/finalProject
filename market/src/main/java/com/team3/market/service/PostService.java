package com.team3.market.service;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.PostDAO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.ReportVO;
import com.team3.market.model.vo.Report_categoryVO;
import com.team3.market.model.vo.WishVO;

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
		Date writeTime = (Date) post.get("post_date");
		Date nowTime = new Date();
		long beforeTimeMs = nowTime.getTime() - writeTime.getTime();		 
		long post_timepassed = beforeTimeMs / 1000 / 60 / 60 ;	
		post.put("post_timepassed", post_timepassed);
		 
		return post;
	}

	public void updateView(int post_num) {
		postDao.updateView(post_num);
		
	}

	public boolean deletePost(int post_num) {
		return postDao.deletePost(post_num);
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
	
}
