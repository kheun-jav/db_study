-- 테이블 훼손 방지용 autocommit 설정
SET autocommit = false
-- 1. 테이블 test11를 생성하기. 
--    컬럼은 정수형인 no 가 기본키로 
--    name 문자형 20자리
--    tel 문자형 20 자리
--   addr 문자형 100자리로 기본값을 서울시 금천구로 설정하기
CREATE TABLE test11 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(20),
	tel VARCHAR(20),
	adder VARCHAR(100) DEFAULT '서울시 금천구'
	)
DESC test11
-- 2. 교수 테이블로 부터 102 학과 교수들의 
-- 번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
-- 가지는 professor_102 테이블을 생성하기
CREATE TABLE professor_102 
AS SELECT NO, NAME, deptno, salary, bonus, POSITION
FROM professor WHERE deptno = '102'
SELECT * FROM professor_102
-- 3. 사원테이블에서 사원번호 3001, 이름:홍길동, 직책:사외이사
-- 급여:100,부서:10 입사일:2025년04월01일 인 레코드 추가하기
INSERT INTO emp (empno, eNAME, job, salary, deptno, hiredate)
VALUES (3001, '홍길동', '사외이사', 100, 10, '2025-04-01')
SELECT * FROM emp
rollback
-- 4. 교수 테이블에서 이상미교수와 같은 직급의 교수를 퇴직시키기
DELETE FROM professor 
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미')
SELECT * FROM professor
rollback
-- 5.교수번호,교수이름,직급, 학과코드,학과명 컬럼을 가진 테이블 professor_201을 생성하여
--   201학과에 속한 교수들의 정보를 저장하기
CREATE TABLE professor_201 AS
SELECT p.NO, p.NAME, p.POSITION, p.deptno, m.name mname
FROM professor p, major m
WHERE p.deptno = m.code AND deptno = '201' 
SELECT * FROM professor_201
-- 7. 사원테이블에 사원번호:3002, 이름:홍길동, 직책:사외이사, 
--   급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정안함
INSERT INTO emp VALUES (3002, '홍길동', '사외이사',
							   NULL, NULL, NOW(), 100, NULL, 10)
SELECT * FROM emp 
-- 8. student 테이블과 같은 컬럼을 가진 테이블 stud_male 테이블 생성하기.
--     student 데이터 중 남학생 정보만 stud_male 테이블에 저장하기
--    성별은 주민번호를 기준으로 한다.
CREATE TABLE stud_male AS SELECT * FROM student
WHERE SUBSTR(jumin, 7,1) IN ('1','3')
SELECT * FROM stud_male
-- 9.  2학년 학생의 학번,이름, 국어,영어,수학 값을 가지는 score2 테이블 생성하기
CREATE TABLE score2 AS SELECT s1.studno, s1.NAME, s2.kor, s2.eng, s2.math
FROM student s1, score s2
WHERE s1.studno = s2.studno AND s1.grade= 2
SELECT * FROM score2 
-- 10. 박인숙 교수와 같은 조건으로 오늘 입사한 이몽룡 교수 추가하기
--    교수번호 : 6003,이름:이몽룡,입사일:오늘,id:monglee
--    나머지 부분은 박인숙 교수 정보와 같다.
INSERT INTO professor VALUES(6003, '이몽룡', 'monglee', POSITION, salary, NOW(), bonus, deptno, email, URL)
UPDATE professor AS lee
JOIN professor AS park on park.name = '박인숙'
SET lee.position = park.position,
    lee.salary   = park.salary,
    lee.bonus    = park.bonus,
    lee.deptno   = park.deptno,
    lee.email    = park.email,
    lee.url      = park.url
WHERE lee.NAME = '이몽룡'
SELECT * FROM professor WHERE NAME IN('박인숙', '이몽룡')
-- 11. major 테이블에서 code값이 200 이상인 데이터만 major2에 데이터 추가하기
CREATE TABLE major2 AS SELECT * FROM major WHERE CODE >= 200
SELECT * FROM major2
DELETE FROM major2
-- 12.  major2 테이블에 공과대학에 속한 학과 정보만 추가하기 major 테이블 사용
SELECT * FROM major
INSERT INTO major2 SELECT * FROM major WHERE CODE in (SELECT CODE FROM major WHERE part in (SELECT CODE FROM major WHERE part = 10))
select * FROM major2
-- 13. 이영국 직원과 같은 직급의 직원의 급여는 
--    박진택 직원의 같은 부서의 평균급여의 80%로 변경하고, 보너스는 현재 보너스보다 15%를 인상하여 변경하기
SELECT * FROM emp
UPDATE emp SET salary = (SELECT AVG(salary) FROM emp WHERE deptno = (SELECT deptno FROM emp WHERE eNAME = '박진택'))*0.8,
					bonus = IFNULL(bonus,0) * 1.15
WHERE job = (SELECT job FROM emp WHERE eNAME = '이영국')
SELECT * FROM emp WHERE job = '과장'
-- 14. student 테이블과 같은 컬럼과, 학생 중 남학생의 정보만을 가지는  v_stud_male 뷰 생성하기.
--    성별은 주민번호를 기준으로 한다.
CREATE OR REPLACE VIEW v_stud_male
AS SELECT * FROM student WHERE SUBSTR(jumin, 7,1) IN (1,3)
SELECT * FROM v_stud_male
-- 15.  교수번호,이름,부서코드,부서명,자기부서의 최대급여, 최소급여, 평균급여, 최대보너스, 최소보너스,  평균보너스 조회하기
--       보너스가 없으면 0으로 처리한다.
SELECT * FROM professor
SELECT p.no, p.name, p.deptno, m.name, x.max_s, x.min_s, x.avg_s, x.max_b, x.min_b, x.avg_b
FROM professor p, major m,
		(SELECT deptno, MAX(salary) max_s, MIN(salary) min_s, AVG(salary) avg_s, 
		 MAX(IFNULL(bonus,0)) max_b, Min(IFNULL(bonus,0)) min_b, avg(IFNULL(bonus,0)) avg_b 
		 FROM professor GROUP BY deptno) x 
WHERE p.deptno = m.code AND p.deptno = x.deptno