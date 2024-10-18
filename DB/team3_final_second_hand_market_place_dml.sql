USE marketplace;

-- 신고 항목
INSERT INTO `report_category` (`report_category_num`, `report_category_name`) VALUES
(1, '광고성 콘텐츠예요'			),
(2, '거래 금지 품목으로 판단돼요'	),
(3, '안전한 거래를 거부해요'		),
(4, '부적절한 내용이 포함돼있어요'	),
(5, '사기가 의심되요'			);


-- 거래 상태
INSERT INTO `position` (`position_name`) VALUES 
('판매중'), ('예약중'), ('거래완료');

-- 거래 방식
INSERT INTO `way` (`way_num`, `way_name`) VALUES 
(1, '직거래'), (2, '택배 거래'), (3, '직거래+택배거래');

-- 카테고리
INSERT INTO `category` (`category_num`, `category_name`) VALUES 
(1, '패션'		),	(2, '리빙'		),	(3, '모바일/태블릿'	),
(4, '가전제품'	),	(5, '스포츠'		),	(6, '도서/음반'		),
(7, '반려동물'	),	(8, '유아/완구'	),	(9, '공구/산업용품'	),
(10, '취미용품'	),	(11, '여행'		),	(12, '중고차'			),
(13, '무료나눔'	),  (14, '삽니다'		);

-- member 테이블에 대한 샘플 데이터 삽입
INSERT INTO `member` 
(`member_num`, `member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`, 
`member_auth`, `member_state`, `member_report`, `member_score`, `member_money`)
VALUES 
('qwe', 'qweqwe', '큐더블유디', '01012345678', 'qwe@example.com'),
('asd', 'asdasd', '에이에스디', '01087654321', 'asd@example.com'),
('zxc', 'zxczxc', '즈엑스씨', '01013572468', 'zxc@example.com');

-- post 테이블에 대한 샘플 데이터 삽입
INSERT INTO `post` 
(`post_num`, `post_member_num`, `post_position_num`, `post_way_num`, `post_category_num`, 
`post_title`, `post_content`, `post_price`, `post_deal`, `post_refresh`, `post_address`)
VALUES 
(1, 1, 1	, 1	, 	3	, '핸드폰 팝니다'		, '핸드폰'	, 10000, true, 	 NULL, '서울, 한국'),
(2, 1, 1	, 2	, 	1	, '바지 팝니다'		, '바지'		, 10000, true, 	 NULL, '서울, 한국'),
(3, 2, 3	, 1	, 	4	, '전자레인지 팝니다'	, '전자레인지'	, 20000, false,  NULL, '부산, 한국'),
(4, 2, 1	, 2	, 	6	, '노인과바다 팔아요'	, '노인과바다'	, 15000, true, 	 NUll, '인천, 한국'),
(5, 3, 1	, 1	, 	7	, '목줄 팔아요'		, '목줄'		, 20000, false,  NULL, '부산, 한국'),
(6, 3, 1	, 3	, 	9	, '드라이버 팝니다'		, '드라이버'	, 20000, false,  NULL, '부산, 한국');
