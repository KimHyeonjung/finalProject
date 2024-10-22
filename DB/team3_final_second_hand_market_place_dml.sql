USE marketplace;

-- 신고 항목
INSERT INTO `report_category` (`report_category_num`, `report_category_name`) VALUES
(1, '광고성 콘텐츠예요'			),
(2, '거래 금지 품목으로 판단돼요'	),
(3, '안전한 거래를 거부해요'		),
(4, '부적절한 내용이 포함돼있어요'	),
(5, '사기가 의심되요'			);


-- 게시글 상태
INSERT INTO `state` (`state_num`, `state_name`) VALUES 
(1,'사용'), (2,'숨김'), (3,'삭제');

-- 거래 상태
INSERT INTO `position` (`position_name`) VALUES 
('판매중'), ('예약중'), ('거래완료');

-- 거래 방식
INSERT INTO `way` (`way_name`) VALUES 
('직거래'), ('택배거래'), ('희망거래');


-- 카테고리
INSERT INTO `category` (`category_name`) VALUES 
('패션'		),	('리빙'		),	('모바일/태블릿'	),
('가전제품'	),	('스포츠'		),	('도서/음반'		),
('반려동물'	),	('유아/완구'	),	('공구/산업용품'	),
('취미용품'	),	('여행'		),	('중고차'			),
('무료나눔'	),  ('삽니다'		);

-- member 테이블에 대한 샘플 데이터 삽입
INSERT INTO `member` 
(`member_id`, `member_pw`, `member_nick`, `member_phone`, `member_email`)
VALUES 
('nonuser', 'aaaaaaaa', '없는 유저', '01000000000', '123@naver.co.kr.com'),
('qweqwe', '$2a$10$5dh4gkVX9JewxXDGja2ny.h1V9NeqQ8/9prqwISJX0coPFZKBaaeO', '큐더블유디', '01012345678', 'qwe@example.com'),
('asdasd', '$2a$10$2nko/eZx0pBwdF6fKJKSge74qbcCbCl.1KBiC3r6mQwWDkKaLDTee', '에이에스디', '01087654321', 'asd@example.com'),
('zxczxc', '$2a$10$jLT.E7GaqFq3upcpNFugxedd/cVrQ4FKS/0y86J4e7dT04lHcY1qi', '즈엑스씨', '01013572468', 'zxc@example.com');


-- post 테이블에 대한 샘플 데이터 삽입category
INSERT INTO `post` 
(`post_num`, `post_member_num`, `post_position_num`, `post_way_num`, `post_category_num`, 
`post_title`, `post_content`, `post_price`, `post_deal`, `post_address`)
VALUES 
(1, 1, 1	, 1	, 	3	, '핸드폰 팝니다'		, '핸드폰'	, 10000, 	true,	'서울, 한국'),
(2, 1, 1	, 2	, 	1	, '바지 팝니다'		, '바지'		, 10000, 	true,	'서울, 한국'),
(3, 2, 3	, 1	, 	4	, '전자레인지 팝니다'	, '전자레인지'	, 20000, 	false,	'부산, 한국'),
(4, 2, 1	, 2	, 	6	, '노인과바다 팔아요'	, '노인과바다'	, 15000, 	true,	'인천, 한국'),
(5, 3, 1	, 1	, 	7	, '목줄 팔아요'		, '목줄'		, 20000, 	false,	'부산, 한국'),
(6, 3, 1	, 3	, 	9	, '드라이버 팝니다'		, '드라이버'	, 20000, 	false,	'부산, 한국'),
(7, 2, 1	, 1	, 	12	, '중고차 팝니다'		, '중고차'	, 2000000, 	false,	'부산, 한국');


INSERT INTO `sido_areas` (`sido_name`) VALUES
('서울특별시'),('부산광역시'),('대구광역시'),('인천광역시'),('광주광역시'),('대전광역시'),('울산광역시'),
('세종특별자치시'),('경기도'),('강원도'),('충청북도'),('충청남도'),('전라북도'),('전라남도'),('경상북도'),
('경상남도'),('제주특별자치도');

-- 서울특별시 (sido_num = 1)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(1, '종로구'),(1, '중구'),(1, '용산구'),(1, '성동구'),(1, '광진구'),(1, '동대문구'),(1, '중랑구'),(1, '성북구'),
(1, '강북구'),(1, '도봉구'),(1, '노원구'),(1, '은평구'),(1, '서대문구'),(1, '마포구'),(1, '양천구'),(1, '강서구'),
(1, '구로구'),(1, '금천구'),(1, '영등포구'),(1, '동작구'),(1, '관악구'),(1, '서초구'),(1, '강남구'),(1, '송파구'),
(1, '강동구');

-- 부산광역시 (sido_num = 2)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(2, '중구'),(2, '서구'),(2, '동구'),(2, '영도구'),(2, '부산진구'),(2, '동래구'),(2, '남구'),(2, '북구'),(2, '해운대구'),
(2, '사하구'),(2, '금정구'),(2, '강서구'),(2, '연제구'),(2, '수영구'),(2, '사상구'),(2, '기장군');

-- 대구광역시 (sido_num = 3)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(3, '중구'),(3, '동구'),(3, '서구'),(3, '남구'),(3, '북구'),(3, '수성구'),(3, '달서구'),(3, '달성군');

-- 인천광역시 (sido_num = 4)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(4, '중구'),(4, '동구'),(4, '미추홀구'),(4, '연수구'),(4, '남동구'),(4, '부평구'),(4, '계양구'),(4, '서구'),
(4, '강화군'),(4, '옹진군');

-- 광주광역시 (sido_num = 5)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(5, '동구'),(5, '서구'),(5, '남구'),(5, '북구'),(5, '광산구');

-- 대전광역시 (sido_num = 6)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(6, '동구'),(6, '중구'),(6, '서구'),(6, '유성구'),(6, '대덕구');

-- 울산광역시 (sido_num = 7)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(7, '중구'),(7, '남구'),(7, '동구'),(7, '북구'),(7, '울주군');

-- 세종특별자치시 (sido_num = 8)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(8, '세종특별자치시');

-- 경기도 (sido_num = 9)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(9, '수원시 장안구'),(9, '수원시 권선구'),(9, '수원시 팔달구'),(9, '수원시 영통구'),(9, '성남시 수정구'),
(9, '성남시 중원구'),(9, '성남시 분당구'),(9, '의정부시'),(9, '안양시 만안구'),(9, '안양시 동안구'),(9, '부천시'),
(9, '광명시'),(9, '평택시'),(9, '동두천시'),(9, '안산시 상록구'),(9, '안산시 단원구'),(9, '고양시 덕양구'),
(9, '고양시 일산동구'),(9, '고양시 일산서구'),(9, '과천시'),(9, '구리시'),(9, '남양주시'),(9, '오산시'),
(9, '시흥시'),(9, '군포시'),(9, '의왕시'),(9, '하남시'),(9, '용인시 처인구'),(9, '용인시 기흥구'),(9, '용인시 수지구'),
(9, '파주시'),(9, '이천시'),(9, '안성시'),(9, '김포시'),(9, '화성시'),(9, '광주시'),(9, '양주시'),(9, '포천시'),
(9, '여주시'),(9, '연천군'),(9, '가평군'),(9, '양평군');

-- 강원도 (sido_num = 10)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(10, '춘천시'),(10, '원주시'),(10, '강릉시'),(10, '동해시'),(10, '태백시'),(10, '속초시'),(10, '삼척시'),(10, '홍천군'),
(10, '횡성군'),(10, '영월군'),(10, '평창군'),(10, '정선군'),(10, '철원군'),(10, '화천군'),(10, '양구군'),(10, '인제군'),
(10, '고성군'),(10, '양양군');

-- 충청북도 (sido_num = 11)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(11, '청주시 상당구'),(11, '청주시 서원구'),(11, '청주시 흥덕구'),(11, '청주시 청원구'),(11, '충주시'),(11, '제천시'),
(11, '보은군'),(11, '옥천군'),(11, '영동군'),(11, '증평군'),(11, '진천군'),(11, '괴산군'),(11, '음성군'),(11, '단양군');

-- 충청남도 (sido_num = 12)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(12, '천안시 동남구'),(12, '천안시 서북구'),(12, '공주시'),(12, '보령시'),(12, '아산시'),(12, '서산시'),(12, '논산시'),
(12, '계룡시'),(12, '당진시'),(12, '금산군'),(12, '부여군'),(12, '서천군'),(12, '청양군'),(12, '홍성군'),(12, '예산군'),
(12, '태안군');

-- 전라북도 (sido_num = 13)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(13, '전주시 완산구'),(13, '전주시 덕진구'),(13, '군산시'),(13, '익산시'),(13, '정읍시'),(13, '남원시'),(13, '김제시'),
(13, '완주군'),(13, '진안군'),(13, '무주군'),(13, '장수군'),(13, '임실군'),(13, '순창군'),(13, '고창군'),(13, '부안군');

-- 전라남도 (sido_num = 14)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(14, '목포시'),(14, '여수시'),(14, '순천시'),(14, '나주시'),(14, '광양시'),(14, '담양군'),(14, '곡성군'),(14, '구례군'),
(14, '고흥군'),(14, '보성군'),(14, '화순군'),(14, '장흥군'),(14, '강진군'),(14, '해남군'),(14, '영암군'),(14, '무안군'),
(14, '함평군'),(14, '영광군'),(14, '장성군'),(14, '완도군'),(14, '진도군'),(14, '신안군');

-- 경상북도 (sido_num = 15)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(15, '포항시 남구'),(15, '포항시 북구'),(15, '경주시'),(15, '김천시'),(15, '안동시'),(15, '구미시'),(15, '영주시'),
(15, '영천시'),(15, '상주시'),(15, '문경시'),(15, '경산시'),(15, '군위군'),(15, '의성군'),(15, '청송군'),(15, '영양군'),
(15, '영덕군'),(15, '청도군'),(15, '고령군'),(15, '성주군'),(15, '칠곡군'),(15, '예천군'),(15, '봉화군'),(15, '울진군'),
(15, '울릉군');

-- 경상남도 (sido_num = 16)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(16, '창원시 의창구'),(16, '창원시 성산구'),(16, '창원시 마산합포구'),(16, '창원시 마산회원구'),
(16, '창원시 진해구'),(16, '진주시'),(16, '통영시'),(16, '사천시'),(16, '김해시'),(16, '밀양시'),(16, '거제시'),
(16, '양산시'),(16, '의령군'),(16, '함안군'),(16, '창녕군'),(16, '고성군'),(16, '남해군'),(16, '하동군'),(16, '산청군'),
(16, '함양군'),(16, '거창군'),(16, '합천군');

-- 제주특별자치도 (sido_num = 17)
INSERT INTO `sigg_areas` (`sigg_sido_num`, `sigg_name`) VALUES
(17, '제주시'),(17, '서귀포시');

-- 서울특별시 종로구 (sigg_num = 1)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(1, '청운동'),(1, '신교동'),(1, '궁정동'),(1, '효자동'),(1, '창성동'),(1, '통인동'),(1, '누상동'),(1, '누하동'),
(1, '옥인동'),(1, '체부동'),(1, '필운동'),(1, '내자동'),(1, '사직동'),(1, '도렴동'),(1, '당주동'),(1, '내수동'),
(1, '신문로1가'),(1, '신문로2가'),(1, '청진동'),(1, '서린동'),(1, '수송동'),(1, '중학동'),(1, '종로1가'),(1, '종로2가'),
(1, '종로3가'),(1, '종로4가'),(1, '종로5가'),(1, '종로6가'),(1, '이화동'),(1, '연건동'),(1, '충신동'),(1, '혜화동'),
(1, '명륜1가'),(1, '명륜2가'),(1, '명륜3가'),(1, '명륜4가'),(1, '동숭동'),(1, '익선동'),(1, '관철동'),(1, '관수동'),
(1, '인의동'),(1, '경운동'),(1, '권농동'),(1, '운니동'),(1, '봉익동'),(1, '돈의동'),(1, '장사동'),(1, '관지동'),
(1, '방산동'),(1, '중림동'),(1, '예지동'),(1, '인사동'),(1, '낙원동'),(1, '팔판동'),(1, '삼청동'),(1, '안국동'),(1, '소격동'),
(1, '재동'),(1, '가회동'),(1, '계동'),(1, '원서동');

-- 서울특별시 중구 (sigg_num = 2)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(2, '소공동'),(2, '회현동1가'),(2, '회현동2가'),(2, '회현동3가'),(2, '남창동'),(2, '북창동'),(2, '태평로1가'),(2, '태평로2가'),
(2, '남대문로1가'),(2, '남대문로2가'),(2, '남대문로3가'),(2, '남대문로4가'),(2, '남대문로5가'),(2, '봉래동1가'),(2, '봉래동2가'),
(2, '중림동'),(2, '서소문동'),(2, '정동'),(2, '의주로1가'),(2, '의주로2가'),(2, '의주로3가'),(2, '충정로1가'),(2, '충정로2가'),
(2, '충정로3가'),(2, '평동'),(2, '순화동'),(2, '주교동'),(2, '소화동'),(2, '후암동'),(2, '갈월동'),(2, '남영동'),(2, '용산동2가'),
(2, '용산동3가'),(2, '용산동5가');

-- 서울특별시 용산구 (sigg_num = 3)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(3, '후암동'),(3, '용산동2가'),(3, '용산동4가'),(3, '용산동5가'),(3, '갈월동'),(3, '남영동'),(3, '동자동'),(3, '서계동'),
(3, '청파동1가'),(3, '청파동2가'),(3, '청파동3가'),(3, '원효로1가'),(3, '원효로2가'),(3, '원효로3가'),(3, '원효로4가'),
(3, '효창동'),(3, '신창동'),(3, '한강로1가'),(3, '한강로2가'),(3, '한강로3가'),(3, '이촌동'),(3, '이태원동'),(3, '한남동'),
(3, '동빙고동'),(3, '서빙고동'),(3, '주성동'),(3, '보광동');

-- 서울특별시 성동구 (sigg_num = 4)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(4, '성수동1가'),(4, '성수동2가'),(4, '송정동'),(4, '용답동'),(4, '금호동1가'),(4, '금호동2가'),(4, '금호동3가'),(4, '금호동4가'),
(4, '옥수동'),(4, '행당동'),(4, '응봉동'),(4, '사근동'),(4, '하왕십리동'),(4, '상왕십리동'),(4, '홍익동'),(4, '도선동'),
(4, '마장동'),(4, '송정동'),(4, '왕십리동');

-- 서울특별시 광진구 (sigg_num = 5)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(5, '중곡동'),(5, '능동'),(5, '구의동'),(5, '광장동'),(5, '자양동'),(5, '화양동'),(5, '군자동'),(5, '번동'),(5, '성동'),
(5, '신기동'),(5, '모진동');

-- 서울특별시 동대문구 (sigg_num = 6)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(6, '청량리동'),(6, '회기동'),(6, '휘경동'),(6, '이문동'),(6, '제기동'),(6, '전농동'),(6, '답십리동'),
(6, '장안동'),(6, '용두동'),(6, '신설동'),(6, '신이문동');

-- 서울특별시 중랑구 (sigg_num = 7)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(7, '면목동'),(7, '상봉동'),(7, '중화동'),(7, '묵동'),(7, '망우동'),(7, '신내동'),(7, '중랑동');

-- 서울특별시 성북구 (sigg_num = 8)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(8, '성북동'),(8, '삼선동'),(8, '동선동'),(8, '돈암동'),(8, '안암동'),(8, '보문동'),(8, '정릉동'),(8, '길음동'),
(8, '종암동'),(8, '하월곡동'),(8, '상월곡동'),(8, '장위동'),(8, '석관동');

-- 서울특별시 강북구 (sigg_num = 9)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(9, '미아동'),(9, '번동'),(9, '수유동'),(9, '우이동'),(9, '인수동');

-- 서울특별시 도봉구 (sigg_num = 10)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(10, '쌍문동'),(10, '방학동'),(10, '도봉동'),(10, '창동'),(10, '덕성동');

-- 서울특별시 노원구 (sigg_num = 11)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(11, '월계동'),(11, '공릉동'),(11, '하계동'),(11, '중계동'),(11, '상계동');

-- 서울특별시 은평구 (sigg_num = 12)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(12, '녹번동'),(12, '불광동'),(12, '갈현동'),(12, '구산동'),(12, '대조동'),(12, '응암동'),(12, '역촌동'),
(12, '신사동'),(12, '증산동'),(12, '수색동'),(12, '진관동');

-- 서울특별시 서대문구 (sigg_num = 13)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(13, '충현동'),(13, '천연동'),(13, '북아현동'),(13, '신촌동'),(13, '연희동'),(13, '홍제동'),(13, '홍은동'),
(13, '남가좌동'),(13, '북가좌동'),(13, '대현동'),(13, '대신동'),(13, '냉천동'),(13, '합동'),(13, '미근동');

-- 서울특별시 마포구 (sigg_num = 14)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(14, '아현동'),(14, '공덕동'),(14, '신공덕동'),(14, '도화동'),(14, '용강동'),(14, '토정동'),(14, '마포동'),(14, '대흥동'),
(14, '염리동'),(14, '노고산동'),(14, '신수동'),(14, '현석동'),(14, '구수동'),(14, '창전동'),(14, '상수동'),(14, '하중동'),
(14, '신정동'),(14, '서교동'),(14, '동교동'),(14, '합정동'),(14, '망원동'),(14, '연남동'),(14, '성산동'),(14, '상암동');

-- 서울특별시 양천구 (sigg_num = 15)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(15, '목1동'),(15, '목2동'),(15, '목3동'),(15, '목4동'),(15, '목5동'),(15, '신정1동'),(15, '신정2동'),(15, '신정3동'),(15, '신정4동'),
(15, '신정6동'),(15, '신정7동'),(15, '신월1동'),(15, '신월2동'),(15, '신월3동'),(15, '신월4동'),(15, '신월5동'),(15, '신월6동'),(15, '신월7동');

-- 서울특별시 강서구 (sigg_num = 16)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(16, '염창동'),(16, '등촌1동'),(16, '등촌2동'),(16, '등촌3동'),(16, '화곡본동'),(16, '화곡1동'),(16, '화곡2동'),(16, '화곡3동'),
(16, '화곡4동'),(16, '화곡6동'),(16, '화곡8동'),(16, '우장산동'),(16, '가양1동'),(16, '가양2동'),(16, '가양3동'),(16, '발산1동'),
(16, '공항동'),(16, '방화1동'),(16, '방화2동'),(16, '방화3동');

-- 서울특별시 구로구 (sigg_num = 17)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(17, '신도림동'),(17, '구로1동'),(17, '구로2동'),(17, '구로3동'),(17, '구로4동'),(17, '구로5동'),(17, '가리봉동'),(17, '고척1동'),
(17, '고척2동'),(17, '개봉1동'),(17, '개봉2동'),(17, '개봉3동'),(17, '오류1동'),(17, '오류2동'),(17, '수궁동');

-- 서울특별시 금천구 (sigg_num = 18)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(18, '가산동'),(18, '독산1동'),(18, '독산2동'),(18, '독산3동'),(18, '독산4동'),(18, '시흥1동'),(18, '시흥2동'),(18, '시흥3동'),
(18, '시흥4동'),(18, '시흥5동');

-- 서울특별시 영등포구 (sigg_num = 19)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(19, '영등포동'),(19, '영등포동1가'),(19, '영등포동2가'),(19, '영등포동3가'),(19, '영등포동4가'),(19, '영등포동5가'),
(19, '여의도동'),(19, '당산동1가'),(19, '당산동2가'),(19, '당산동3가'),(19, '당산동4가'),(19, '당산동5가'),(19, '당산동6가'),
(19, '문래동1가'),(19, '문래동2가'),(19, '문래동3가'),(19, '문래동4가'),(19, '문래동5가'),(19, '문래동6가'),(19, '양평동1가'),
(19, '양평동2가'),(19, '양평동3가'),(19, '양평동4가'),(19, '양평동5가'),(19, '양평동6가'),(19, '양화동'),(19, '신길동'),(19, '대림동');

-- 서울특별시 동작구 (sigg_num = 20)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(20, '노량진동'),(20, '상도동'),(20, '상도1동'),(20, '상도2동'),(20, '상도3동'),(20, '상도4동'),(20, '흑석동'),
(20, '사당동'),(20, '대방동'),(20, '신대방동');

-- 서울특별시 관악구 (sigg_num = 21)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(21, '봉천동'),(21, '신림동'),(21, '남현동');

-- 서울특별시 서초구 (sigg_num = 22)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(22, '서초동'),(22, '방배동'),(22, '잠원동'),(22, '반포동'),(22, '양재동'),(22, '내곡동');

-- 서울특별시 강남구 (sigg_num = 23)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(23, '개포동'),(23, '논현동'),(23, '대치동'),(23, '도곡동'),(23, '삼성동'),(23, '세곡동'),(23, '수서동'),
(23, '신사동'),(23, '압구정동'),(23, '역삼동'),(23, '일원동'),(23, '자곡동'),(23, '청담동');

-- 서울특별시 송파구 (sigg_num = 24)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(24, '가락동'),(24, '거여동'),(24, '마천동'),(24, '문정동'),(24, '방이동'),(24, '삼전동'),(24, '석촌동'),
(24, '송파동'),(24, '오금동'),(24, '위례동'),(24, '장지동'),(24, '잠실동'),(24, '풍납동');

-- 서울특별시 강동구 (sigg_num = 25)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(25, '강일동'),(25, '고덕동'),(25, '길동'),(25, '둔촌동'),(25, '명일동'),(25, '상일동'),
(25, '성내동'),(25, '암사동'),(25, '천호동');

-- 부산광역시 중구 (sigg_num = 26)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(26, '광복동'),(26, '남포동'),(26, '동광동'),(26, '대청동'),(26, '보수동'),(26, '부평동'),(26, '신창동'),
(26, '영주동'),(26, '중앙동');

-- 부산광역시 서구 (sigg_num = 27)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(27, '동대신동'),(27, '서대신동'),(27, '부민동'),(27, '아미동'),(27, '초장동'),(27, '충무동'),(27, '남부민동'),(27, '암남동');

-- 부산광역시 동구 (sigg_num = 28)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(28, '초량동'),(28, '수정동'),(28, '좌천동'),(28, '범일동');

-- 부산광역시 영도구 (sigg_num = 29)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(29, '대교동'),(29, '남항동'),(29, '영선동'),(29, '신선동'),(29, '봉래동'),(29, '청학동'),(29, '동삼동');

-- 부산광역시 부산진구 (sigg_num = 30)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(30, '부전동'),(30, '연지동'),(30, '전포동'),(30, '범천동'),(30, '양정동'),(30, '당감동'),(30, '가야동'),
(30, '개금동'),(30, '범전동'),(30, '초읍동'),(30, '부암동');

-- 부산광역시 동래구 (sigg_num = 31)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(31, '복천동'),(31, '명륜동'),(31, '온천동'),(31, '사직동'),(31, '수안동'),(31, '낙민동'),
(31, '명장동'),(31, '안락동'),(31, '칠산동');

-- 부산광역시 남구 (sigg_num = 32)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(32, '대연동'),(32, '용호동'),(32, '용당동'),(32, '문현동'),(32, '감만동'),(32, '우암동'),(32, '범천동');

-- 부산광역시 북구 (sigg_num = 33)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(33, '구포동'),(33, '금곡동'),(33, '덕천동'),(33, '만덕동'),(33, '화명동'),(33, '대천동'),(33, '덕천제1동'),(33, '덕천제2동');

-- 부산광역시 해운대구 (sigg_num = 34)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(34, '우동'),(34, '중동'),(34, '송정동'),(34, '좌동'),(34, '재송동'),(34, '반여동'),(34, '반송동'),(34, '반송제2동'),
(34, '우제1동'),(34, '좌제1동'),(34, '좌제2동'),(34, '좌제3동'),(34, '좌제4동'),(34, '반여제1동'),(34, '반여제2동'),
(34, '반여제3동'),(34, '반여제4동'),(34, '반송제1동'),(34, '반송제2동');

-- 부산광역시 사하구 (sigg_num = 35)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(35, '괴정동'),(35, '당리동'),(35, '하단동'),(35, '신평동'),(35, '장림동'),(35, '감천동'),(35, '구평동'),(35, '다대동');

-- 부산광역시 금정구 (sigg_num = 36)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(36, '구서동'),(36, '금사동'),(36, '남산동'),(36, '부곡동'),(36, '서동'),(36, '장전동'),(36, '청룡동'),(36, '회동동'),
(36, '금성동'),(36, '두구동');

-- 부산광역시 강서구 (sigg_num = 37)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(37, '대저1동'),(37, '대저2동'),(37, '강동동'),(37, '명지동'),(37, '죽림동'),(37, '식만동'),(37, '죽동동'),(37, '봉림동'),
(37, '송정동'),(37, '화전동'),(37, '녹산동'),(37, '성북동'),(37, '구랑동'),(37, '지사동'),(37, '미음동'),(37, '범방동'),
(37, '신호동'),(37, '동선동'),(37, '가덕도동');
-- 부산광역시 연제구 (sigg_num = 38)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(38, '거제1동'),(38, '거제2동'),(38, '거제3동'),(38, '거제4동'),(38, '연산1동'),(38, '연산2동'),(38, '연산3동'),
(38, '연산4동'),(38, '연산5동'),(38, '연산6동'),(38, '연산8동'),(38, '연산9동');
-- 부산광역시 수영구 (sigg_num = 39)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(39, '광안1동'),(39, '광안2동'),(39, '광안3동'),(39, '광안4동'),(39, '남천1동'),(39, '남천2동'),(39, '수영동'),
(39, '망미1동'),(39, '망미2동'),(39, '민락동');
-- 부산광역시 사상구 (sigg_num = 40)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(40, '삼락동'),(40, '모라1동'),(40, '모라3동'),(40, '덕포1동'),(40, '덕포2동'),(40, '괘법동'),(40, '감전동'),
(40, '주례1동'),(40, '주례2동'),(40, '주례3동'),(40, '학장동'),(40, '엄궁동');
-- 부산광역시 기장군 (sigg_num = 41)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(41, '기장읍'),(41, '장안읍'),(41, '정관읍'),(41, '일광읍'),(41, '철마면');
-- 대구광역시 중구 (sigg_num = 42)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(42, '동인동'),(42, '삼덕동'),(42, '성내1동'),(42, '성내2동'),(42, '성내3동'),(42, '대신동'),(42, '남산1동'),(42, '남산2동'),
(42, '남산3동'),(42, '남산4동');
-- 대구광역시 동구 (sigg_num = 43)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(43, '신암1동'),(43, '신암2동'),(43, '신암3동'),(43, '신암4동'),(43, '신암5동'),(43, '신천1동'),(43, '신천2동'),
(43, '신천3동'),(43, '신천4동'),(43, '효목1동'),(43, '효목2동'),(43, '도평동'),(43, '불로봉무동'),(43, '지저동'),
(43, '동촌동'),(43, '방촌동'),(43, '해안동'),(43, '안심1동'),(43, '안심2동'),(43, '안심3동'),(43, '안심4동'),(43, '공산동');
-- 대구광역시 서구 (sigg_num = 44)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(44, '내당1동'),(44, '내당2동'),(44, '내당3동'),(44, '내당4동'),(44, '비산1동'),
(44, '비산2동'),(44, '비산3동'),(44, '비산4동'),(44, '비산5동'),(44, '비산6동'),(44, '비산7동'),(44, '평리1동'),
(44, '평리2동'),(44, '평리3동'),(44, '평리4동'),(44, '평리5동'),(44, '평리6동'),(44, '상중이동'),(44, '원대동');
-- 대구광역시 남구 (sigg_num = 45)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(45, '이천동'),(45, '봉덕1동'),(45, '봉덕2동'),(45, '봉덕3동'),(45, '대명1동'),(45, '대명2동'),(45, '대명3동'),
(45, '대명4동'),(45, '대명5동'),(45, '대명6동'),(45, '대명9동'),(45, '대명10동');
-- 대구광역시 북구 (sigg_num = 46)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(46, '고성동1가'),(46, '고성동2가'),(46, '고성동3가'),(46, '칠성동1가'),(46, '칠성동2가'),(46, '침산1동'),(46, '침산2동'),
(46, '침산3동'),(46, '산격1동'),(46, '산격2동'),(46, '산격3동'),(46, '산격4동'),(46, '대현동'),(46, '복현1동'),(46, '복현2동'),
(46, '검단동'),(46, '무태조야동'),(46, '관문동'),(46, '태전1동'),(46, '태전2동'),(46, '구암동'),(46, '관음동'),(46, '동천동'),(46, '국우동');
-- 대구광역시 수성구 (sigg_num = 47)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(47, '범어1동'),(47, '범어2동'),(47, '범어3동'),(47, '범어4동'),(47, '만촌1동'),(47, '만촌2동'),(47, '만촌3동'),(47, '수성1가동'),
(47, '수성2가동'),(47, '수성3가동'),(47, '수성4가동'),(47, '황금1동'),(47, '황금2동'),(47, '중동'),(47, '상동'),(47, '파동'),
(47, '두산동'),(47, '지산1동'),(47, '지산2동'),(47, '범물1동'),(47, '범물2동'),(47, '신매동'),(47, '고산1동'),(47, '고산2동'),(47, '고산3동');
-- 대구광역시 달서구 (sigg_num = 48)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(48, '성당동'),(48, '두류1·2동'),(48, '두류3동'),(48, '감삼동'),(48, '죽전동'),(48, '장기동'),(48, '용산1동'),(48, '용산2동'),
(48, '이곡1동'),(48, '이곡2동'),(48, '신당동'),(48, '본리동'),(48, '월성1동'),(48, '월성2동'),(48, '진천동'),(48, '상인1동'),
(48, '상인2동'),(48, '상인3동'),(48, '도원동'),(48, '파호동'),(48, '송현1동'),(48, '송현2동'),(48, '본동');
-- 대구광역시 달성군 (sigg_num = 49)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(49, '화원읍'),(49, '논공읍'),(49, '다사읍'),(49, '유가읍'),(49, '옥포읍'),(49, '현풍읍'),(49, '가창면'),(49, '하빈면'),(49, '구지면');
-- 인천광역시 중구 (sigg_num = 50)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(50, '관동'),(50, '송학동'),(50, '중산동'),(50, '운남동'),(50, '운서동'),(50, '영종동'),(50, '운북동'),(50, '신포동'),
(50, '연안동'),(50, '도원동'),(50, '율목동'),(50, '동인천동'),(50, '북성동'),(50, '신흥동'),(50, '답동'),(50, '신생동'),(50, '용유동');
-- 인천광역시 동구 (sigg_num = 51)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(51, '만석동'),(51, '화수동'),(51, '송현동'),(51, '화평동'),(51, '창영동'),(51, '금곡동'),(51, '송림동'),(51, '송현동'),(51, '화수2동');
-- 인천광역시 미추홀구 (sigg_num = 52)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(52, '숭의동'),(52, '용현동'),(52, '학익동'),(52, '도화동'),(52, '주안동'),(52, '관교동'),(52, '문학동');
-- 인천광역시 연수구 (sigg_num = 53)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(53, '연수동'),(53, '동춘동'),(53, '청학동'),(53, '선학동'),(53, '송도동'),(53, '옥련동'),(53, '학익동');
-- 인천광역시 남동구 (sigg_num = 54)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(54, '구월동'),(54, '간석동'),(54, '만수동'),(54, '장수동'),(54, '서창동'),(54, '운연동'),(54, '도림동'),(54, '논현동'),(54, '고잔동');
-- 인천광역시 부평구 (sigg_num = 55)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(55, '부평동'),(55, '십정동'),(55, '산곡동'),(55, '청천동'),(55, '삼산동'),(55, '갈산동'),(55, '부개동'),(55, '일신동'),(55, '송내동');
-- 인천광역시 계양구 (sigg_num = 56)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(56, '효성동'),(56, '계산동'),(56, '작전동'),(56, '서운동'),(56, '임학동'),(56, '용종동'),(56, '병방동'),(56, '방축동'),
(56, '박촌동'),(56, '동양동'),(56, '귤현동'),(56, '상야동'),(56, '평동'),(56, '노오지동');
-- 인천광역시 서구 (sigg_num = 57)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(57, '경서동'),(57, '백석동'),(57, '시천동'),(57, '검암동'),(57, '원창동'),(57, '연희동'),(57, '공촌동'),(57, '심곡동'),
(57, '가정동'),(57, '석남동'),(57, '신현동'),(57, '가좌동'),(57, '마전동'),(57, '당하동'),(57, '원당동'),(57, '대곡동'),
(57, '불로동'),(57, '금곡동'),(57, '오류동'),(57, '왕길동'),(57, '검단동'),(57, '아라동');
-- 인천광역시 강화군 (sigg_num = 58)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(58, '강화읍'),(58, '선원면'),(58, '불은면'),(58, '길상면'),(58, '화도면'),(58, '양도면'),(58, '내가면'),(58, '하점면'),
(58, '양사면'),(58, '송해면'),(58, '교동면'),(58, '삼산면'),(58, '서도면');
-- 인천광역시 옹진군 (sigg_num = 59)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(59, '백령면'),(59, '대청면'),(59, '덕적면'),(59, '영흥면'),(59, '자월면'),(59, '연평면'),(59, '북도면'),(59, '남동면');
-- 광주광역시 동구 (sigg_num = 60)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(60, '학동'),(60, '학운동'),(60, '계림동'),(60, '충장동'),(60, '동명동'),(60, '산수동'),(60, '지산동'),(60, '서석동'),
(60, '소태동'),(60, '선교동'),(60, '운림동'),(60, '남동'),(60, '금남로1가'),(60, '금남로2가'),(60, '금남로3가'),(60, '금남로4가'),
(60, '금남로5가'),(60, '서남동');
-- 광주광역시 서구 (sigg_num = 61)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(61, '양동'),(61, '양3동'),(61, '농성동'),(61, '광천동'),(61, '유덕동'),(61, '덕흥동'),(61, '화정동'),(61, '치평동'),(61, '상무동'),
(61, '내방동'),(61, '쌍촌동'),(61, '풍암동'),(61, '금호동'),(61, '마륵동'),(61, '세하동'),(61, '서창동'),(61, '벽진동'),(61, '동천동');
-- 광주광역시 남구 (sigg_num = 62)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(62, '양림동'),(62, '방림동'),(62, '사직동'),(62, '월산동'),(62, '백운동'),(62, '주월동'),(62, '송하동'),(62, '임암동'),(62, '대촌동'),
(62, '효덕동'),(62, '행암동'),(62, '노대동'),(62, '지석동'),(62, '압촌동'),(62, '화장동'),(62, '원산동'),(62, '승촌동'),(62, '양촌동'),
(62, '칠석동'),(62, '석정동');
-- 광주광역시 북구 (sigg_num = 63)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(63, '중흥동'),(63, '유동'),(63, '누문동'),(63, '운암동'),(63, '동림동'),(63, '일곡동'),(63, '매곡동'),(63, '문흥동'),(63, '각화동'),
(63, '두암동'),(63, '오치동'),(63, '삼각동'),(63, '일동'),(63, '본촌동'),(63, '신안동'),(63, '용봉동'),(63, '풍향동'),(63, '문화동'),
(63, '문흥동'),(63, '각화동'),(63, '충효동'),(63, '청풍동'),(63, '덕의동'),(63, '금곡동'),(63, '망월동'),(63, '운정동'),(63, '화암동'),
(63, '장등동'),(63, '연제동'),(63, '복룡동'),(63, '생용동'),(63, '용전동'),(63, '수곡동');
-- 광주광역시 광산구 (sigg_num = 64)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(64, '송정동'),(64, '도산동'),(64, '도호동'),(64, '신촌동'),(64, '동호동'),(64, '월곡동'),(64, '하남동'),(64, '비아동'),(64, '수완동'),
(64, '흑석동'),(64, '임곡동'),(64, '본량동'),(64, '동림동'),(64, '대산동'),(64, '월전동'),(64, '산월동'),(64, '용곡동'),(64, '평동'),
(64, '장록동'),(64, '지죽동'),(64, '선암동'),(64, '복룡동'),(64, '송산동'),(64, '오선동'),(64, '광산동'),(64, '덕림동'),(64, '장덕동'),
(64, '산정동'),(64, '우산동'),(64, '신가동'),(64, '운남동'),(64, '신창동'),(64, '쌍암동'),(64, '첨단동'),(64, '비아동'),(64, '장수동'),
(64, '하산동'),(64, '양산동');
-- 대전광역시 동구 (sigg_num = 65)
INSERT INTO `emd_areas` (`emd_sigg_num`, `emd_name`) VALUES
(65, '가양동'),(65, '가오동'),(65, '구도동'),(65, '낭월동'),(65, '내탑동'),(65, '대동'),(65, '마산동'),(65, '삼괴동'),(65, '삼성동'),
(65, '상소동'),(65, '성남동'),(65, '세천동'),(65, '소제동'),(65, '신상동'),(65, '신촌동'),(65, '신흥동'),(65, '오동'),(65, '용계동'),
(65, '용운동'),(65, '원동'),(65, '이사동'),(65, '인동'),(65, '자양동'),(65, '주산동'),(65, '주촌동'),(65, '중앙동'),(65, '직동'),
(65, '천동'),(65, '판암동'),(65, '하소동'),(65, '홍도동');
