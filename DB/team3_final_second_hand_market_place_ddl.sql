DROP DATABASE IF EXISTS marketplace;

CREATE DATABASE marketplace;

USE marketplace;

DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
	`member_num`	int primary key auto_increment	NOT NULL,
	`member_id`	varchar(13) unique	NOT NULL,
	`member_pw`	varchar(20)	NOT NULL,
	`member_nick`	varchar(10)	NOT NULL,
	`member_phone`	varchar(13)	NOT NULL,
	`member_email`	varchar(30)	NOT NULL,
	`member_auth`	varchar(5)	NOT NULL,
	`member_state`	varchar(10)	NULL,
	`member_report`	int	NULL,
	`member_score`	float	NULL,
	`member_money`	int	NULL
);

DROP TABLE IF EXISTS `post`;

CREATE TABLE `post` (
	`post_num`	int primary key auto_increment	NOT NULL,
	`post_member_num`	int	NOT NULL,
	`post_position_num`	int	NOT NULL,
	`post_way_num`	int	NOT NULL,
	`post_category_num`	int	NOT NULL,
	`post_title`	varchar(20)	NOT NULL,
	`post_content`	varchar(255)	NOT NULL,
	`post_price`	int	NULL,
	`post_deal`	boolean	NOT NULL,
	`post_date`	date	NOT NULL,
	`post_refresh`	date	NULL,
	`post_address`	varchar(100)	NULL
);

DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
	`category_num`	int primary key auto_increment	NOT NULL,
	`category_name`	varchar(10)	NULL
);

DROP TABLE IF EXISTS `wish`;

CREATE TABLE `wish` (
	`wish_num`	int primary key auto_increment	NOT NULL,
	`wish_post_name`	int	NOT NULL,
	`wish_member_num`	int	NOT NULL,
	`wish_date`	date	NULL
);

DROP TABLE IF EXISTS `address`;

CREATE TABLE `address` (
	`address_num`	int primary key auto_increment	NOT NULL,
	`address_member_num`	int	NOT NULL,
	`address_name`	varchar(10)	NULL,
	`address_ad`	varchar(100)	NULL
);

DROP TABLE IF EXISTS `way`;

CREATE TABLE `way` (
	`way_num`	int primary key auto_increment	NOT NULL,
	`way_name`	varchar(10)	NULL
);

DROP TABLE IF EXISTS `notice`;

CREATE TABLE `notice` (
	`notice_num`	int primary key auto_increment	NOT NULL,
	`notice_member_num`	int	NOT NULL,
	`notice_title`	varchar(20)	NULL,
	`notice_content`	varchar(255)	NULL
);

DROP TABLE IF EXISTS `report`;

CREATE TABLE `report` (
	`report_num`	int primary key auto_increment	NOT NULL,
	`report_member_num`	int	NOT NULL,
	`report_member_ num2`	int	NULL,
	`report_post_num`	int	NULL,
	`report_category_num`	int	NOT NULL,
	`report_content`	varchar(100)	NULL,
	`report_date`	date	NULL
);

DROP TABLE IF EXISTS `chat_room`;

CREATE TABLE `chat_room` (
	`chatRoom_num`	int primary key auto_increment	NOT NULL,
	`charRoom_member_num`	int	NOT NULL,
	`charRoom_member_num2`	int	NOT NULL,
	`charRoom_post_name`	int	NOT NULL,
	`charRoom_date`	date	NULL
);

DROP TABLE IF EXISTS `chat`;

CREATE TABLE `chat` (
	`chat_num`	int primary key auto_increment	NOT NULL,
	`chat_member_num`	int	NOT NULL,
	`chat_chatRoom_num`	int	NOT NULL,
	`chat_content`	varchar(100)	NULL,
	`chat_read`	bool	NULL,
	`chat_date`	date	NULL
);

DROP TABLE IF EXISTS `block`;

CREATE TABLE `block` (
	`block_num`	int primary key auto_increment	NOT NULL,
	`block_member_num`	int	NOT NULL,
	`block_member_num2`	int	NOT NULL,
	`block_date`	date	NULL
);

DROP TABLE IF EXISTS `position`;

CREATE TABLE `position` (
	`position_num`	int primary key auto_increment	NOT NULL,
	`position_name`	varchar(10)	NULL
);

DROP TABLE IF EXISTS `file`;

CREATE TABLE `file` (
	`file_num`	int primary key auto_increment	NOT NULL,
	`file_name`	varchar(255)	NULL,
	`file_ori_name`	varchar(255)	NULL,
	`file_target_table`	varchar(10)	NULL,
	`file_target_num`	int	NULL
);

DROP TABLE IF EXISTS `wallet`;

CREATE TABLE `wallet` (
	`wallet_num`	int primary key auto_increment	NOT NULL,
	`wallet_member_num`	int	NOT NULL,
	`wallet_post_name`	int	NOT NULL,
	`wallet_money`	int	NULL,
	`wallet_date`	date	NULL
);

DROP TABLE IF EXISTS `point`;

CREATE TABLE `point` (
	`point_num`	int primary key auto_increment	NOT NULL,
	`point_member_num`	int	NOT NULL,
	`point_money`	int	NULL,
	`point_date`	date	NULL,
	`point_type`	varchar(20)	NOT NULL
);

DROP TABLE IF EXISTS `notification`;

CREATE TABLE `notification` (
	`notification_num`	int primary key auto_increment	NOT NULL,
	`notification_member_num`	int	NOT NULL,
	`notification_type_num`	int	NOT NULL,
	`notification_message`	varchar(50)	NULL,
	`notification_read`	boolean	NULL,
	`notification_date`	date	NULL
);

DROP TABLE IF EXISTS `deal`;

CREATE TABLE `deal` (
	`deal_num`	int primary key auto_increment	NOT NULL,
	`deal_price`	int	NOT NULL,
	`deal_yes_or_no`	boolean	NOT NULL,
	`deal_post_name`	int	NOT NULL,
	`deal_member_num`	int	NOT NULL
);

DROP TABLE IF EXISTS `keywords_notification`;

CREATE TABLE `keywords_notification` (
	`keywords_num`	int primary key auto_increment	NOT NULL,
	`keywords_memeber_num`	int	NOT NULL,
	`keywords_name`	varchar(20)	NULL
);

DROP TABLE IF EXISTS `after`;

CREATE TABLE `after` (
	`after_num`	int primary key auto_increment	NOT NULL,
	`after_member_num`	int	NOT NULL,
	`after_post_name`	int	NOT NULL,
	`after_message`	varchar(255)	NULL
);

DROP TABLE IF EXISTS `grade`;

CREATE TABLE `grade` (
	`grade_num`	int primary key auto_increment	NOT NULL,
	`grade_score`	float	NOT NULL,
	`grade_text`	varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS `sido_areas`;

CREATE TABLE `sido_areas` (
	`sido_num`	int primary key auto_increment	NOT NULL,
	`sido_name`	varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS `sigg_areas`;

CREATE TABLE `sigg_areas` (
	`sigg_num`	int primary key auto_increment	NOT NULL,
	`sigg_sido_num`	int	NOT NULL,
	`sigg_name`	varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS `emd_areas`;

CREATE TABLE `emd_areas` (
	`emd_num`	int primary key auto_increment	NOT NULL,
	`emd_sigg_num`	int	NOT NULL,
	`emd_name`	varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS `activity_areas`;

CREATE TABLE `activity_areas` (
	`activity_emd_num`	int NOT NULL,
	`activity_member_num`	int NOT NULL,
    PRIMARY KEY (`activity_emd_num`, `activity_member_num`)
);

DROP TABLE IF EXISTS `notification_type`;

CREATE TABLE `notification_type` (
	`notification_type_num`	int primary key auto_increment	NOT NULL,
	`notification_type_name`	varchar(20)	NOT NULL
);

DROP TABLE IF EXISTS `rating`;

CREATE TABLE `rating` (
	`rating_num`	int primary key auto_increment	NOT NULL,
	`rating_grade_num2`	int	NOT NULL,
	`rating_after_num`	int	NOT NULL
);

DROP TABLE IF EXISTS `report_category`;

CREATE TABLE `report_category` (
	`report_category_num`	int primary key auto_increment	NOT NULL,
	`report_category_name`	varchar(20)	NOT NULL
);

ALTER TABLE `post` ADD CONSTRAINT `FK_member_TO_post_1` FOREIGN KEY (
	`post_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `post` ADD CONSTRAINT `FK_position_TO_post_1` FOREIGN KEY (
	`post_position_num`
)
REFERENCES `position` (
	`position_num`
);

ALTER TABLE `post` ADD CONSTRAINT `FK_way_TO_post_1` FOREIGN KEY (
	`post_way_num`
)
REFERENCES `way` (
	`way_num`
);

ALTER TABLE `post` ADD CONSTRAINT `FK_category_TO_post_1` FOREIGN KEY (
	`post_category_num`
)
REFERENCES `category` (
	`category_num`
);

ALTER TABLE `wish` ADD CONSTRAINT `FK_post_TO_wish_1` FOREIGN KEY (
	`wish_post_name`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `wish` ADD CONSTRAINT `FK_member_TO_wish_1` FOREIGN KEY (
	`wish_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `address` ADD CONSTRAINT `FK_member_TO_address_1` FOREIGN KEY (
	`address_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `notice` ADD CONSTRAINT `FK_member_TO_notice_1` FOREIGN KEY (
	`notice_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `report` ADD CONSTRAINT `FK_member_TO_report_1` FOREIGN KEY (
	`report_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `report` ADD CONSTRAINT `FK_member_TO_report_2` FOREIGN KEY (
	`report_member_ num2`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `report` ADD CONSTRAINT `FK_post_TO_report_1` FOREIGN KEY (
	`report_post_num`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `report` ADD CONSTRAINT `FK_report_category_TO_report_1` FOREIGN KEY (
	`report_category_num`
)
REFERENCES `report_category` (
	`report_category_num`
);

ALTER TABLE `chat_room` ADD CONSTRAINT `FK_member_TO_chat_room_1` FOREIGN KEY (
	`charRoom_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `chat_room` ADD CONSTRAINT `FK_member_TO_chat_room_2` FOREIGN KEY (
	`charRoom_member_num2`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `chat_room` ADD CONSTRAINT `FK_post_TO_chat_room_1` FOREIGN KEY (
	`charRoom_post_name`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `chat` ADD CONSTRAINT `FK_member_TO_chat_1` FOREIGN KEY (
	`chat_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `chat` ADD CONSTRAINT `FK_chat_room_TO_chat_1` FOREIGN KEY (
	`chat_chatRoom_num`
)
REFERENCES `chat_room` (
	`chatRoom_num`
);

ALTER TABLE `block` ADD CONSTRAINT `FK_member_TO_block_1` FOREIGN KEY (
	`block_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `block` ADD CONSTRAINT `FK_member_TO_block_2` FOREIGN KEY (
	`block_member_num2`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `wallet` ADD CONSTRAINT `FK_member_TO_wallet_1` FOREIGN KEY (
	`wallet_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `wallet` ADD CONSTRAINT `FK_post_TO_wallet_1` FOREIGN KEY (
	`wallet_post_name`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `point` ADD CONSTRAINT `FK_member_TO_point_1` FOREIGN KEY (
	`point_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `notification` ADD CONSTRAINT `FK_member_TO_notification_1` FOREIGN KEY (
	`notification_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `notification` ADD CONSTRAINT `FK_notification_type_TO_notification_1` FOREIGN KEY (
	`notification_type_num`
)
REFERENCES `notification_type` (
	`notification_type_num`
);

ALTER TABLE `deal` ADD CONSTRAINT `FK_post_TO_deal_1` FOREIGN KEY (
	`deal_post_name`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `deal` ADD CONSTRAINT `FK_member_TO_deal_1` FOREIGN KEY (
	`deal_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `keywords_notification` ADD CONSTRAINT `FK_member_TO_keywords_notification_1` FOREIGN KEY (
	`keywords_memeber_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `after` ADD CONSTRAINT `FK_member_TO_after_1` FOREIGN KEY (
	`after_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `after` ADD CONSTRAINT `FK_post_TO_after_1` FOREIGN KEY (
	`after_post_name`
)
REFERENCES `post` (
	`post_num`
);

ALTER TABLE `sigg_areas` ADD CONSTRAINT `FK_sido_areas_TO_sigg_areas_1` FOREIGN KEY (
	`sigg_sido_num`
)
REFERENCES `sido_areas` (
	`sido_num`
);

ALTER TABLE `emd_areas` ADD CONSTRAINT `FK_sigg_areas_TO_emd_areas_1` FOREIGN KEY (
	`emd_sigg_num`
)
REFERENCES `sigg_areas` (
	`sigg_num`
);

ALTER TABLE `activity_areas` ADD CONSTRAINT `FK_emd_areas_TO_activity_areas_1` FOREIGN KEY (
	`activity_emd_num`
)
REFERENCES `emd_areas` (
	`emd_num`
);

ALTER TABLE `activity_areas` ADD CONSTRAINT `FK_member_TO_activity_areas_1` FOREIGN KEY (
	`activity_member_num`
)
REFERENCES `member` (
	`member_num`
);

ALTER TABLE `rating` ADD CONSTRAINT `FK_grade_TO_rating_1` FOREIGN KEY (
	`rating_grade_num2`
)
REFERENCES `grade` (
	`grade_num`
);

ALTER TABLE `rating` ADD CONSTRAINT `FK_after_TO_rating_1` FOREIGN KEY (
	`rating_after_num`
)
REFERENCES `after` (
	`after_num`
);

