-- test2
/*
	1. 학생의 이름과 지도교수번호 조회하기
   지도교수가 없는 경우 지도교수배정안됨 출력하기
*/
SELECT NAME , IFNULL(profno, '지도교수배정안됨') 지도교수 FROM student
/*
	2. major 테이블에서 코드, 코드명, build 조회하기
   build 값이 없는 경우 '단독 건물 없음' 출력하기
*/
select CODE, NAME, IFNULL(build, '단독 건물 없음') build FROM major
/*
	3. 학생의 이름, 전화번호, 지역명 조회하기
	지역명 : 지역번호가 02 : 서울, 031:경기, 032:인천 그외 기타지역
*/
SELECT NAME, tel, 
	 	case when left(tel, INSTR(tel,')')-1) = '02' then '서울'
	 		  when left(tel, INSTR(tel,')')-1) = '031' then '경기'
	 		  when left(tel, INSTR(tel,')')-1) = '032' then '인천'
	 	ELSE '그외 기타지역' END 지역명
FROM student
/*
	4. 학생의 이름, 전화번호, 지역명 조회하기
 	지역명 : 지역번호가 02,031,032: 수도권, 그외 기타지역 
*/
SELECT NAME, tel,
		if(LEFT(tel,INSTR(tel,')')-1) IN ('02','031','032'), '수도권','그외 기타지역') 지역명
FROM student		  
/*
	5. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어 
   나머지가 0이면 'A팀', 
   1이면 'B팀', 
   2이면 'C팀'으로 
   분류하여 학생번호, 이름, 학과번호, 팀 이름을 출력하여라
*/ 
SELECT studno, NAME, major1,
		case when studno%3 = 0 then 'A팀'
			  when studno%3 = 1 then 'B팀'
		ELSE 'C팀' END 팀이름
FROM student	                       
/*
	6. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
    학점은 세과목 평균이 95이상이면 A+,90 이상 A0
                        85이상이면 B+,80 이상 B0
                        75이상이면 C+,70 이상 C0
                        65이상이면 D+,60 이상 D0
     인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.                   
    으로 출력한다.
*/      
SELECT *, 
	if((kor+math+eng)/3 >= 95, 'A+',
	if((kor+math+eng)/3 >= 90, 'A0',
	if((kor+math+eng)/3 >= 85, 'B+',
	if((kor+math+eng)/3 >= 80, 'B0',
	if((kor+math+eng)/3 >= 75, 'C+',
	if((kor+math+eng)/3 >= 70, 'C0',
	if((kor+math+eng)/3 >= 65, 'D+',
	if((kor+math+eng)/3 >= 60, 'D0', 'F')))))))) 학점,
	if((kor+math+eng)/3 >= 60 , 'PASS','FAIL') 인정여부
FROM score
GROUP BY studno
/*
 		7. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D그룹을 출력하기
      160 미만 : A그룹
      160 ~ 169까지 : B그룹
      170 ~ 179까지 : C그룹
      180이상       : D그룹
*/
SELECT NAME, height, 
 		case when height < 160 then 'A그룹'
		 	  when height BETWEEN 160 AND 169 then 'B그룹'
			  when height BETWEEN 170 AND 179 then 'C그룹'
		ELSE 'D그룹' END 키그룹
FROM student       
/*8. 교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
     401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
     단 등급의 오름차순으로 정렬하기
*/
SELECT NAME, salary, 
 		case when salary <= 200 then '4급'
		 	  when salary BETWEEN 201 AND 300 then '3급'
			  when salary BETWEEN 301 AND 400 then '2급'
		ELSE '1급' END 등급
FROM professor
ORDER BY 등급;
/*
	9 학생의 학년별 키와 몸무게 평균 출력하기.
   학년별로 정렬하기. 
   평균은 소숫점2자리 반올림하여 출력하기
*/ 
SELECT concat(grade,'학년') grade, round(AVG(height),2) 키평균, round(AVG(weight),2) 몸무게평균
FROM student
GROUP BY grade
/*
	10. 평균키가 170이상인  전공1학과의 
    가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 
*/ 
SELECT major1, MAX(height) 최대값, MIN(height) 최솟값, AVG(height) 평균 
FROM student
GROUP BY major1
having AVG(height)>=170
 
/*
	11.  사원의 직급(job)별로 평균 급여를 출력하고, 
   평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라
*/
SELECT job, AVG(salary),
	if(AVG(salary)>=1000, '우수','보통') 급여등급
FROM emp
GROUP BY job
/*
	12. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 
    평균 몸무게의 내림차순으로 정렬하여 출력하기
*/ 
SELECT major1, COUNT(*) 인원수,
 concat(round(AVG(weight),2), '(kg)') 평균몸무게
FROM student
GROUP BY major1
ORDER BY 평균몸무게 DESC;
-- 13. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기
SELECT deptno 학과번호, COUNT(*) 인원수
FROM professor
GROUP BY deptno
HAVING 인원수 <=2
/*
	14. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기
*/
SELECT 
	case when LEFT(tel, INSTR(tel, ')')-1) = '02' then '서울'
		  when LEFT(tel, INSTR(tel, ')')-1) = '031' then '경기'
		  when LEFT(tel, INSTR(tel, ')')-1) = '051' then '부산'
		  when LEFT(tel, INSTR(tel, ')')-1) = '052' then '경남'
	ELSE '그외지역' END 지역, concat(COUNT(*)+"", '명') 인원수
FROM student
GROUP BY 지역
/*
	15. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기. 가로출력
*/
SELECT  CONCAT(COUNT(*)+'', '건수') 전체,
	SUM(if(left(tel, INSTR(tel, ')')-1) = '02',1,0)) '서울',
	SUM(if(left(tel, INSTR(tel, ')')-1) = '031',1,0)) '경기',
	SUM(if(left(tel, INSTR(tel, ')')-1) = '051',1,0)) '부산',
	SUM(if(left(tel, INSTR(tel, ')')-1) = '052',1,0)) '경남',
	SUM(if(left(tel, INSTR(tel, ')')-1) NOT IN ('02','031','051','052'),1,0)) '그외'
FROM student
/*
	16. 교수들의 번호,이름,급여,보너스, 총급여(급여+보너스)
     급여많은순위,보너스많은순위,총급여많은 순위 조회하기
     총급여순위로 정렬하여 출력하기. 보너스없는 경우 0으로 함
*/
SELECT NO, NAME, salary, IFNULL(bonus, 0) bonus, salary+IFNULL(bonus,0) total,
		 RANK() OVER(ORDER BY salary DESC) s_lank, RANK() OVER(ORDER BY bonus DESC) b_lank,
		 RANK() OVER(ORDER BY total DESC) t_lank
FROM professor
ORDER BY t_lank
/*
	17.  교수의 직급,직급별 인원수,급여합계,보너스합계,급여평균,보너스평균 출력하기
    단 보너스가 없는 교수도 평균에 포함되도록 한다.
    급여평균이 높은순으로 정렬하기
*/
SELECT POSITION, concat(COUNT(*)+"",'명') 인원수, SUM(salary) 급여합계, 
	    SUM(IFNULL(bonus,0)) 보너스합계, AVG(salary) 급여평균, AVG(IFNULL(bonus,0)) 보너스평균
FROM professor
GROUP BY position
ORDER BY 급여평균
-- 18. 1학년 학생의 인원수,키와 몸무게의 평균 출력하기
SELECT grade, concat(COUNT(*)+"",'명') 인원수, ROUND(AVG(height),2) 키평균, ROUND(AVG(weight),2) 몸무게평균
FROM student
GROUP BY grade
HAVING grade =1
-- 19. 학생의 점수테이블(score)에서 수학 평균,수학표준편차,수학분산 조회하기
SELECT AVG(math) 수학평균, STDDEV(math) 수학표준편차, VARIANCE(math) 수학분산
FROM score
-- 20. 교수의 월별 입사 인원수를 출력하기
SELECT concat(month(hiredate),'월'), concat(COUNT(*)+"",'명') 인원수
FROM professor
GROUP BY MONTH(hiredate)