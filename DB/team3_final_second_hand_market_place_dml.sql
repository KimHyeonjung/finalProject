USE marketplace;

-- 거래 상태
INSERT INTO `position` (`position_name`) VALUES 
('팝니다'), ('예약중'), ('거래완료'), ('무료나눔');

-- 거래 방식
INSERT INTO `way` (`way_name`) VALUES 
('직거래'), ('택배거래'), ('희망거래');

-- 카테고리
INSERT INTO `category` (`category_name`) VALUES 
('패션'		),	('리빙'		),	('모바일/태블릿'	),
('가전제품'	),	('스포츠'		),	('도서/음반'		),
('반려동물'	),	('유아/완구'	),	('공구/산업용품'	),
('취미용품'	),	('여행'		),	('중고차'			),
('삽니다'		);

-- member 테이블에 대한 샘플 데이터 삽입
INSERT INTO `member` 
(`member_num`, `member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`, 
`member_auth`, `member_state`, `member_report`, `member_score`, `member_money`)
VALUES 
(1, 'qwe', 'qweqwe', 'qweqweqwe', '010-1234-5678', 'qwe@example.com', 'USER', '사용'	, 0, 4.5, 10000	),
(2, 'asd', 'asdasd', 'asdasdasd', '010-8765-4321', 'asd@example.com', 'USER', '사용'	, 1, 3.9, 5000	),
(3, 'zxc', 'zxczxc', 'zxczxczxc', '010-1357-2468', 'zxc@example.com', 'USER', '휴면', 2, 4.8, 15000	);

-- post 테이블에 대한 샘플 데이터 삽입
INSERT INTO `post` 
(`post_num`, `post_member_num`, `post_position_name`, `post_way_name`, `post_category_name`, 
`post_title`, `post_content`, `post_price`, `post_deal`, `post_date`, `post_refresh`, `post_address`)
VALUES 
(1, 1, '팝니다', '직거래', '모바일/태블릿', '핸드폰'		, '핸드폰'	, 10000, true, 	'2024-01-01', NULL, '서울, 한국'),
(2, 1, '팝니다', '예약중', '패션', '바지'		, '바지'		, 10000, true, 	'2024-01-01', NULL, '서울, 한국'),
(3, 2, '팝니다', '직거래', '가전제품', '전자레인지'	, '전자레인지'	, 20000, false, '2024-02-01', NULL, '부산, 한국'),
(4, 2, '팝니다', '거래완료', '도서/음반', '노인과바다'	, '노인과바다'	, 15000, true, 	'2024-03-01', NUll, '인천, 한국'),
(5, 3, '팝니다', '직거래', '반려동물', '목줄'		, '목줄'		, 20000, false, '2024-02-01', NULL, '부산, 한국'),
(6, 3, '팝니다', '무료나눔', '공구/산업용품', '드라이버'	, '드라이버'	, 20000, false, '2024-02-01', NULL, '부산, 한국');
