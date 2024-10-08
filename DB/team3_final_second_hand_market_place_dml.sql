USE marketplace;

-- 게시물 상태
INSERT INTO `position` (`position_num`, `position_name`) VALUES 
(1, '팝니다'), (2, '삽니다'), (3, '예약중'), (4, '거래완료'), (5, '무료나눔');

-- 거래 방식
INSERT INTO `way` (`way_num`, `way_name`) VALUES 
(1, '직거래'), (2, '택배 거래'), (3, '직거래+택배거래');

-- 카테고리
INSERT INTO `category` (`category_num`, `category_name`) VALUES 
(1	, '패션'		),	(2	, '리빙'		),	(3	, '모바일/태블릿'	),
(4	, '가전제품'	),	(5	, '스포츠'	),	(6	, '도서/음반'		),
(7	, '반려동물'	),	(8	, '유아/완구'	),	(9	, '공구/산업용품'	),
(10	, '취미용품'	),	(11	, '여행'		),	(12	, '중고차'		);

-- member 테이블에 대한 샘플 데이터 삽입
INSERT INTO `member` 
(`member_num`, `member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`, 
`member_auth`, `member_state`, `member_report`, `member_score`, `member_money`)
VALUES 
(1, 'qwe', 'qweqwe', 'qweqweqwe', '010-1234-5678', 'qwe@example.com', 'USER', 'ACTIVE'	, 0, 4.5, 10000	),
(2, 'asd', 'asdasd', 'asdasdasd', '010-8765-4321', 'asd@example.com', 'USER', 'ACTIVE'	, 1, 3.9, 5000	),
(3, 'zxc', 'zxczxc', 'zxczxczxc', '010-1357-2468', 'zxc@example.com', 'USER', 'INACTIVE', 2, 4.8, 15000	);

-- post 테이블에 대한 샘플 데이터 삽입
INSERT INTO `post` 
(`post_num`, `post_member_num`, `post_position_num`, `post_way_num`, `post_category_num`, 
`post_title`, `post_content`, `post_price`, `post_deal`, `post_date`, `post_refresh`, `post_address`)
VALUES 
(1, 1, 1, 1, 3, '핸드폰'		, '핸드폰'	, 10000, true, 	'2024-01-01', NULL, '서울, 한국'),
(2, 1, 1, 2, 1, '바지'		, '바지'		, 10000, true, 	'2024-01-01', NULL, '서울, 한국'),
(3, 2, 1, 1, 4, '전자레인지'	, '전자레인지'	, 20000, false, '2024-02-01', NULL, '부산, 한국'),
(4, 2, 1, 3, 6, '노인과바다'	, '노인과바다'	, 15000, true, 	'2024-03-01', NUll, '인천, 한국'),
(5, 3, 1, 2, 7, '목줄'		, '목줄'		, 20000, false, '2024-02-01', NULL, '부산, 한국'),
(6, 3, 1, 3, 9, '드라이버'	, '드라이버'	, 20000, false, '2024-02-01', NULL, '부산, 한국');