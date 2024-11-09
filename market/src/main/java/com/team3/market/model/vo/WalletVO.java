package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WalletVO {
	private int wallet_num; 
	private int wallet_post_num;  
	private int wallet_seller; 
	private int wallet_buyer; 
	private int wallet_amount;
	private String wallet_payout_status;
	private String wallet_order_status; 
	private Date wallet_created; 
	private Date wallet_updated;
	
	public WalletVO(int postNum, Integer targetMemberNum, Integer senderMemberNum, int amount) {
		this.wallet_post_num = postNum;
		this.wallet_seller = targetMemberNum;
		this.wallet_buyer = senderMemberNum;
		this.wallet_amount = amount;
	}

	public WalletVO(int post_num, int member_num) {
		this.wallet_post_num = post_num;
		this.wallet_buyer = member_num;
	}

	public WalletVO(int postNum, Integer targetMemberNum, int senderMemberNum) {
		this.wallet_post_num = postNum;
		this.wallet_seller = targetMemberNum;
		this.wallet_buyer = senderMemberNum;
	}
}
