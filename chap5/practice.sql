/*
	join 구문: 여러개의 테이블을 연결하여 데이터 조회
		cross join : m*n개수로 레코드 생성. 사용시 주이요함
		등가조인(equal join) : 조인컬럼을이용하여 조건에 맞는 레코드 
									  선택. 조인컬럼의 조건문이 = 인 경우
		비등가조인 (non equal join) : 조인컬럼을 이용하여 조건에 맞는 레코드만
										선택. 조인컬럼의 조건문이 =이 아닌 경우
		self join(자기조인) : 같은 테이블을 join 하는 경우
									 테이블의 별명설정, 컬럼 조회시 별명 설정 
		
		inner join : 조인컬럼을 이용하여 조건에 맞는 레코드만 선택
		outer join : 조인컬럼을 이용하여 조건에 맞는 레코드만 선택.
						 한쪽 또는 양쪽테이블에서 조건 맞지 않아도 선택
			left outer join : 왼쪽 테이블의 내용은 전부 조회
									left join 예약어
			right outer join : 오른쪽 테이블의 내용은 전부 조회
									right join 예약어
			full outer join : 양쪽 테이블의 내용은 전부 조회
									union 사용하여 구현
*/

/*
	subquery : select 구문 내부에 select 구문이 존재함
				  where 조건문에서 사용되는 select 구문
	subquery 가능 부분
		where 조건문 : subquery
		from			 : inline 뷰
		컬럼부분		:  스칼라 subquery
*/
/*
	단일행 서브쿼리 : 서브쿼리의 결과가 1개
			사용가능한 연산자 : =, >,<,>=,<=
			
	복수행 서브쿼리 : 서브쿼리의 결과가 여러개 행인 경우
			사용 가능한 연산자 : in, all, any	
*/
-- emp 테이블에서 이혜라 사원보다 많은 급여를 받는 직원 정보를 출력
-- 1. 김지애 직원의 급여 조회하기
SELECT salary FROM emp WHERE ename = '김지애'
-- 2. 550보다 많은 급여를 받는 직원의 정보 조회하기
SELECT * FROM emp WHERE salary > 550
-- 서브쿼리를 사용하면 1,2를 동시에 진행가능
SELECT * FROM emp 
WHERE salary>(SELECT salary FROM emp WHERE ename = '김지애')
--문제
-- 김종연 학생보다 윗학년의 이름, 학년, 전공1, 학과명 출력하기
SELECT s.name, s.grade, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
	and s.grade > (SELECT grade FROM student WHERE NAME = '김종연') 
	
--문제
-- 사원테이블에서 사원직급의 평균급여보다 적게받는
-- 직원의 사원번호, 이름, 직급, 급여를 출력하기
SELECT empno, ename, job, salary FROM emp
where salary < (SELECT AVG(salary) FROM emp WHERE job = '사원')

/*
	복수행 서브쿼리
*/
-- emp, dept 테이블을 이용하여 금무지역이 서울인 사원의
-- 사원번호, 이름, 부서코드, 부서명을 조회하기
SELECT * FROM dept

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN(SELECT deptno FROM dept WHERE loc='서울')

-- 문제
-- 1학년 학생과 같은 키를 가지고 있는 2학년학생의 이름, 키 학년 조회하기
SELECT NAME, height, grade FROM student
WHERE height in (SELECT height FROM student WHERE grade = 1)
AND grade = 2

-- 사원 지급의 최대 급여보다 급여가 높은 직원의 이름, 직급, 급여 조회하기
SELECT eNAME, job, salary FROM emp
WHERE salary > (SELECT MAX(salary) FROM emp where job = '사원')  

-- > all : 복수결과값 모든값보다 큰경우. 그룹함수 사용
-- < all : 복수결과값 모든값보다 작은경우
-- > any : 복수결과값 중 한개보다 큰 경우. 그룹함수 사용
-- < any : 복수결과값 중 한개보다 작은 경우
SELECT ename, job, salary FROM emp
WHERE salary > ALL (SELECT salary FROM emp WHERE job = '사원')

-- 문제
-- major 테이블에서 컴퓨터정보학부에 소속된 학생의 학번, 이름
-- 학과번호, 학과명을 출력
SELECT * FROM major WHERE NAME = '컴퓨터정보학부'
SELECT * FROM major WHERE part = 100

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
AND m.code IN(SELECT code FROM major WHERE part = 100)
-- 서브쿼리안에 서브쿼리를 사용할 수 있다.

/*
	다중 컬럼 서브쿼리 : 비교 대상 컬럼이 2개인 경우
*/
-- 학년별로 최대키를 가진 학생의 학년, 이름, 키 조회하기
SELECT grade, name ,height FROM student
WHERE (grade, height) IN -- 다중컬럼 서브쿼리
(SELECT grade, MAX(height) FROM student GROUP BY grade)

-- emp 테이블에서 해당 직급의 최대 급여를 받는 직원의 정보조회하기
SELECT * FROM emp
WHERE (job, salary) IN
(SELECT job, MAX(salary) FROM emp GROUP BY job)

-- 문제
-- 학과별 입사일이 가장 오래된 교수의 교수번호, 이름, 입사일, 학과명 조회하기

SELECT p.NO, p.NAME, p.hiredate, m.name 
FROM professor p , major m
WHERE p.deptno = m.code
	AND (deptno, hiredate) 
	IN (SELECT deptno, min(hiredate) FROM professor GROUP BY deptno)
/*
	상호연관 서브쿼리 : 외부query의 컬럼이 subquery에 영향을 주는 query
							  성능이 안좋다.
*/
-- 직원의 현재 직급의 평균급여 이상의 급여를 받는 직원의 정보 조회
SELECT * FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job = e1.job)

-- 문제
-- 교수 본인 직급의 평균급여 이상을 받는 교수의 이름, 직급, 급여 조회하기
SELECT NAME, POSITION, salary FROM professor p1
WHERE salary >= 
(SELECT AVG(salary) FROM professor p2 WHERE p2.position =p1.position)

-- 사원이름, 직급, 부서코드, 부서명 조회하기
SELECT e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- join을 사용하지 않고 조회하기
-- 컬럼부분에 subquery 사용하기 => 스칼라 서브쿼리
SELECT ename, job, deptno, 
		(SELECT d.dname FROM dept d WHERE d.deptno = e.deptno) 부서명
FROM emp e 

-- 학년별 평균체중이 가장 적은 학년의 학년과 평균체중을 조회하기
-- from 구문에 사용되는 subquery => inline 뷰 sub query
SELECT grade, AVG FROM
	(SELECT grade, AVG(weight) AVG FROM student GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG)
		FROM (SELECT grade, AVG(weight) AVG FROM student GROUP BY grade) a) 
		
SELECT grade, MIN(AVG) FROM
(SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2) a
