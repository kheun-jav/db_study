/*
	DML : Data Manipulation Language : 데이터 처리(조작)어
			데이터 추가, 변경, 삭제 언어
		insert : 데이터 추가 - C
		update : 데이터 수정 - U  
		delete : 데이터 삭제 - D
		select : 데이터 조회 - R
	
		CRUD : Create, Read, Update, Delete
	Transaction 처리 가능 : commit, rollback 가능
*/
/*
	insert : 데이터(레코드)추가
	insert into 테이블명 [(컬럼명1, 컬럼명2,...)] values (값1,값2,...)
	 => 컬럼명의 갯수 값의 갯수가 동일해야함.
	  컬럼명 1 <= 값1
	  컬럼명 2 <= 값2
	  ....
	
	  컬럼명 부분을 구현하지 않으면 스키마에 정의된 순서대로 값을 입력해야함.
	  
	  -- 컬럼명을 구현해야 하는 경우
	  1. 모든 컬럼의 값을 입력하지 않는 경우
	  2. 스키마의 순서를 모를때
	  3. db 구조의 변경이 자주 발생시 컬럼명을 기술하는 것이 안전함
*/
SELECT * FROM depttest1
-- depttest1 테이블에 90번 특판팀 추가하기
INSERT INTO depttest1 (deptno, dname) VALUES (90, '특판팀')
SELECT * FROM depttest1
ROLLBACK -- insert 실행 취소
SELECT * FROM depttest1

-- depttest1 테이블에 91번 특판1팀 추가하기
INSERT INTO depttest1 VALUES(91,'특판1팀',NULL)
SELECT * FROM depttest1
-- depttest 테이블에 80, 인사부, 레코드 추가하기 -컬럼명 기술하기
INSERT INTO depttest1(deptno, dname) VALUES(80, '인사부')
SELECT * FROM depttest1

--여러개의 레코드를 한번에 추가하기
-- (91, 특판1팀), (50, 운용팀, 울산), (70, '총무부',울산), (80, 인사부, 서울)
SELECT * FROM depttest2
INSERT INTO depttest2 VALUES
	(91, '특판1팀', NULL),
	(50, '운용팀', '울산'),
	(70, '총무부', '울산'),
	(80, '인사부', '서울')
SELECT * FROM depttest2

-- 기존의 테이블을 이용하여 데이터 추가하기
SELECT * FROM depttest3
INSERT INTO depttest3 SELECT * FROM depttest2
SELECT * FROM depttest3

-- professor_101 테이블에 내용을 추가하기
insert into professor_101 (NO, NAME, deptno, POSITION, mname)
SELECT p.no, p.name, p.deptno, p.position, m.name
FROM professor p, major m
WHERE p.deptno = m.code
AND p.deptno = 101
SELECT * FROM professor_101
/*
	컬럼 부분의 갯수와 select에서 조회되는 컬럼의 갯수가 동일해야함
*/
INSERT INTO professor_101	-- 컬럼의 갯수가 다르므로 오류 발생
SELECT * FROM professor p, major m
WHERE p.deptno = m.code
	AND p.deptno = 101
	
-- test 3 테이블에 3학년 학생의 정보 저장하기
INSERT INTO test3 
SELECT studno, NAME, birthday
FROM student
WHERE grade = 3
ALTER TABLE test3 

SELECT studno, NAME, birthday FROM student WHERE grade = 3
SELECT * FROM test3

/*
	update : 데이터의 내용을 변경하는 명령어
	
	update 테이블명 set 컬럼1 = 값, 컬럼2 = 값, ...
	[where 조건문] => 없는 경우 모든 레코드 변경
							있는 경우 조건문에 결과가 참인 레코드만 변경
*/
-- emp 테이블에서 사원 직급인 경우 보너스 10만원 이상ㅇ하기
-- 보너스가 없는 경우도 10만원 변경하기
SELECT * FROM emp WHERE job = '사원'
-- bonus가 null인 경우 인상 안됨
UPDATE emp SET bonus = bonus + 10
WHERE job = '사원'

SELECT * FROM emp WHERE job = '사원'
ROLLBACK

UPDATE emp SET bonus = IFNULL(bonus,0) +10
WHERE job = '사원'
SELECT * FROM emp WHERE job = '사원'

-- 이상미 교수와 같은 직급의 교수 중 급여가 350 미만인 교수의 급여를
-- 10% 인상하기
-- update할 대상 조회
SELECT * FROM professor
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미')
	AND salary < 350
-- update로 변경
UPDATE professor SET salary = salary*1.1
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미')
   AND salary < 350

-- 보너스가 없는 시간강사의 보너스를 조교수의 평균보너스의 50%로 변경하기
SELECT * FROM professor
WHERE POSITION = '시간강사' AND ISNULL(bonus)

UPDATE professor
SET bonus = (SELECT avg(ifnull(bonus,0))*0.5  FROM professor WHERE POSITION = '조교수') 
WHERE POSITION = '시간강사' AND bonus IS NULL

SELECT * FROM professor WHERE POSITION = '시간강사'

-- 지도교수가 없는 학생의 지도교수를 이용학생의 지도교수로 변경하기
SELECT NAME, profno FROM student WHERE profno IS NULL

UPDATE student
SET profno = (SELECT profno FROM student WHERE NAME = '이용')
WHERE profno IS NULL

SELECT NAME, profno FROM student WHERE grade = 1
ROLLBACK

-- 교수 중 김옥남 교수와 같은 직급의 교수의 급여를 101학과의 평균급여로 변경하기
-- 소수점 이하는 반올림하여 정수로 저장하기
SELECT * FROM professor
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '김옥남')
-- 101 학과 평균급여
SELECT round(AVG(salary)) FROM professor WHERE deptno =101
-- update
UPDATE professor
SET salary = (SELECT round(AVG(salary)) FROM professor WHERE deptno = '101')
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '김옥남')

SELECT * FROM professor WHERE POSITION = '시간강사'
ROLLBACK

/*
	delete : 레코드 삭제
	
	delete from 테이블명
	[where 조건문] => 조건문의 결과가 참인 레코드만 삭제
*/
SELECT * FROM depttest1
-- depttest1의 모든 레코드를 삭제하기
DELETE FROM depttest1


-- depttest2 테이블에서 기획부 삭제하기
DELETE FROM depttest2 WHERE dname = '기획부'
SELECT * FROM depttest2

-- depttest2 테이블에서 부서명에 '기' 문자가 있는 부서 삭제하기
DELETE FROM depttest2 
WHERE dname LIKE '%기%'
SELECT * FROM depttest2
ROLLBACK

-- 교수 중 김옥남 교수와 같은 부서의 교수정보 제거하기
DELETE FROM professor
WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남')

SELECT * FROM professor
WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남')

DROP TABLE test2 -- DDL 명령 실행시 자동 commit
ROLLBACK
SELECT * FROM test2
/*
	SQL의 종류
	DDL : 데이터 정의어 . Data Definition Language
			Create, alter, drop, truncate
			transaction 처리 안됨. autocommit 임. (rollback 안됨)
	DML : 데이터 처리(조작)어. Data manupulation Language
			insert(C), select(R), update(U), delete(D)
			Transaction 처리 가능. rollback, commit 실행 가능.
			autocommit이 아닌 환경에서 rollback, commit 가능
	TCL : 트랜잭션 제어 언어 :  Transaction Contrl Language
		commit, rollback
	DCL : 데이터 제어어 : Data Control Language => db 관리자의 언어
			grant  : 사용자에게 db 권한 부여.
			revoke : 사용자에게 부여되었던 권한 회수. 제거
	 