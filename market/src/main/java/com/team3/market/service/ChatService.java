package com.team3.market.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team3.market.dao.ChatDAO;
import com.team3.market.dao.WalletDAO;
import com.team3.market.model.dto.ChatRoomDTO;
import com.team3.market.model.vo.ChatRoomVO;
import com.team3.market.model.vo.ChatVO;
import com.team3.market.model.vo.MemberVO;
import com.team3.market.model.vo.PostVO;
import com.team3.market.model.vo.WalletVO;

@Service
public class ChatService {

	@Autowired
	private ChatDAO chatDAO;

	@Autowired
	private MemberService memberService;

	@Autowired
	WalletDAO walletDao;

	public List<ChatRoomDTO> getChatRoomsWithMembers(int member_num) {
		List<ChatRoomVO> chatRooms = chatDAO.selectChatRoomsByMember(member_num);
		List<ChatRoomDTO> chatRoomWithMembers = new ArrayList<ChatRoomDTO>();

		for (ChatRoomVO chatRoom : chatRooms) {
			// 발신자 정보를 DB에서 가져옴
			MemberVO targetMember = getSenderByChatRoomId(chatRoom.getChatRoom_num(), member_num);
			// 최신 채팅 메시지 가져오기
			ChatVO lastChat = chatDAO.selectLatestChatByRoom(chatRoom.getChatRoom_num());
			chatRoomWithMembers.add(new ChatRoomDTO(chatRoom, targetMember, lastChat));
		}

		return chatRoomWithMembers;
	}

	private MemberVO getSenderByChatRoomId(int chatRoom_num, int member_num) {
		return chatDAO.selectSenderByChatRoom(chatRoom_num, member_num);
	}

	// 특정 채팅방의 채팅 내역 가져오기
	public List<ChatRoomDTO> getChatsByRoom(int chatRoomNum) {
		List<ChatVO> chats = chatDAO.selectChatsByRoom(chatRoomNum);
		List<ChatRoomDTO> chatRoomDTOs = new ArrayList<ChatRoomDTO>();

		for (ChatVO chat : chats) {
			MemberVO member = chatDAO.selectMemberById(chat.getChat_member_num());
			ChatRoomDTO dto = new ChatRoomDTO(null, member, chat);
			chatRoomDTOs.add(dto);
		}

		return chatRoomDTOs;
	}

	public void saveChatMessage(ChatVO chatVO) {
		chatDAO.insertChat(chatVO);
	}

	public PostVO getChatRoomPost(int chatRoomNum) {
		return chatDAO.selectChatRoomPost(chatRoomNum);
	}

	public boolean deleteChatRoom(int chatRoomNum) {
		return chatDAO.deleteChatRoom(chatRoomNum);
	}

	public boolean notify(Map<String, Object> item, MemberVO user, MemberVO postUser) {
		int type = 4;
		int chatRoom_num = (Integer) item.get("chatRoom_num");
		String content = (String) item.get("content");

		int maxLength = 15;
		if (content.length() > maxLength) {
			content = content.substring(0, maxLength) + "..."; // 15자를 넘으면 자르고 "..." 추가
		}

		String propStr = "<div>" + user.getMember_id() + "(" + user.getMember_nick() + ")</div>" + "<div>" + content
				+ "</div>";

		System.out.println(propStr);

		return chatDAO.insertNotification(postUser.getMember_num(), type, chatRoom_num, propStr);
	}

	public MemberVO getMember(Integer chatRoom_num, Integer member_num) {
		return chatDAO.selectChatRoomByMember(chatRoom_num, member_num);
	}

	public Integer getTargetMemberNumByChatRoomNum(int chatRoomNum, int senderMemberNum) {
		Map<String, Integer> params = new HashMap<>();
		params.put("chatRoomNum", chatRoomNum);
		params.put("senderMemberNum", senderMemberNum);

		List<MemberVO> members = chatDAO.selectChatRoomBySender(params);

		if (!members.isEmpty()) {
			return members.get(0).getMember_num(); // 상대방을 반환
		}

		return null; // 상대방을 찾지 못한 경우
	}

	public ChatRoomVO getChatRoomByNum(int chatRoomNum) {
		return chatDAO.selectChatRoomById(chatRoomNum);
	}

	public Object getChatRoomNumByMembers(Integer senderMemberNum, Integer targetMemberNum) {
		Map<String, Integer> params = new HashMap<>();
		params.put("senderMemberNum", senderMemberNum);
		params.put("targetMemberNum", targetMemberNum);
		return chatDAO.selectChatRoomNumByMembers(params);
	}

	public List<MemberVO> getMembersInChatRoom(int chatRoomId) {
		return chatDAO.selectMembersByChatRoomId(chatRoomId);
	}

	@Transactional
	public void completeTransactionForChatRoom(Integer chatRoomId) {
		// 선택한 채팅방에 있는 멤버들 가져오기
		List<MemberVO> membersInSelectedRoom = getMembersInChatRoom(chatRoomId);

		// Step 1: 선택한 채팅방에 있는 멤버들의 money 업데이트 및 fake_money 초기화
		for (MemberVO member : membersInSelectedRoom) {
			int updatedMoney = member.getMember_money() + member.getMember_fake_money();
			member.setMember_money(updatedMoney);
			member.setMember_fake_money(0);
			memberService.updateMember(member); // 데이터베이스에 변경 사항 저장
		}

		List<MemberVO> membersWithFakeMoneyInOtherRooms = chatDAO
				.selectMembersWithFakeMoneyExcludingChatRoom(chatRoomId);
		for (MemberVO member : membersWithFakeMoneyInOtherRooms) {
			member.setMember_fake_money(0);
			memberService.updateMember(member); // fake_money를 0으로 설정
		}
	}

	@Transactional
	public void completeTransaction(int chatRoom_num) {
		
		// 선택한 채팅방 정보 가져오기
		ChatRoomVO selectedChatRoom = walletDao.selectChatRoomById(chatRoom_num);
		if (selectedChatRoom == null) {
			throw new IllegalArgumentException("선택한 채팅방을 찾을 수 없습니다.");
		}

		// 거래 완료 후 채팅방 리스트 중 하나 선택해서 거래 완료를 누른 시점

		int stayMoney = selectedChatRoom.getChatRoom_stay_money();

		if (stayMoney != 0) {
			// 선택한 채팅방의 멤버들 fake_money에서 stayMoney를 member_money로 이동
			List<MemberVO> selectedRoomMembers = walletDao.getChatRoomMembers(chatRoom_num);
			for (MemberVO member : selectedRoomMembers) {
				member.setMember_fake_money(member.getMember_fake_money() - stayMoney);
				member.setMember_money(member.getMember_money() + stayMoney);

				WalletVO walletEntry = new WalletVO();
				walletEntry.setWallet_member_num(member.getMember_num());
				walletEntry.setWallet_post_num(selectedChatRoom.getChatRoom_post_num());
				walletEntry.setWallet_money(stayMoney);
				walletDao.insertWalletEntry(walletEntry);
			}

			// 다른 채팅방의 chatRoom_stay_money를 사용하여 fake_money 조정
			Map<String, Object> params = new HashMap<>();
			params.put("chatRoom_num", chatRoom_num);
			params.put("members", selectedRoomMembers);

			List<ChatRoomVO> otherChatRooms = walletDao.getOtherChatRooms(params); // 매개변수를 Map으로 전달

			for (ChatRoomVO chatRoom : otherChatRooms) {
				int otherStayMoney = chatRoom.getChatRoom_stay_money();
				List<MemberVO> otherRoomMembers = walletDao.getChatRoomMembers(chatRoom.getChatRoom_num());
				for (MemberVO member : otherRoomMembers) {
					if (member.getMember_fake_money() < 0) {
						member.setMember_fake_money(member.getMember_fake_money() + otherStayMoney);
					} else {
						member.setMember_fake_money(member.getMember_fake_money() - otherStayMoney);
					}
					walletDao.updateFakeMoney(member);

					WalletVO walletEntry = new WalletVO();
					walletEntry.setWallet_member_num(member.getMember_num());
					walletEntry.setWallet_post_num(chatRoom.getChatRoom_post_num());
					walletEntry.setWallet_money(otherStayMoney);
					walletDao.insertWalletEntry(walletEntry);
				}
			}

			// 거래 완료된 채팅방의 stay_money를 0으로 초기화
			selectedChatRoom.setChatRoom_stay_money(0);
			walletDao.updateChatRoomStayMoney(selectedChatRoom);
		}
	}

}