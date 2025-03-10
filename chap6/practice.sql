/*
	DDL : Data Definition Language (데이터 정의어)
			객체의 구조를 생성, 수정, 변경, 제거하는 명령어
		create : 객체의 생성 명령어
			table 생성 : create table
			user 생성 : create user
			index 생성 : create index
			....
		alter : 객체 수정 명령어. 컬럼 추가, 컬럼 제거, 컬럼 크기 조정...
		drop : 객체 제거 명령어
		truncate : 데이터제거. 객체와 데이터 분리.
	
	DDL의 특징 : transaction 처리안됨. commit, rollback 관련 명령어
	
	transaction : 최소업무단위 all of nothing
*/

-- create : table 생성
-- no int, name varchar(20), birth datetime 컬럼을 가진
-- test1 테이블 생성하기
CREATE TABLE test1 (
	NO INT,
	NAME VARCHAR(20),
	birth DATETIME
)
-- desc 명령어로 스키마 조회
DESC test1
-- 기본키 : primary Key. 각각의 레코드를 구분할 수 있는 데이터
--				학번, 주민번호
--				기본키의 컬럼값은 중복불가, 유일한 컬럼값을 가짐. NULL 불가
-- no int, name varchar(20), birth datetime 컬럼을 가진
-- test2 테이블 생성하기. 단 no를 기본키로 설정
CREATE TABLE test3 (
	NO INT, -- 제약조건
	NAME VARCHAR(20),
	birth DATETIME,
	PRIMARY KEY(NO)
)
DESC test3

-- auto_increment : 자동으로 1씩 증가. 숫자형 기본키에서만 사용 가능
-- 오라클에서는 사용 불가 => 시퀀스 객체를 이용함

INSERT INTO test2 (NAME,birth) value('홍길동','1990-01-01')
SELECT * FROM TEST2

-- 기본기 컬럼이 여러개로 생성하기
CREATE table test4 (
	NO INT,
	seq INT,
	NAME VARCHAR(20),
	PRIMARY KEY(NO, seq)
)
desc test4
/*
	no seq
	1	 1		가능
	1	 2		가능
	2	 1		가능
	2	 1		불가능 => 기본키 중복됨
	
	기본키는 테이블당 한개만 가능. 중복커럼은 가능. unique + not null 기능
*/
/*
	컬럼에 기본값 설정하기
	default : 값이 없으면 기본값으로 설정
*/
CREATE TABLE test5(
	NO INT primary KEY,
	NAME VARCHAR(30) DEFAULT '홍길동' -- 값이 없으면 홍길동
)
DESC test5

INSERT INTO test5 (NO) VALUES(1)
SELECT * FROM test5

/*
	create table 테이블명 (
		컬럼명1 자료형 [제약조건 : 기본키, auto_increment, default]
		컬럼명2 자료형 ...
		....
		primary key(컬럼1, 컬럼2) 기본키 설정
	)
*/
/*
	기존 테이블을 이용하여 새로운 테이블 생성하기
*/
-- dept 테이블의 모든 컬럼과 모든 레코드를 가진 depttest1 테이블 생성하기
CREATE TABLE depttest1 AS SELECT * FROM dept
SELECT * FROM depttest1
DESC dept
DESC depttest1
-- 기존테이블을 이용하여 새로운 테이블을 생성하면
-- 기존테이블의 제약조건은 복사되지 않는다

-- dept 테이블의 모든 컬럼과 지역이 서울인 레코드만 가진
-- depttest2 테이블 생성하기
CREATE TABLE depttest2 AS SELECT * FROM dept WHERE loc = '서울'
SELECT * FROM depttest2

-- dept 테이블의 deptno, dname 컬럼만 가지고 있고, 레코드 없는
-- depttest3 생성하기
CREATE TABLE depttest3 AS 
SELECT deptno, dname from dept WHERE 1 = 2
SELECT * FROM depttest3

-- 문제
-- 교수테이블에서 101학과 교수들만 professor_101 테이블로 생성하기
-- 필요 컬럼 : 교수번호, 이름, 학과코드, 직책, 학과명
CREATE TABLE professor_101 AS
SELECT NO, p.NAME, deptno, POSITION, m.name mname
FROM professor p, major m
WHERE p.deptno = m.code 
AND p.deptno = '101'

SELECT * FROM professor_101
DESC professor_101

-- 학생 테이블에서 1학년 학생들만 student1 테이블로 생성하기
-- 필요컬럼 : 학번, 이름, 전공1학과코드, 학과명
-- 컬럼명이 겹칠 경우 alias를 사용하여 명칭을 변경한다.
CREATE TABLE student1 
AS
SELECT studno,grade, s.NAME, major1, m.name mname
FROM student s, major m
WHERE s.major1 = m.code
AND s.grade = '1'

SELECT * FROM student1
DESC student1

-- database의 table들의 목록 조회
SHOW TABLES

CREATE sequence testseq -- 시퀀스 객체 생성

/*
	alter : 테이블의 구조 수정.
*/
DESC depttest3
-- depttest3 테이블에 loc 컬럼 추가하기
SELECT * FROM depttest3
alter TABLE depttest3 ADD loc VARCHAR(30)
SELECT * FROM depttest3
DESC depttest3

-- depttest3 테이블에 int형 컬럼 part 컬럼 추가
ALTER TABLE depttest3 ADD part INT
DESC depttest3

-- part 컬럼의 자료형을 int -> int(2) 크기 변경
ALTER TABLE depttest3 modify part INT(2)
DESC depttest3

-- 문제
-- depttest3 테이블의 loc 컬럼 varchar(100) 크기 변경
ALTER TABLE depttest3 MODIFY loc VARCHAR(100)
DESC depttest3

-- depttest3 테이블에 part 컬럼을 제거하기
ALTER TABLE depttest3 DROP part
DESC depttest3

-- depttest3 테이블에 loc컬럼의 일므을 area 이름 변경하기
ALTER table depttest3 CHANGE loc AREA VARCHAR(30)
DESC depttest3
ALTER TABLE depttest3 CHANGE AREA loc VARCHAR(100)
DESC depttest3
/*
	 컬럼 관련 수정
	 컬럼 추가 		: add 컬럼명 자료형
	 컬럼 크기 변경 : modify 컬럼명 자료형
	 컬럼 제거		: drop  컬럼명 
	 컬럼 이름 변경 : change 원래컬럼명 변경컬럼명 자료형 
*/
/*
	제약 조건 수정
*/
-- depttest3 테이블의 deptno 컬럼을 기본키로 설정하기
ALTER TABLE depttest3 ADD CONSTRAINT PRIMARY KEY (deptno)
DESC depttest3

-- professor_101 테이블의 no컬럼은 professor 테이블의 no 컬럼을 
-- 참조하도록 외래키로 설정하기
ALTER TABLE professor_101 ADD CONSTRAINT FOREIGN KEY (NO)
REFERENCES professor(NO)

DESC professor_101professor_101

SELECT no FROM professor
SELECT NO FROM professor_101
-- professor_101 테이블에 no= 2000인 교수 추가하기
INSERT INTO professor_101 (NO, NAME, POSITION, mname)
VALUE (5010, '임시','임시강사','임시학과')
SELECT * FROM professor_101

-- professor_101 테이블에 dept 컬럼은 major 테이블의 code 컬럼을
-- 참조하도록 외래키 등록하기
ALTER TABLE professor_101 ADD CONSTRAINT FOREIGN KEY (deptno)
REFERENCES major(CODE)
DESC professor_101

-- 문제
-- professor_101 테이블의 기본키를 설정하기
-- no 컬럼으로 기본키 설정하기
ALTER TABLE professor_101 ADD CONSTRAINT PRIMARY KEY (NO)
DESC professor_101
-- 하나의 테이블에 외래키는 여러개 가능함
-- 하나의 테이블에 기본키는 하나만 가능함
-- 제약 조건 조회하기
USE information_schema -- information_schema DATABASE 선택
							  -- information_schema의 테이블/뷰를information_schema	
SELECT * FROM TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'professor_101'

USE gdjdb
SELECT * FROM student