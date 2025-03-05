--chap3 함수

/*
	함수
	단일행함수 : 하나의 레코드에서만 사용되는 함수
	그룹함수 : 여러행에 관련된 기능을 처리하는 함수
					group by, having 구문과 관련있는 함수
*/
-- 문자관련 단일행 함수
-- 대소문자 변환 함수 : upper, lower
-- 학생의 전공1학과가 101번인 학생의 이름, id, 대문자id, 소문자id 조회
SELECT NAME , id, UPPER(id), LOWER(id) FROM student
WHERE major1 = 101

-- 문자열 길이 함수 : length, char_length
-- length : 저장된 바이트 수. 오라클(lengthb)
-- char_length : 문자열의 길이. 오라클(length)
-- 학생의 이름, 아이디, 이름글자수, 이름바이트수, id글자수, id바이트수 조회하기
SELECT NAME, id, CHAR_LENGTH(NAME), LENGTH(NAME), CHAR_LENGTH(id), LENGTH(id)
FROM student
/*
	영문자, 숫자의 경우 : 바이트수와 문자열의 길이가 같음
	한글의 경우 : 문자열의 길이 *3 = 바이트수 길이
					  한글을 저장하는 컬럼의 varchar자료형의 크기는 한글글자수 *3 만큼 설정해야함
*/
SELECT LENGTH("가나다라마바사아"), LENGTH("1234567890"), LENGTH("ABCDEFGHI")
					  
-- 문자열 연결 함수 : concat
-- 교수의 이름과 직급을 연결하여 조회하기
SELECT concat(NAME,' ',POSITION,'님') 교수명 FROM professor
-- 학생정보를 홍길동 1학년 150cm 50kg 형태로 학생정보 출력하기
-- 학년 순으로 정렬하기
SELECT CONCAT(NAME,' ', grade,"학년 ",height,"cm ",weight,"kg ") 학생정보
FROM student
ORDER BY grade

-- 부분문자열 : substr
-- substr(컬럼명 | 문자열, 시작인덱스(1부터 시작), 글자수)
-- substr(컬럼명 | 문자열, 시작인덱스(1부터 시작)) : 시작 인덱스 부터 문자열 끝까지
-- left  (컬럼명|문자열, 글자수) : 왼쪽부터 글자수만큼 부분문자열로 리턴
-- right (컬럼명|문자열, 글자수) : 오른쪽부터 글자수만큼 부분문자열로 리턴
-- 학생의 이름 2자만 조회하기
SELECT NAME, LEFT(NAME, 2), RIGHT(NAME, 2), SUBSTR(NAME, 1, 2), substr(NAME, 2)
FROM student

-- 학생의 이름과 주민번호 기준 생일 출력하기
SELECT NAME, jumin, LEFT(jumin, 6), SUBSTR(jumin, 1, 6) FROM student

-- 1.학생 중 생일이 3월인 학생의 이름, 생년월일 조회
-- 생일은 주민번호 기준으로 한다
SELECT NAME, LEFT(jumin, 6) FROM student
WHERE SUBSTR(jumin, 3,2) = '03'

-- 2. 학생의 이름, 학년, 생년월일을 조회하기
-- 단 생년월일은 주민번호 기준이고, 형식을 99년99월99일로
-- 월기준으로 정렬하여 출력하기
SELECT NAME, grade, 
	concat(LEFT(jumin, 2),'년 ',SUBSTR(jumin,3,2),'월 ', SUBSTR(jumin, 5,2),'일 ') 생년월일
FROM student
ORDER BY SUBSTR(jumin, 3,2) 

-- 문자열에서 문자의 위치인덱스 리턴 : instr
-- instr(컬럼|문자열,문자) : 컬럼에서 문자의 위치인덱스 값을 리턴
-- 학생의 이름, 전화번호, )의 위치값 조회
SELECT NAME, tel, INSTR(tel, ')') FROM student

-- 문제 : 학생의 이름, 전화번호, 전화번호의 전화지역번호 출력하기
SELECT NAME, tel , LEFT(tel , INSTR(tel, ')')-1) 전화지역번호 FROM student
SELECT NAME, tel , substr(tel ,1, INSTR(tel, ')')-1) 전화지역번호 FROM student

-- 학생 전화번호의 어떤 지역번호인지를 출력
SELECT distinct LEFT(tel , INSTR(tel, ')')-1) FROM student

-- 문제
-- 교수테이블에서 교수이름, url, homepage 조회하기
-- homepage : url 정보에서 http:// 이후의 문자열을 의미
SELECT NAME, URL, SUBSTR(URL, INSTR(URL, '/')+2) homepage FROM professor
SELECT NAME, URL, SUBSTR(URL, CHAR_LENGTH('http://')+1) homepage FROM professor

-- 문자추가함수 : lpad, rpad
-- lpad(컬럼, 전체자리수, 추가문자) : 
-- 	컬럼을 전체자리수 출력시 빈자리는 왼쪽에 추가문자로 추가
-- rpad(컬럼, 전체자리수, 추가문자) :
-- 	컬럼을 전체자리수 출력시 빈자리는 오른쪽에 추가문자로 추가

-- 학생의 학번, 이름 조회하기.
-- 학번은 10자리로 빈자리는 오른쪽에 * 채우기
-- 이름은 10자리로 빈자리는 왼쪽에 #으로 채우기
SELECT rpad(studno,10,'*'), LPAD(NAME, 10, '#') FROM student

-- 문제 : 교수테이블에서 이름과 직급 출력하기
-- 직급은 12자리로 출력하고, 빈자리는 *를 오른쪽에 채우기
SELECT NAME, RPAD(POSITION, 12, '*') FROM professor

-- 문자 제거 함수 : trim, ltrim, rtrim
-- trim(문자열) : 양쪽 공백 제거
-- rtrim(문자열) : 오른쪽 공백 제거
-- ltrim(문자열) : 왼쪽 공백 제거
-- trim({LEADING|Tailing|BOTH} 변경할 문자열 from 문자열)
-- 	leading : 왼쪽 문자 제거
-- 	trailing : 오른쪽 문자 제거
-- 	Both : 양쪽 문자 제거
SELECT CONCAT('***', TRIM('     양쪽 공백 제거        '),'***')
SELECT CONCAT('***', RTRIM('     오른쪽 공백 제거        '),'***')
SELECT CONCAT('***', LTRIM('     왼쪽 공백 제거        '),'***')
SELECT TRIM(BOTH '0' FROM '000120000005670000') -- 양쪽 지정문자 전부 제거
SELECT TRIM(Leading '0' FROM '000120000005670000') -- 왼쪽 지정문자 제거
SELECT TRIM(trailing '0' FROM '000120000005670000') -- 오른쪽 지정문  제거 

-- 교수테이블에서 교수이름, url, homepage를 출력하기
-- homepage는 url에서 http:// 이후의 문자열
SELECT NAME, URL, TRIM(LEADING 'http://' FROM URL) homepage FROM professor

-- 문자 치환함수 : replace
-- replace(컬럼명, '문자1', '문자2') : 컬럼의 값의 문자1을 문자2로 치환
-- 학생의 이름중 성만 #으로 변경하여 출력
SELECT NAME, REPLACE(NAME, SUBSTR(NAME, 1,1), '#') FROM student

-- 학생의 이름중 두번째 문자를 #으로 변경하여 출력하기
SELECT NAME, REPLACE(NAME, SUBSTR(NAME, 2,1), '#') FROM student

-- 101학과 학생의 이름, 주민번호 조회하기
-- 주민번호 뒤의 6자리는 *로 출력하기
SELECT NAME, REPLACE(jumin, RIGHT(jumin, 6), '******') FROM student
WHERE major1 = 101
SELECT NAME, REPLACE(jumin, substr(jumin, 8), '******') FROM student
WHERE major1 = 101
SELECT NAME, concat(jumin, left(jumin, 7), '******') FROM student
WHERE major1 = 101

-- find_in_set : ,로 나누어진 문자열 그룹에서 그룹의 위치 리턴
-- find_in_set(문자열, ', 나누어진 문자열 그룹')
--		그룹 문자열에서 문자열이 없으면 0을 리턴
SELECT find_in_set('y', 'x,y,z') --- 2
SELECT find_in_set('a', 'x,y,z') --- 0

/*
	숫자 관련 함수
*/
-- 반올림 함수 : round
-- round(숫자) : 소수점 이하 첫번째 자리에서 반올림하여 정수형으로 출력
-- round(숫자, 자릿수) : 소숫점(0)을 기준으로  10의 자리 -1, 소숫점이하는 1,2,3...
SELECT ROUND(12.3456, -1) r1, ROUND(12.3456) r2, ROUND(12.3456,0) r3,
		 ROUND(12.3456, 1) r4, ROUND(12.3456, 2) r5, ROUND(12.3456, 3) r6
-- 버림 함수 : truncate
-- truncate(숫자, 자릿수) : 소숫점을 기준으로 10의자리 -1, 소숫점이하는 1,2,3...
SELECT truncate(12.3456, -1) r1, truncate(12.3456, 0) r2, truncate(12.3456,0) r3,
		 truncate(12.3456, 1) r4, truncate(12.3456, 2) r5, truncate(12.3456, 3) r6
 
-- 교수의 급여를 15% 인상하여 정수로 출력하기.
-- 교수이름, 정수로 출력된 반올림 예상급여, 절삭된 예상급여 출력하기
SELECT NAME, ROUND(salary*1.15) 예상급여 , TRUNCATE(salary*1.15, 0) '절삭된 예상급여' FROM professor

-- 문제 : score 테이블에서 학생의 학번, 국어, 수학, 영어, 총점, 평균을 조회하기
-- 평균은 소숫점이하 2자리로 반올림하여 출력하기
-- 총점의 내림차순으로 정렬하기
SELECT * FROM score
SELECT studno, kor, math, eng, kor+math+eng 총점, ROUND((kor+math+eng)/3, 2) 평균
FROM score
ORDER BY 총점 DESC;	 

-- 근사함수 : 가장 가까운 정수값
-- ceil : 큰 근사정수
-- floor : 작은 근사정수
SELECT CEIL(12.3456), FLOOR(12.3456),CEIL(-12.3456), FLOOR(-12.3456)
-- 정수인 경우 정수 자신이 나온다.
SELECT CEIL(12), FLOOR(12),CEIL(-12), FLOOR(-12)

-- 나머지 함수 : mod. 연산자 %로도 나머지가 가능
-- 제곱 함수 : power
SELECT 21/8,21%8, MOD(21,8), POWER(3,3)

-- 날짜 관련 함수
-- 현재날짜
-- now() : 날짜와 시간 리턴
-- curdate(), current_date, current_date() : 오늘 날짜 리턴
SELECT NOW(), CURDATE(), CURRENT_DATE, CURRENT_DATE()
SELECT CURDATE()+1 -- 익일 출력(연산이 용이함)
SELECT CURDATE()-1 -- 전일 출력(연산이 용이함)

--날짜 사이의 일수 : datediff()
--DATEDIFF(날짜1, 날짜2) : 날짜1에서 날짜2의 일수 리턴
SELECT NOW(), '2025-01-01', DATEDIFF(NOW(), '2025-01-01'),
		 DATEDIFF('2025-12-31', '2025-01-01')
-- 학생의 이름, 생일, 생일부터 현재까지의 일수 조회하기
SELECT NAME, birthday, DATEDIFF(NOW(), birthday) FROM student
-- 학생의 이름, 생일, 생일부터 현재까지의 일수/365로 나누어 나이  조회하기
-- 나이는 절삭하여 정수로 출력
SELECT NAME, birthday, truncate(DATEDIFF(NOW(), birthday)/365,0) FROM student

-- 문제1
-- 학생의 이름, 생일, 현재개월수, 나이 조회
-- 개월수 : 일수 / 30 계산. 반올림하여 정수로 출력
-- 나이 : 일수/365 계산. 절삭하여 정수로 출력
-- 학년순으로 나이가 많은 순으로 정렬하여 출력하기
SELECT NAME, birthday, 
ROUND(DATEDIFF(NOW(),birthday)/30) 현재개월수, 
TRUNCATE(DATEDIFF(NOW(),birthday)/365,0) 나이
FROM student
ORDER BY grade, 나이 DESC;

-- 학생의 이름과 생년을 조회하기
-- 날짜는 yyyy-MM-dd
SELECT NAME , substr(birthday, 1, 4) 생년 FROM student
-- 학생의 이름, 생년월일, 생년,생월, 생일 조회하기
SELECT NAME, birthday, left(birthday,4) 생년,
SUBSTR(birthday,6,2) 생월, RIGHT(birthday, 2) 생일
FROM student
/*
	year(날짜)  : 년도 리턴
	month(날짜) : 월 리턴
	day(날짜)  : 일 리턴
	weekday(날짜) : 요일 리턴 0: 월 ~ 6:일 
	dayofweek(날짜) : 요일 리턴 1:일 ~ 7:토
	week(날짜) : 일년 기준 몇번째 주
	last_day(날짜) : 해당 월의 마지막 날짜
	
*/
SELECT NAME, birthday, year(birthday) 생년,
month(birthday) 생월, day(birthday) 생일
FROM student

SELECT WEEKDAY(NOW()), DAYOFWEEK(NOW()), WEEK(NOW()), LAST_DAY(NOW())

-- 문제
-- 교수이름, 입사일(hiredate), 입사년도 휴가보상일, 올해의 휴가보상일 조회하기
-- 휴가보상일 : 입사 월의 마지막 일자.
SELECT NAME, hiredate, LAST_DAY(hiredate) 입사년도휴가보상일,
	LAST_DAY(concat(YEAR(NOW()), SUBSTR(hiredate,5)))  올해의휴가보상일
FROM professor

SELECT NAME, hiredate, LAST_DAY(hiredate) 입사년도휴가보상일,
	LAST_DAY(REPLACE(hiredate, YEAR(hiredate), YEAR(NOW()))) 올해의휴가보상일
FROM professor

--문제
-- 교수 중 입사월이 1 ~ 3 월인 교수의 급여를 15% 인상예정임
-- 교수이름, 현재급여, 인상예정급여, 급여소급일 출력하기
-- 급여 소급일 : 올해 입사월의 마지막 일자
-- 인상예정급여: 반올림하여 정수로 출력
-- 인상예정 교수만 출력하기
SELECT NAME , salary, round(salary*1.15) 인상예정급여, 
	LAST_DAY(CONCAT(YEAR(NOW()), SUBSTR(hiredate,5))) 급여소급일 
FROM professor
WHERE MONTH(hiredate) BETWEEN 1 AND 3

/*
	date_add(날짜, 옵션) : 날짜 이후
	date_sub(날짜, 옵션) : 날짜 이전
	옵션
	interval n  day		: n일
	interval n  hour		: n시간
	interval n minute		: n분
*/
-- 현재 시간 기준 1일 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)
-- 현재 시간 기준 1일 이전 날짜
SELECT NOW(), DATE_sub(NOW(), INTERVAL 1 DAY)
-- 현재 시간 기준 1시간 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR)
-- 현재 시간 기준 1분 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 MINUTE)
-- 현재 시간 기준 1초 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 SECOND)
-- 현재 시간 기준 1달 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 month)
-- 현재 시간 기준 1년 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR)

-- 문제 1
-- 교수번호, 이름, 입사일, 정식입사일 조회하기
-- 정식입사일 : 입사일 3개월 이후
SELECT NO, NAME, hiredate,
 DATE_ADD(hiredate, INTERVAL 3 MONTH) 정식입사일
FROM professor

-- 문제 2
-- emp 테이블에서 정식 입사일은 입사일의 2개월 이후 다음달 1일로 한다.
-- 사원번호, 이름, 입사일, 정식입사일 출력하기
SELECT empno, ename, hiredate,
 date_add(LAST_DAY(DATE_ADD(hiredate, INTERVAL 2 MONTH)), INTERVAL 1 Day) 정식입사일
FROM emp

-- 퇴직신청가능일 : 현재일자 이전 2달 전으로 한다
-- 현재일을 퇴직일로 볼때 신청 기준일 출력하기
SELECT DATE_SUB(NOW(), INTERVAL 2 MONTH)

-- 날짜 관련 변환 함수
-- date_format : 날짜를 지정된 문자열로 변환. 날짜 => 형식화 문자열
-- str_to_date : 형식화된 문자열을 날짜로 변환. 형식화 문자열 => 날짜
/*
	형식화 문자열
	%Y : 4자리 년도
	%m : 2자리 월
	%d : 2자리 일
	%H : 0 ~ 23시
	%h : 0 ~ 12시
	%i : 분
	%s : 초
	%p : AM/PM
	%W : 요일
	%a : 약자표시 요일
*/ 
SELECT NOW(), DATE_FORMAT(now(), '%Y년%m월%d일 %H:%i:%s')
SELECT NOW(), DATE_FORMAT(now(), '%Y년%m월%d일 %h:%i:%s %p %W %a')
-- 현재의 년도 출력하기
SELECT year(NOW()) 년도 1, DATE_FORMAT(NOW(), '%Y') 년도2

--2025-12-31의 요일 출력하기
SELECT DATE_FORMAT('2025-12-31', '%W')
--2025년12월25일의 요일 출력하기
STR_TO_DATE('2025년12월25일','%Y년%m월%d일')
-- 1. 2025년12월25일 => 날짜타입으로 변환
select date_format(STR_TO_DATE('2025년12월25일','%Y년%m월%d일'), '%W')
-- 2. 바뀐 날짜타입에서 형식화 문자열로 요일 추출

-- 교수의 이름, 직책, 입사일, 정식입사일 출력하기
-- 정식입사일: 입사일의 3개월 후
-- 입사일, 정식입사일을 yyyy년 mm월 dd일의 형식으로 출력하기
SELECT NAME, POSITION , DATE_FORMAT(hiredate, '%Y년%m월%d일') 입사일,
DATE_FORMAT(date_add(hiredate, INTERVAL 3 MONTH), '%Y년%m월%d일') 정식입사일
FROM professor