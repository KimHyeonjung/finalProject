package com.team3.market.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WalletVO {
    private int wallet_num; 
    private int wallet_member_num;
    private int wallet_post_num;
    private int wallet_money;
    private Date wallet_date;
}
