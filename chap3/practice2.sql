/*
	기타함수	
*/
-- ifnull(컬럼, 기본값) : 컬럼의 값이 null 인경우 기본값을 치환
-- 교수의 이름, 직급, 급여, 보너스, 급여+보너스 조회하기
-- ifnull(bonus,0) : bonus 컬럼의 값이 null인 경우 0으로 치환
SELECT NAME, POSITION, salary, bonus,salary+IFNULL(bonus, 0) 통상임금 
FROM professor
--IFNULL(salary+bonus, salary) : salary+bonus의 결과가 NULL 경우 salary로 치환
SELECT NAME, POSITION, salary, bonus,IFNULL(salary+bonus, salary) 통상임금 
FROM professor

-- 교수의 이름, 직책, 급여, 보너스 출력하기
-- 보너스가 없는 경우는 보너스 없음으로 출력하기
SELECT NAME, POSITION, salary, IFNULL(bonus, '보너스 없음') bonus FROM professor

-- 학생의 이름(name)과 지도교수의 번호(profno) 출력하기
-- 단 지도교수가 없는 경우 9999로 출력하기
SELECT NAME , IFNULL(profno, '9999') profno FROM student

/*
	조건함수 : if, case
*/
-- if 조건함수 : if(조건문, '참'값, '거짓'값)
-- 1학년 학생인 경우는 신입생으로 1학년 학생이 아닌 경우는 재학생으로 출력하기
SELECT NAME, grade, if(grade = 1, '신입생','재학생') grade FROM student

-- 교수의 이름, 학과번호, 학과명 출력하기
-- 학과명은 학과번호가 101 : 컴퓨터공학, 나머지는 공란으로 출력
SELECT NAME, deptno, if(deptno='101', '컴퓨터공학', '') 전공
FROM professor
-- 교수의 이름, 학과번호, 학과명 출력하기
-- 학과명은 학과번호가 101 : 컴퓨터공학, 나머지는 그외학과으로 출력
SELECT NAME,deptno, if(deptno='101', '컴퓨터공학', '그외학과') 전공
FROM professor
-- 학생의 주민번호 7번째 자리가 1, 3인 경우 남자, 2,4인 경우 여자로 출력하기
SELECT NAME, jumin,
	if(SUBSTR(jumin, 7, 1) = 1, '남자',
	if(SUBSTR(jumin, 7, 1) = 2, '여자',
	if(SUBSTR(jumin, 7, 1) = 3, '남자', '여자'))) 성별
FROM student
-- in 사용
SELECT NAME, jumin, if(SUBSTR(jumin, 7,1) IN (1,3) , '남자', '여자')
FROM student

-- 학생의 주민번호 7번째 자리가 1,3인 경우 남자, 2,4인 경우 여자로
-- 그외는 주민번호 오류로 출력하기
SELECT NAME, jumin, 
	if(SUBSTR(jumin, 7,1) IN (1,3) , '남자',
	if(SUBSTR(jumin, 7,1) IN (2,4), '여자', '오류')) 성별
FROM student

--문제
-- 교수이름, 학과번호, 학과명 출력하기
-- 학과명 : 101 컴퓨터공학, 102:멀티미디어공학, 201:기계공학, 그외: 그외학과
SELECT NAME, deptno, 
	if(deptno = '101', '컴퓨터공학',
	if(deptno = '102', '멀티미디어공학',
	if(deptno = '201', '기계공학', '그외학과'))) 전공 FROM professor
	

/*
	case 조건문
	
 1)case 컬럼명 when 값1 then 문자열
				   when 값2 then 문자열
				   ...
				   else 문자열 end
 2)case when 조건문1 then 문자열
 		  when 조건문2 then 문자열
		  ...
		  else 문자열 end;	
*/

-- 교수이름, 학과번호, 학과명 출력하기
-- 학과명 : 101 컴퓨터공학, 그외는 공란	
SELECT NAME , deptno,
	case deptno when 101 then '컴퓨터공학'
	ELSE '' END 학과명
FROM professor
-- 교수이름, 학과번호, 학과명 출력하기
-- 학과명 : 101 컴퓨터공학, 그외는 그외학과 출력
SELECT NAME , deptno,
	case deptno when 101 then '컴퓨터공학'
	ELSE '그외학과' END 학과명
FROM professor
-- 교수이름, 학과번호, 학과명 출력하기
-- 학과명 : 101 컴퓨터공학, 102:멀티미디어공학, 201:기계공학, 그외: 그외학과
SELECT NAME, deptno, 
	case deptno when '101' then '컴퓨터공학'
				   when '102' then '멀티미디어공학'
					when '201' then '기계공학'
	ELSE '그외학과' END  전공 
FROM professor

-- 교수이름, 학과번호, 대학명 출력하기
-- 대학명 : 101, 102, 201 : 공과대학, 그외는 그외대학 출력하기
-- if문
SELECT NAME , deptno,
	if(deptno IN (101,102,201), '공과대학', '그외대학') 대학
FROM professor
-- case문
SELECT NAME, deptno,
	case deptno when 101 then '공과대학'
					when 102 then '공과대학'
					when 201 then '공과대학'
	ELSE '그외대학' END 대학
FROM professor

SELECT NAME, deptno,
	case when deptno IN(101,102,201) then '공과대학'
	ELSE '그외대학' END 대학
FROM professor

--문제
--학생의 이름, 주민번호, 출생분기를 출력하기
--출생분기 : 주민번호기준 1~3:1분기, 4~6: 2분기, 7~9: 3분기, 10~12:4분기
SELECT NAME, jumin,
	case when SUBSTR(jumin,3,2) BETWEEN '01' AND '03' then '1분기'
		  when SUBSTR(jumin,3,2) BETWEEN '04' AND '06' then '2분기'
		  when SUBSTR(jumin,3,2) BETWEEN '07' AND '09' then '3분기'
	ELSE '4분기' END 출생분기
FROM student
-- 정수형으로도 가능하나, 조건문 결과의 자료형에 맞게 설정하는 것을 추천

-- 문제
-- 학생의 이름, 생일(date), 출생분기를 출력하기
--출생분기 : 생일기준 1~3:1분기, 4~6: 2분기, 7~9: 3분기, 10~12:4분기
SELECT NAME, birthday,
	case when MONTH(birthday) BETWEEN 1 AND 3 then '1분기'
		  when MONTH(birthday) BETWEEN 4 AND 6 then '2분기'
		  when MONTH(birthday) BETWEEN 7 AND 9 then '3분기'
	ELSE '4분기' END 출생분기
FROM student

/*
	그룹함수 : 여러개의 행의 정보 이용하여 결과 리턴 함수
	select 컬럼명 |* from 테이블명
	[where 조건문]
	[group by 컬럼명] => 레코드를 그룹화 하기위한 기준 컬럼 설정
								group by 구문이 없는 경우 모든 레코드가 하나의 그룹으로 처리
	[having 조건문]
	[order by 컬럼명||별명||컬럼순서 [asc|desc]]
*/
-- count() 레코드의 건수 리턴, null 값은 건수에서 제외됨
-- 교수의 전체 인원수, 보너스를 받는 인원수 조회하기
-- count(bonus) : bonus의 값이 null이 아닌 레코드수
SELECT COUNT(*), COUNT(bonus) FROM professor


--학생 전체 인원과 지도교수를 배정받은 학생의 인원수를 조회하기
SELECT COUNT(*) 학생인원수, COUNT(profno) profyes FROM student

--학생 중 전공 1 학과가 101번인 학과의 속한 학생의 인원수 조회
SELECT COUNT(*) FROM student
WHERE major1 = 101

-- 1학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT COUNT(*) , COUNT(profno) FROM student
WHERE grade = 1
-- 2학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT COUNT(*) , COUNT(profno) FROM student
WHERE grade = 2
-- 3학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT COUNT(*) , COUNT(profno) FROM student
WHERE grade = 3
-- 4학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT COUNT(*) , COUNT(profno) FROM student
WHERE grade = 4

-- 학년별 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT grade, COUNT(*), COUNT(profno) FROM student
GROUP BY grade

-- 전공1학과별 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기
SELECT major1, COUNT(*), COUNT(profno) FROM student
GROUP BY major1

-- 지도교수가 배정되지 않은 학년의 전체 인원수를 출력
SELECT grade, COUNT(*) FROM student
GROUP BY grade
HAVING COUNT(profno) = 0

-- 합계 : sum, 평균 : avg
-- 교수들의 급여 합계와 보너스 합계를 출력하기
SELECT SUM(salary), SUM(bonus) FROM professor
-- 교수들의 급여 평균과 보너스 평균 출력하기
-- avg(bonus) : bonus를 받는 교수들의 평균
-- AVG(ifnull(bonus,0)) : bonus를 받지 않아도 평균 구할때 포함
SELECT COUNT(*),SUM(salary), SUM(bonus), AVG(salary), AVG(ifnull(bonus,0)) 
FROM professor

-- 문제
-- 교수의 부서코드, 부서별 인원수, 급여합계, 보너스합계, 급여평균, 보너스평균 출력하기
-- 단 보너스가 없는 교수도 평균에 포함되도록 한다.
SELECT deptno, COUNT(*) 인원수, SUM(salary) 급여합계,
SUM(IFNULL(bonus,0)) 보너스합계, AVG(salary) 급여평균, AVG(IfNULL(bonus,0)) 보너스평균 
FROM professor
GROUP BY deptno
ORDER BY deptno

-- 문제
-- 학년별 학생의 인원수, 키와 몸무게의 평균 출력하기
-- 학년순으로 정렬하기
SELECT grade,COUNT(*), AVG(height) 키평균, AVG(weight) 몸무게평균
FROM student
GROUP BY grade
ORDER BY grade;

-- 문제
-- 부서별 교수의 급여합, 보너스합, 연봉합, 급여평균, 보너스평균, 연봉평균 출력하기
-- 연봉 : 급여*12+ 보너스
-- 보너스가 없는 경우는 0으로 처리함
-- 평균 출력시 소숫점 이하 2자리로 반올림하여 출력하기
SELECT deptno, COUNT(*), SUM(salary) 급여합, SUM(ifnull(bonus,0)) 보너스합,
	    SUM(salary*12+IFNULL(bonus,0)) 연봉합, ROUND(AVG(salary),2) 급여평균,
		 round(AVG(ifnull(bonus,0)),2) 보너스평균, ROUND(AVG(salary*12+IFNULL(bonus,0)),2) 연봉평균
FROM professor
GROUP BY deptno

/*
	최소값, 최대값 : min, max
*/
-- 전공1학과별 가장 키가 큰학생의 키와, 작은키값 출력하기
SELECT major1, MAX(height), MIN(height)
FROM student
GROUP BY major1

-- 교수 중 가장 높은 급여를  출력하기
SELECT MAX(salary), MIN(salary) FROM professor

/*
	표준편차 : stddev
	분산		: variance
*/
-- 교수들의 평균 급여, 급여의 표준편차, 분산을 출력하기
SELECT AVG(salary), STDDEV(salary), VARIANCE(salary) FROM professor

-- 학생의 점수테이블(score)에서 합계 평균, 합계표준편차, 합계분산 조회하기
SELECT AVG(kor+math+eng), STDDEV(kor+math+eng), VARIANCE(kor+math+eng)
FROM score

-- having : group 조건
-- 학과별 가장 키가 큰학생의 키와, 가장 작은 학생의 키, 학과별평균키를 출력하기
-- 평균키가 170 이상인 학과정보만 출력
SELECT major1, MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY major1
HAVING AVG(height) >= 170
-- 교수테이블에서 학과별 평균급여가 350이상인 부서의 코드와 평균급여를 출력하기
SELECT deptno, AVG(salary) FROM professor
GROUP BY deptno
HAVING AVG(salary) >= 350

-- 주민번호 기준으로 남, 여학생의 최대키, 최소키, 평균키를 조회
SELECT if(SUBSTR(jumin,7,1) IN (1,3), '남자', '여자') 성별,
MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY /*성별*/ if(SUBSTR(jumin,7,1) IN (1,3), '남자', '여자')
-- Oracle에서는 alias를 group by에 사용할 수 없다.

-- group by에서 설정된 컬럼만 select 컬럼으로 사용 가능
SELECT NAME, AVG(salary) FROM professor -- 정상처리되나 Name에 의미가 없다
GROUP BY deptno

--학생의 생일의 월별 인원수를 출력하기
SELECT concat(month(birthday),'월') 월, COUNT(*) 인원수
FROM student
GROUP BY MONTH(birthday)

SELECT CONCAT(COUNT(*)+'', '건수') 전체,
	SUM(if(MONTH(birthday)=1,1,0)) '1월',
	SUM(if(MONTH(birthday)=2,1,0)) '2월',
	SUM(if(MONTH(birthday)=3,1,0)) '3월',
	SUM(if(MONTH(birthday)=4,1,0)) '4월',
	SUM(if(MONTH(birthday)=5,1,0)) '5월',
	SUM(if(MONTH(birthday)=6,1,0)) '6월',
	SUM(if(MONTH(birthday)=7,1,0)) '7월',
	SUM(if(MONTH(birthday)=8,1,0)) '8월',
	SUM(if(MONTH(birthday)=9,1,0)) '9월',
	SUM(if(MONTH(birthday)=10,1,0)) '10월',
	SUM(if(MONTH(birthday)=11,1,0)) '11월',
	SUM(if(MONTH(birthday)=12,1,0)) '12월'
FROM student
-- 그룹함수 전
SELECT NAME, birthday,
	if(MONTH(birthday)=1,1,0) '1월',
	if(MONTH(birthday)=2,1,0) '2월',
	if(MONTH(birthday)=3,1,0) '3월',
	if(MONTH(birthday)=4,1,0) '4월',
	if(MONTH(birthday)=5,1,0) '5월',
	if(MONTH(birthday)=6,1,0) '6월',
	if(MONTH(birthday)=7,1,0) '7월',
	if(MONTH(birthday)=8,1,0) '8월',
	if(MONTH(birthday)=9,1,0) '9월',
	if(MONTH(birthday)=10,1,0) '10월',
	if(MONTH(birthday)=11,1,0) '11월',
	if(MONTH(birthday)=12,1,0) '12월'
FROM student

/*
	순위 지정함수 : rank() over(정렬방식)
	누계 함수 : sum() over(정렬방식)	
*/

-- 교수의 번호, 이름, 급여를 많이 받는 순위를 출력
SELECT NO, NAME, salary, RANK() OVER(ORDER BY salary DESC) rank FROM professor

-- 교수의 번호, 이름, 급여를 많이 받는 순위를 오름차순으로 출력
SELECT NO, NAME, salary, RANK() OVER(ORDER BY salary) rank FROM professor

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 총점기준점수 출력하기
SELECT *, kor+math+eng 총점, RANK() OVER(ORDER BY 총점 DESC) 둥수 FROM score

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 총점기준등수, 과목별 등수0 출력하기
SELECT *, kor+math+eng 총점, RANK() OVER(ORDER BY 총점 DESC) 둥수,
		 RANK() OVER(ORDER BY kor DESC) 국어등수,
		 RANK() OVER(ORDER BY math DESC) 수학등수,
		 RANK() OVER(ORDER BY eng DESC) 영어등수
FROM score

-- 교수의 이름, 급여, 보너스, 급여누계 조회하기
SELECT NAME, salary, bonus, SUM(salary) OVER(ORDER BY salary DESC) 급여누계 
FROM professor

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 총점누계, 총점 등수 조회
SELECT *, kor+math+eng 총점, SUM(kor+math+eng) OVER(ORDER by kor+math+eng DESC) 총점누계,
		 RANK() OVER(ORDER BY kor+math+eng desc) 총점등수
FROM score 

-- 부분합 : rollup.
-- 국어, 수학의 합계 합을 구하기
SELECT kor, math, SUM(kor+math)
FROM score
GROUP BY kor, math WITH ROLLUP

--학년별, 지역, 몸무게평균, 키평균
SELECT grade, SUBSTR(tel,1,INSTR(tel, ')')-1) 지역, AVG(weight) 몸무게평균,
		 AVG(height) 키평균
FROM student
GROUP BY grade, 지역 WITH ROLLUP

SELECT grade, AVG(weight), AVG(height) FROM student
GROUP BY grade

--학년별, 성별 몸무게 평균, 키평균 조회, 학년별로도 평균조회하기
SELECT grade, if(SUBSTR(jumin, 7,1) IN (1,3), '남자','여자') 성별,
		 AVG(weight) 몸무게평균, AVG(height) 키평균 
FROM student
GROUP BY grade, 성별 WITH ROLLUP

--mariadb에서는 실행 안됨
SELECT grade, if(SUBSTR(jumin, 7,1) IN (1,3), '남자','여자') 성별,
		 AVG(weight) 몸무게평균, AVG(height) 키평균 
FROM student
GROUP BY grade, 성별 WITH cube

