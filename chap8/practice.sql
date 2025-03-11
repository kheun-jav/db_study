/*
	view : 가상테이블
			물리적으로 메모리 할당이 없음. 테이블처럼 join, subquery 가능함
*/

-- 2학년 학생의 학번, 이름, 키, 몸무게를 가진 뷰 v_stu2 생성하기
CREATE OR REPLACE VIEW v_stu2
AS SELECT studno, NAME, height, weight FROM student WHERE grade = 2

--v_stu2 뷰의 내용 조회하기
SELECT * FROM v_stu2

-- 232001, 홍길동, 2, 160, 60, hongkd 학생테이블 추가하기
-- 242001, 김삿갓, 1, 165, 65, kimsk 학생테이블 추가하기
INSERT into student (studno, NAME, grade, height, weight, id, jumin)
VALUES (232001, '홍길동', 2, 160, 60, 'hongkd', '12345'), 
		 (242001, '김삿갓', 1, 165, 65, 'kimsk', '56789')

SELECT * FROM v_stu2


-- view 객체 조회하기
USE information_schema
SELECT view_definition FROM views
WHERE TABLE_NAME = "v_stu2"

USE gdjdb
SELECT select `gdjdb`.`student`.`studno`
	AS `studno`,`gdjdb`.`student`.`name` 
	AS `NAME`,`gdjdb`.`student`.`height` 
	AS `height`,`gdjdb`.`student`.`weight` 
	AS `weight` 
from `gdjdb`.`student` 
where `gdjdb`.`student`.`grade` = 2


-- 2학년 학생의 학번, 이름, 국어, 영어, 수학 값을 가지는 v_score2 뷰생성
SELECT * FROM score
CREATE OR REPLACE VIEW v_score2
AS SELECT s1.studno, s2.name, s1.kor, s1.eng, s1.math
FROM score s1, student s2
WHERE s1.studno = s2.studno 
and s2.grade = 2

-- Create or replace : 생성 또는 변경
SELECT * FROM v_score2
-- v.stu2, v.score2 뷰를 이용하여 학번, 이름, 점수들, 키, 몸무게 정보 조회
SELECT v1.*, v2.height, v2.weight 
FROM v_score2 v1, v_stu2 v2
WHERE v1.studno = v2.studno

-- v_score 뷰와 student 테이블을 이용하여 
-- 학번, 이름, 점수들, 학년, 지도교수 번호 출력하기
SELECT v1.*, s.grade, s.profno
FROM student s, v_score2 v1
WHERE s.studno = v1.studno

-- v_score 뷰와 student 테이블을 이용하여 
-- 학번, 이름, 점수들, 학년, 지도교수 번호, 지도교수이름 출력하기
SELECT v.studno, v.name, v.kor, v.eng, v.math, s.profno, p.name
FROM v_score2 v, student s, professor p
where s.studno = v.studno AND s.profno = p.no

-- 뷰 삭제하기
DROP VIEW v_stu2
SELECT * FROM v_st2

/*
	inline 뷰 : 뷰의 이름이 없고, 일회성으로 사용되는 뷰
					select 구문의 from 절에 사용되는 subquery
					반드시 별명을 설정해야함
*/
-- 학생의 학번, 이름, 학년, 키, 몸무게, 학년의 평균키, 평균몸무게 조회하기
SELECT studno, NAME, grade, height, weight,
(SELECT AVG(height) FROM student s2 WHERE s1.grade= s2.grade) 평균키,
(SELECT AVG(weight) FROM student s2 WHERE s1.grade = s2.grade) 평균몸무게
FROM student s1
-- inline 뷰를 이용하기
SELECT studno, NAME, s.grade, height, weight, avg_h, avg_w
FROM student s, 
	  (SELECT grade, 
	   AVG(height) avg_h, AVG(weight) avg_w FROM student GROUP BY grade) a
WHERE s.grade = a.grade

-- 사원테이블에서 사원번호, 사원명, 직급, 부서코드, 부서명, 부서별평균급여,
-- 부서별 평균보너스 출력하기. 보너스가 없으면 0으로 처리한다.
SELECT  e1.empno , e1.ename, e1.job, e1.deptno, d.dname, e2.avg_s, e2.avg_b
FROM emp e1, dept d,
	(SELECT deptno, AVG(salary) avg_s, AVG(IFNULL(bonus,0)) avg_b 
	 FROM emp GROUP BY deptno) e2
WHERE e1.deptno = d.deptno 
	AND e1.deptno = e2.deptno
 