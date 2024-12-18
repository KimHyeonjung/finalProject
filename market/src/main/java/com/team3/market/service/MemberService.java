package com.team3.market.service;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.team3.market.dao.MemberDAO;
import com.team3.market.model.vo.FileVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.utils.UploadFileUtils;

@Service
public class MemberService {
	
	@Autowired
    private MemberDAO memberDao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	@Autowired
	String uploadPath;
	
	public boolean signup(MemberVO member, HttpSession session, String enteredCode) {
		
		if (!verifyCode(enteredCode, session)) {
            return false;  // 인증번호가 일치하지 않으면 회원가입 실패 처리
        }
        // 아이디나 이메일 중복 체크
        if(memberDao.getMemberById(member.getMember_id()) != null || 
           memberDao.getMemberByEmail(member.getMember_email()) != null ||
           memberDao.getMemberByPhone(member.getMember_phone()) != null) {
            return false; // 중복되면 회원가입 실패
        }
        //비밀번호 암호화
        String encPw = passwordEncoder.encode(member.getMember_pw());
		member.setMember_pw(encPw);
        // 회원가입 처리
        return memberDao.insertMember(member);
    }
	
	public boolean verifyCode(String enteredCode, HttpSession session) {
        // 세션에서 저장된 인증번호를 가져옴
        String sessionCode = (String) session.getAttribute("verificationCode");
        

        // 인증번호가 일치하는지 확인
        return enteredCode != null && enteredCode.equals(sessionCode);
    }

	public MemberVO login(MemberVO member) {
		if(member == null) {
			return null;
		}
		//회원 정보를 가져옴(아이디를 이용)
		MemberVO user = memberDao.getMemberById(member.getMember_id());
		//아아디 일치하지 않음
		if(user == null) {
			return null;
		}
		
		if (user.getMember_locked() != null && user.getMember_locked().after(new Date())) {
	        // 계정 잠금이 현재 시간보다 이후일 경우
	        return null;  // 계정이 잠긴 상태로 로그인 불가
	    }
		
		//비번 확인
		if (passwordEncoder.matches(member.getMember_pw(), user.getMember_pw())) {
	        // 로그인 성공 시 실패 횟수 초기화
	        resetFailAttempts(user);
	        return user;
	    } else {
	        // 로그인 실패 처리
	        handleFailedLogin(user);
	        return null;
	    }
	}
   
	
	private void handleFailedLogin(MemberVO user) {
		int failAttempts = user.getMember_fail() + 1;
	    user.setMember_fail(failAttempts);

	    if (failAttempts >= 3) {  // 3회 이상 실패하면 계정 잠금
	        int lockTime = 30 * 60 * 1000; // 30분 동안 잠금
	        Date lockUntil = new Date(System.currentTimeMillis() + lockTime);
	        user.setMember_locked(lockUntil);  
	    }
	    memberDao.updateMemberFail(user);  
		
	}

	private void resetFailAttempts(MemberVO user) {
		user.setMember_fail(0);  // 실패 횟수 초기화
	    user.setMember_locked(null);  // 계정 잠금 해제
	    memberDao.updateMemberFail(user);
		
	}

	public MemberVO getMemberById(String memberId) {
		
		return memberDao.getMemberById(memberId);
	}

	public MemberVO getMemberByNick(String memberNick) {
		
		return memberDao.getMemberByNick(memberNick);
	}

	public MemberVO getMemberByPhone(String memberPhone) {
		
		return memberDao.getMemberByPhone(memberPhone);
	}
	
	public Cookie createCookie(MemberVO user, HttpServletRequest request) {
	    if (user == null) {
	        return null;
	    }
	    HttpSession session = request.getSession();
	    String member_cookie = session.getId(); // 세션 ID로 쿠키 값을 설정
	    Cookie cookie = new Cookie("AL", member_cookie);
	    cookie.setPath("/");
	    int time = 30; // 7일 동안 유지
	    cookie.setMaxAge(time);
	    user.setMember_cookie(member_cookie); // MemberVO 객체에 쿠키 값 설정

	    // 만료 시간 설정
	    Date date = new Date(System.currentTimeMillis() + time * 1000);
	    user.setMember_limit(date);
	    
	    // 데이터베이스에 업데이트
	    memberDao.updateMemberCookie(user);
	    return cookie;
	}
	
	public void updateMemberCookie(MemberVO user) {
	    memberDao.updateMemberCookie(user);
	}

	public void clearAutoLogin(String member_id) {
		 MemberVO user = new MemberVO();
		    user.setMember_id(member_id);
		    user.setMember_cookie(null); // 쿠키 정보 삭제
		    user.setMember_limit(null); // 만료 시간 정보 삭제
		    memberDao.updateMemberCookie(user); // 데이터베이스 업데이트
		
	}

	public MemberVO checkLoginBefore(String sessionId) {
		return memberDao.getMemberBySessionId(sessionId);
	}

	public boolean idCheck(String sns, String id) {
		
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		MemberVO user = memberDao.selectMember(id);
		return user != null;
	}

	@Transactional
	public boolean signupSns(String sns, String id, String email) {
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		
	    
	   
	    MemberVO memberVO = new MemberVO(id,email);
		return memberDao.insertMember(memberVO);
	}

	

	public MemberVO loginSns(String sns, String id) {
		try {
			int num = Integer.parseInt(id);
			num = num * 2;
			id = sns + "!" + num;
		}catch(Exception e) {
			id = sns + "!" + id;
		}
		return memberDao.selectMember(id);
	}

	
	
	public boolean deleteMember(MemberVO user) {
		if(user == null) {
			return false;
		}
		return memberDao.deleteMember(user);
	}

	public boolean changepw(MemberVO user, HttpSession session, String oldPassword, String newPassword) {
		
		user.setMember_id(user.getMember_id());
		
		if(passwordEncoder.matches(oldPassword, user.getMember_pw())) {
			user.setMember_pw(passwordEncoder.encode(newPassword));
			boolean update = memberDao.updatepw(user);
			if(update) {
				session.setAttribute("user", user);
			}
			return update;
        }
		
		return false;
	}

	public boolean changeemail(MemberVO user, HttpSession session, String newEmail) {
		
		user.setMember_id(user.getMember_id());
		
		user.setMember_email(newEmail);
		
		System.out.println(user);
		
		boolean update = memberDao.updateemail(user);
		
		System.out.println(user);
		
		if(update) {
			session.setAttribute("user", user);
		}
		return update;
	}

	public boolean changephone(MemberVO user, HttpSession session, String newPhone) {
		
		user.setMember_id(user.getMember_id());
		
		user.setMember_phone(newPhone);
		
		System.out.println(user);
		
		boolean update = memberDao.updatephone(user);
		
		System.out.println(user);
		
		if(update) {
			session.setAttribute("user", user);
		}
		return update;
	}

	public MemberVO findMemberId(String memberNick, String memberEmail) {
		
		return memberDao.findMemberId(memberNick, memberEmail);
	}
	
	public MemberVO findMemberPw(String memberId, String memberNick, String memberEmail) {
        return memberDao.findMemberPw(memberId, memberNick, memberEmail);
    }
	
	// 임시 비밀번호 생성 메서드
	public String generateTempPassword() {
			// 길이가 10인 랜덤 알파뉴메릭 문자열 생성
			return RandomStringUtils.randomAlphanumeric(10);
	}
	
	// 암호화된 비밀번호 업데이트
	public void updatePassword(MemberVO user, String tempPassword) {
			String encodedPassword = passwordEncoder.encode(tempPassword);
			user.setMember_pw(encodedPassword);
			memberDao.updatepw(user);
	}

	public void updateMember(MemberVO member) {
			System.out.println("Updating member: " + member.getMember_id() + 
													", new money: " + member.getMember_money() + 
													", new fake_money: " + member.getMember_fake_money());
			memberDao.updateMember(member);
	}

	public boolean updateMemberSuspend(int member_num) {
		return memberDao.updateMemberSuspend(member_num);
	}

	public boolean updateMemberUse(int member_num) {
		return memberDao.updateMemberUse(member_num);
	}

	public boolean updateProfile(MemberVO user, MultipartFile file, HttpSession session) {
		if(user == null || file == null) {
			return false;
		}
		boolean res = false;
		//기존 프로필 사진이 있는지 확인
		FileVO profileImg = memberDao.selectFileProfile(user.getMember_num());
		FileVO tmpFile = null;
		if(profileImg == null) {
			tmpFile = uploadsFile(file, "member", user.getMember_num());
			res = memberDao.insertFile(tmpFile);
		} else { // 있을 경우
			res = deleteFile(profileImg);
			tmpFile = uploadsFile(file, "member", user.getMember_num());
			tmpFile.setFile_num(profileImg.getFile_num());
			if(res) {
				res = memberDao.updateFile(tmpFile);
			}else {
				return false;
			}
		}
		user.setFile_name(tmpFile.getFile_name());
		user.setFile_ori_name(tmpFile.getFile_ori_name());
		session.setAttribute("user", user);
		return res;
	}

	public FileVO uploadsFile(MultipartFile file, String target, int target_num) {
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
				FileVO fileVo = new FileVO(file_name, originalFileName, target , target_num);
				
				return fileVo;
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			}
		}
		return null;
	}
	private boolean deleteFile(FileVO file) {
		if(file == null) {
			return false;
		}
		//첨부파일을 서버에서 삭제
		UploadFileUtils.delteFile(uploadPath, file.getFile_name());
		return true;
	}
	
	

}