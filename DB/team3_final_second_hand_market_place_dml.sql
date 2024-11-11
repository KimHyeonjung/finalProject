USE marketplace;

-- 알림 타입
INSERT INTO `notification_type` (`notification_type_num`, `notification_type_name`) VALUES 
(1,'가격제안'), (2,'가격하락'), (3,'가격상승'), (4,'채팅수신');
-- 신고 항목
INSERT INTO `report_category` (`report_category_num`, `report_category_name`, `report_category_type`) VALUES
(1, '광고성 콘텐츠예요'				, 'post'),
(2, '거래 금지 품목으로 판단돼요'		, 'post'),
(3, '안전한 거래를 거부해요'			, 'post'),
(4, '부적절한 내용이 포함돼있어요'		, 'post'),
(5, '사기가 의심되요'				, 'post'),
(6, '비매너 사용자에요'				, 'member'),
(7, '전문 판매업자 같아요'			, 'member'),
(8, '부적절한 성적 행위를 해요'		, 'member'),
(9, '욕설, 비방, 혐오표현을 해요'		, 'member'),
(10, '전문 판매업자 같아요'			, 'member');


-- 게시글 상태
INSERT INTO `state` (`state_num`, `state_name`) VALUES 
(1,'사용'), (2,'숨김'), (3,'삭제');

-- 거래 상태
INSERT INTO `position` (`position_num`, `position_name`) VALUES 
(1, '판매중'), (2, '구매중'), (3, '무료나눔'), (4, '예약중'), (5, '거래완료');

-- 거래 방식
INSERT INTO `way` (`way_name`) VALUES 
('직거래'), ('택배거래'), ('희망거래');


-- 카테고리
INSERT INTO `category` (`category_name`) VALUES 
('패션'		),	('리빙'		),	('모바일/태블릿'	),
('가전제품'	),	('스포츠'		),	('도서/음반'		),
('반려동물'	),	('유아/완구'	),	('공구/산업용품'	),
('취미용품'	),	('여행'		),	('중고차'			);

-- member 테이블에 대한 샘플 데이터 삽입
INSERT INTO `member` 
(`member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`)
VALUES 
('qweqwe', '$2a$10$5dh4gkVX9JewxXDGja2ny.h1V9NeqQ8/9prqwISJX0coPFZKBaaeO', '큐더블유디', '01012345678', 'qwe@example.com'),
('asdasd', '$2a$10$2nko/eZx0pBwdF6fKJKSge74qbcCbCl.1KBiC3r6mQwWDkKaLDTee', '에이에스디', '01087654321', 'asd@example.com'),
('zxczxc', '$2a$10$jLT.E7GaqFq3upcpNFugxedd/cVrQ4FKS/0y86J4e7dT04lHcY1qi', '즈엑스씨', '01013572468', 'zxc@example.com');
-- member 테이블에 대한 관리자 데이터 삽입
INSERT INTO `member` 
(`member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`, `member_auth`)
VALUES 
('admin123', '$2a$10$pkWV1ttU2oJwmZxhq9BLx.maWlDGIGfTLRe5.jkvn4FbE7xpCHyjK', '관리자', '01011112222', 'admin@example.com', 'ADMIN');

-- post 테이블에 대한 샘플 데이터 삽입category
INSERT INTO `post` 
(`post_num`, `post_member_num`, `post_position_num`, `post_way_num`, `post_category_num`, 
`post_title`, `post_content`, `post_price`, `post_deal`, `post_address`)
VALUES 
(1, 1, 1	, 1	, 	3	, '핸드폰 팝니다'		, '핸드폰'	, 10000, 	true,	'경기 화성시 중동 118-43'),
(2, 1, 1	, 2	, 	1	, '바지 팝니다'		, '바지'		, 10000, 	true,	'서울 강동구 천호동 465-26'),
(3, 2, 4	, 1	, 	4	, '전자레인지 팝니다'	, '전자레인지'	, 20000, 	false,	'서울 서대문구 신촌동 74-12'),
(4, 2, 1	, 2	, 	6	, '노인과바다 팔아요'	, '노인과바다'	, 15000, 	true,	'부산 부산진구 양정동 378-57'),
(5, 3, 1	, 1	, 	7	, '목줄 팔아요'		, '목줄'		, 20000, 	false,	'부산 강서구 대저2동 1200-24'),
(6, 3, 1	, 3	, 	9	, '드라이버 팝니다'		, '드라이버'	, 20000, 	false,	'인천 남동구 도림동 418-28'),
(7, 2, 1	, 1	, 	12	, '중고차 팝니다'		, '중고차'	, 2000000, 	false,	'인천 부평구 청천동 산 59-1'),
(8, 1, 1  , 1, 5, '축구공 팝니다' , '축구공' , 90000, true, '인천 부평구 청천동 산 59-1'),
(9, 1, 1  , 1, 2, '세탁기 팜' , '세탁기팜' , 90000000, true, '서울 서대문구 신촌동 74-12'),
(10, 1, 1  , 1, 8, '깜빡핑' , '깜빡핑' , 70000, true, '서울 서대문구 신촌동 74-12'),
(11, 1, 1  , 1, 10, '전설의 낚싯대' , '낚싯대' , 90000000, true, '서울 서대문구 신촌동 74-12'),
(12, 1, 1  , 1, 11, '에르젠 라운지 쉘터s4' , '텐트' , 10000, true, '서울 서대문구 신촌동 74-12');

INSERT INTO `notice`
(`notice_num`, `notice_member_num`, `notice_title`, `notice_date`, `notice_pin`)
VALUES
(1, 1, '분쟁조정센터 공식 운영 안내', '2024-10-29', false),
(2, 2, '서버 점검 예정 공지', '2024-10-30', false),
(3, 1, '회원 가입 관련 변경사항 안내', '2024-11-01', true),
(4, 3, '새로운 거래 보호 시스템 도입 안내', '2024-11-02', false),
(5, 2, '사이트 이용 규정 업데이트', '2024-11-03', false),
(6, 1, '핵심 기능 업데이트 및 패치 노트', '2024-11-04', true),
(7, 3, '이용자 의견 수렴 이벤트 공지', '2024-11-05', false),
(8, 1, '거래 안전을 위한 팁과 주의사항', '2024-11-06', false),
(9, 2, '긴급 공지: 사이트 일시적 접속 불가 안내', '2024-11-07', true),
(10, 3, '2024년 연말 고객 감사 이벤트', '2024-11-08', false);


