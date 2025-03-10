/*
   단일행 함수
    기타함수
    - ifnull(컬럼,기본값) : 컬럼의 값이 null인 경우 기본값으로 치환
                            오라클 : nvl(컬럼,기본값)
    - 조건함수 : if, case
	      if(조건문,참,거짓) : 중첩가능
	                         오라클 : decode(조건문,참,거짓)
	      case 컬럼명 when 값 then 출력값 ...
			     [else 값] end
	      case when 조건문 then 출력값 ...
			     [else 값] end
   
	그룹함수 : 여러개의 레코드에서 정보 얻어 리턴			     
	  건수 : count(*) => 조회된 레코드의 건수
	         count(컬럼명) => 컬럼의 값이 null이 아닌 레코드의 건수
	  합계 : sum(컬럼명)
	  평균 : avg(컬럼명) => 컬럼의 값이 null이 아닌 경우만 평균의 대상이됨.
	                        ifnull 함수 이용 전체 평균으로 처리
	  가장큰값,작은값 : max(컬럼),min(컬럼)
	  표준편차,분산 : stddev(컬럼),variance(컬럼명)
	
	순위,누계 지정함수
	  - rank() over(정렬방식)
	  - sum(컬럼) over(정렬방식)                        
	  
	group by : 그룹함수 사용시, 그룹화 되는 기준의 컬럼. 
	           group by에서 사용된 컬럼을 select  구문에서 조회해야 함.
	having 조건문 : 그룹함수의 조건문           
	
	rollup : 부분합계
	
	select 구문 구조

	select 컬럼명 || * || 상수값 || 연산 || 단일행함수
	from 테이블명
	where 조건문 => 레코드의 선택
	group by => 그룹화의 기준이 되는 컬럼
	having 조건문 => 그룹함수 조건문
	order by 컬럼명 || 별명 || 조회되는 컬럼의 순서
*/
SELECT NOW()

/*
   Join : 여러개의 테이블에서 조회
*/
-- cross join : 두개 테이블을 조인. m*n개의 레코드가 생성됨. 사용시 주의 요망
SELECT * FROM emp -- 14r,9 c
SELECT * FROM dept -- 5r, 3c
--mariadb 방식
SELECT * FROM emp, dept -- 14*5=70R, 9+3=12 c
--ansi  방식
SELECT * FROM emp CROSS join dept -- 14*5=70R, 9+3=12 c

-- 사원번호(emp.empno),사원명(emp.ename),직책(emp.job),
-- 부서코드(emp.deptno),부서명(dept.dname) cross join 하기
-- 중복된 컬럼은 테이블명을 표시해야함
-- 중복된 컬럼은 테이블명을 표시하지 않아도 됨.
SELECT empno,ename,job,emp.deptno,dname 
FROM emp,dept
SELECT empno,ename,job,e.deptno,dname 
FROM emp e,dept d -- 테이블명에 별명 설정
SELECT e.empno,e.ename,e.job,e.deptno,d.deptno,d.dname 
FROM emp e,dept d -- 테이블명에 별명 설정
/*
    등가조인 : equi join
         조인컬럼을 이용하여 필요한 레코드만 조회.
         조인컬럼의 조건을 = 인 경우
*/
-- 사원번호,사원명,직책,부서코드,부서명 조회하기
-- mariadb 방식 
SELECT e.empno, e.ename, e.job,e.deptno,d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno  -- 조인컬럼
-- ansi 방색
SELECT e.empno, e.ename, e.job,e.deptno,d.deptno, d.dname
FROM emp e join dept d
on e.deptno = d.deptno  -- 조인컬럼
-- 학생 테이블과 학과(major)테이블을 사용하여 학생이름,전공학과번호,전공학과이름 조회하기
DESC student
DESC major
-- mariadb 방식
SELECT s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code

-- ansi 방식
SELECT s.name, s.major1, m.name
FROM student s join major m
on s.major1 = m.code

-- 문제
-- 학생의 이름, 지도교수번호,지도교수이름 출력하기
SELECT s.name, s.profno, p.name
FROM student s, professor p
WHERE s.profno = p.no

SELECT s.name, s.profno, p.name
FROM student s join professor p
on s.profno = p.no

-- 문제 학생테이블에서 학번,이름, score 테이블에서 학번에 해당하는 국어,수학,영어, 총점
-- 총점이 많은 순으로 조회하기
SELECT s1.studno, s1.name, s2.kor,s2.math,s2.eng, (kor+math+eng) 총점
FROM student s1, score s2
WHERE s1.studno = s2.studno
ORDER BY 총점 DESC

SELECT s1.studno, s1.name, s2.kor,s2.math,s2.eng, (kor+math+eng) 총점
FROM student s1 join score s2
on s1.studno = s2.studno
ORDER BY 총점 DESC

-- 학생의 이름, 학과이름, 지도교수이름 조회하기
-- mariadb 방식
SELECT s.`name`,m.`name`,p.`name`
FROM student s, major m, professor p
WHERE s.major1 = m.code 
 AND  s.profno = p.no

-- ansi 방식
SELECT s.`name`,m.`name`,p.`name`
FROM student s join major m
ON s.major1 = m.code join professor p
ON s.profno = p.no
 
-- 문제
-- emp 테이블과 p_grade 테이블을 조회하여, 사원의 이름과, 직급,현재연봉, 해당직급의
-- 연봉 하한, 연봉상한 금액 출력하기. 현재 연봉은 (급여*12+보너스) * 10000 으로 한다
SELECT * FROM p_grade
SELECT e.ename,e.job,(salary*12+IFNULL(bonus,0))*10000 현재연봉, 
s_pay 연봉하한, e_pay 연봉상한
FROM emp e, p_grade p
WHERE e.job = p.`position`

SELECT e.ename,e.job,(salary*12+IFNULL(bonus,0))*10000 현재연봉, 
s_pay 연봉하한, e_pay 연봉상한
FROM emp e join p_grade p
on e.job = p.`position`

-- 장성태 학생의 학번,이름,전공1학과번호,전공1학과이름, 학과위치 출력하기
-- student, major 테이블 조인하기
SELECT s.studno, s.`name`,s.major1, m.`name`,m.build
FROM student s, major m
WHERE s.major1 = m.code AND s.name = '장성태'

SELECT s.studno, s.`name`,s.major1, m.`name`,m.build
FROM student s join major m
on s.major1 = m.code 
where s.name = '장성태'

-- 몸무게 80키로 이상인 학생의 학번, 이름, 체중, 학과이름, 학과위치 출력하기
SELECT s.studno,s.name,s.weight, m.`name`,m.build
FROM student s, major m
WHERE s.major1 = m.code
 AND weight >= 80

SELECT s.studno,s.name,s.weight, m.`name`,m.build
FROM student s join major m
on s.major1 = m.code
where  weight >= 80

-- 학생의 학번,이름, score 테이블에서 학번에 해당하는  점수를 조회하기
-- 1학년 학생의 정보 조회하기
SELECT s.studno,s.name, s2.* 
FROM student s, score s2
WHERE s.studno = s2.studno
 AND grade = 1

SELECT s.studno,s.name, s2.* 
FROM student s join score s2
on s.studno = s2.studno
where grade = 1
/*
    비등가 조인 : non equi join
        조인컬럼의 조건이 =이 아닌 경우. 범위값으로 조인함
*/
SELECT * FROM guest -- 고객테이블
SELECT * FROM pointitem -- 상품테이블
--고객명,고객 포인트과 고객이 포인트로 받을 수 있는 상품명을 조회하기 
SELECT g.name,g.point, p.name 
FROM guest g, pointitem p
WHERE g.`point` BETWEEN p.spoint AND p.epoint

SELECT g.name,g.point, p.name 
FROM guest g join pointitem p
on g.`point` BETWEEN p.spoint AND p.epoint


-- 고객은 자기 포인트 보다 낮은 포인트의 상품을 선택할 수 있다고 가정할때 
-- 외장 하드를 선택할 수 있는 고객의
--고객명,고객 포인트과 고객이 포인트로 받을 수 있는 상품명,시작포인트, 종료포인트을 조회하기 
SELECT g.name, g.point,p.name,p.spoint,p.epoint
FROM guest g, pointitem p
WHERE g.`point` >= p.spoint AND p.name = '외장하드'

SELECT g.name, g.point,p.name,p.spoint,p.epoint
FROM guest g join pointitem p
on g.`point` >= p.spoint 
where p.name = '외장하드'

-- 낮은 포인트의 상품을 선택할 수 있다고 할때, 개인별로 가져갈수 있는 상품의
-- 갯수를 조회하기. 
-- 상품의 갯수로 정렬하기
SELECT g.name, COUNT(*)
FROM guest g , pointitem p
WHERE  g.`point` >= p.spoint 
GROUP by g.name
ORDER BY COUNT(*),g.name

-- 상품의 갯수가 2개이상인 정보 조회하기
SELECT g.name, COUNT(*)
FROM guest g , pointitem p
WHERE  g.`point` >= p.spoint 
GROUP by g.name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*),g.name

SELECT * FROM scorebase
-- 학생의 학번,이름,국어,수학,영어,총점,평균,학점 출력하기
-- 평균은 반올림하여 정수로 표현하기. 학점순 정렬하기
-- student s1: 학번,이름
-- score   s2: 국어,수학,영어,총점,평균
-- scorebase s3 : 학점
SELECT s1.studno,s1.name, s2.kor,s2.math,s2.eng, (kor+math+eng) 총점,
      ROUND((kor+math+eng)/3) 평균,s3.grade
FROM student s1, score s2, scorebase s3 
WHERE s1.studno = s2.studno
  AND ROUND((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point   
ORDER BY s3.grade    
-- ansi 방식
SELECT s1.studno,s1.name, s2.kor,s2.math,s2.eng, (kor+math+eng) 총점,
      ROUND((kor+math+eng)/3) 평균,s3.grade
FROM student s1 inner JOIN  score s2
ON s1.studno = s2.studno  inner JOIN scorebase s3 
on ROUND((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point   
ORDER BY s3.grade    

/*
   self join : 같은 테이블의 다른컬럼들을 조인 컬럼으로 사용함.
               반드시 테이블의 별명을 설정해야함
               반드시 모든 컬럼에 테이블의 별명을 설정해야함
*/
SELECT * FROM emp
-- mgr : 상사의 사원번호
-- 사원테이블에서 사원번호,이름,상사의사원번호, 상사의이름 조회하기
SELECT e1.empno, e1.ename, e2.empno,e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno

SELECT e1.empno, e1.ename, e2.empno,e2.ename
FROM emp e1 join emp e2
on e1.mgr = e2.empno

SELECT * FROM major
-- code : 전공학과코드
-- part : 상위학부코드
-- major 테이블에서 학과코드,학과명, 상위학과코드, 상위학과명 조회하기
SELECT m1.code, m1.name,m1.part, m2.name
FROM major m1, major m2
WHERE m1.part = m2.code

-- 교수번호,이름,입사일, 입사일이 빠른 사람을 조회하기
--  입사일이 빠른 순으로 정렬
SELECT p1.no,p1.name,p1.hiredate, p2.no,p2.name,p2.hiredate
FROM professor p1, professor p2
WHERE p1.hiredate > p2.hiredate
ORDER BY p1.name

-- 문제
-- 교수번호,이름,입사일, 입사일이 빠른 사람의 인원수 조회하기
--  입사일이 빠른 순으로 정렬
SELECT p1.no,p1.`name`,p1.hiredate,COUNT(*)
FROM professor p1, professor p2
WHERE p1.hiredate > p2.hiredate
GROUP BY p1.no 
ORDER BY p1.hiredate

SELECT p1.no,p1.`name`,p1.hiredate,COUNT(*)
FROM professor p1, professor p2
WHERE p1.hiredate > p2.hiredate
GROUP BY p1.name 
ORDER BY p1.hiredate

SELECT p1.no,p1.`name`,p1.hiredate,COUNT(*)
FROM professor p1 join professor p2
on p1.hiredate > p2.hiredate
GROUP BY p1.name 
ORDER BY p1.hiredate

-- 문제
-- 교수번호,이름,입사일,입사일이 같은 사람의 인원수 조회하기
-- 입사일이 빠른 순으로 정렬하기
SELECT  p1.no,p1.`name`,p1.hiredate,p2.hiredate,p2.name
FROM professor p1, professor p2
WHERE p1.hiredate = p2.hiredate
ORDER by p1.hiredate

SELECT  p1.no,p1.`name`,p1.hiredate,COUNT(*)
FROM professor p1, professor p2
WHERE p1.hiredate = p2.hiredate
GROUP BY p1.no
ORDER by p1.hiredate

/*
   inner join : 조인컬럼의 조건과 맞는 레코드만 조회. 
     -- equi join
     -- non equi join
     -- self join
*/
SELECT * FROM major  -- 11r

SELECT m1.code,m1.name,m1.part,m2.name  -- 9r
FROM major m1, major m2
WHERE m1.part = m2.code

/*
   outer join : 조인컬럼의 조건이 맞지 않아도, 한쪽, 양쪽 레코드 조회
     left outer join  : 왼쪽 테이블의 모든 레코드를 조회
     right outer join : 오른쪽 테이블의 모든 레코드를 조회
     full outer join  : 양쪽 테이블의 모든 레코드를 조회. union 방식으로 구현해야 함
*/
-- 학생의 이름과 지도교수이름 출력하기
SELECT s.name,p.`name` FROM student s, professor p  -- inner join
WHERE s.profno = p.no

-- 학생의 이름과 지도교수이름 출력하기
-- 지도교수가 없는 학생도 조회 
SELECT s.name,p.`name` 
FROM student s LEFT OUTER join professor p  
on s.profno = p.no

-- 학생의 학번,이름,지도교수이름 조회하기
-- 지도교수가 없는 학생도 조회되도록하고, 지도교수가 없는 경우 지도교수없음 출력하기
SELECT s.studno, s.name,ifnull(p.name,'지도교수없음')
FROM student s LEFT OUTER JOIN professor p
on s.profno = p.no

-- 학생의 학번,이름,지도교수이름 조회하기
-- 지도학생이 없는 교수도 조회되도록 하기.
-- 지도학생이 없는 경우 지도학생 없음 내용을 출력하기
SELECT s.studno, ifnull(s.name,"지도학생없음"),p.name
FROM student s right OUTER JOIN professor p
on s.profno = p.no

SELECT s.studno, ifnull(s.name,"지도학생없음"),p.name
FROM student s right JOIN professor p
on s.profno = p.no

------------------------
-- 오라클 구현 방식
------------------------
-- left outer join
SELECT s.studno, ifnull(s.name,"지도학생없음"),p.name
FROM student s , professor p
where s.profno = p.no(+)   -- 왼쪽의 테이블의 모든 조회

-- right outer join
SELECT s.studno, ifnull(s.name,"지도학생없음"),p.name
FROM student s , professor p
where s.profno(+) = p.no   -- 오른쪽의 테이블의 모든 조회

-- full outer join : union으로 구현
-- 학생의 이름,지도교수 이름을 조회하기
-- 지도교수가 없는 학생정보와,지도학생이 없는 교수정보도 조회하기
SELECT s.`name`,p.name
FROM student s FULL OUTER join professor p  ==> 오류 발생
ON s.profno = p.no

SELECT s.`name`,p.name
FROM student s left join professor p
ON s.profno = p.no
union
SELECT s.`name`,p.name
FROM student s right join professor p
ON s.profno = p.no

-- 문제1
--  emp, p_grade 테이블을 조인하여
-- 사원이름, 직급, 현재연봉, 해당직급의 연봉하한,연봉상한 조회하기
-- 연봉 : (급여*12+보너스)*10000. 보너스가 없는 경우 0으로 처리하기
-- 단 모든 사원을 출력하기
SELECT e.ename, e.job, (salary*12+IFNULL(bonus,0)) * 10000 현재연봉,
       p.s_pay, p.e_pay
FROM emp e LEFT join p_grade p
ON e.job = p.`position`
ORDER BY e.empno       

-- 문제 2
-- emp, p_grade 테이블을 조인하여
-- 사원이름, 입사일,직급, 근속년도, 현재직급,근속년도 기준 예상직급 출력하기
-- 근속년도는 오늘을 기준으로 입사일의 일자/365 나눈후 
-- 소숫점이하는 버림으로
-- 단 모든 사원을 출력하기
SELECT * FROM p_grade
SELECT e.ename, e.hiredate, e.job, truncate(datediff(NOW(),e.hiredate)/365,0) 근속년수,
       p.`position`
FROM emp e LEFT join p_grade p
ON truncate(datediff(NOW(),e.hiredate)/365,0) BETWEEN p.s_year AND p.e_year
-- 문제 3
-- 사원이름, 생일,나이, 현재직product급,나이 기준 예상직급 출력하기
-- 나이는 오늘을 기준으로 생일까지의 일자/365 나눈후 소숫점이하는 버림
-- 단 모든 사원을 출력하기
SELECT e.ename,e.birthday,truncate(datediff(NOW(),e.birthday)/365,0) 나이,
      e.job, p.`position`
FROM emp e LEFT JOIN p_grade p
ON truncate(datediff(NOW(),e.birthday)/365,0) BETWEEN p.s_age AND p.e_age      



SELECT COUNT(*) FROM product