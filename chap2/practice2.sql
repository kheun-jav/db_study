/*
	desc : 테이블의 구조(스키마)
	
	select * | 컬럼명들
	from 테이블명
	[where 조건문] => 구현이 안된경우 : 모든 행 선택
							구현이 된 경우 : 조건문의 결과가 참인 레코드만 선택
	
	컬럼부분
		* : 모든 컬럼
		컬럼명목록 : 구현 컬럼만 조회
		컬럼의 리터널 컬럼 : 상수 컬럼
		컬럼의 연산자 사용 가능 : +,-,*,/
		별명(Alias) 사용 가능
		distinct : 중복 없이 조회. 컬럼명 앞에 한번만 사용 가능
	
	where 조건문에 사용되는 연산자
		관계연산자 : =, >, <, >=, <=, <>, !=
		논리연산자 : and, or
		between : 컬럼명 between A and B => 컬럼의 값이 A이상 B이하
		in		  : 컬럼명 in (A,B) => 컬럼의 값이 A 또는 B인 경우
			not in
		like 	  : 부분적으로 일치하는 문자열 찾기
			not like
			%	: 0개이상의 임의의 문자
			_	: 1개의 임의의 문자
			binary : 대소문자 구분. MariaDB에서만 사용
		is null : null 값은 값이 없으므로, 연산, 비교 대상이 안됨.
		is not null	
		
	order by : 정렬. select 구문의 마지막에 기술되어야 함
		asc : 오름차순 정렬. 생략가능
		des : 내림차순 정렬.
	order by 컬럼1, 컬럼2 => 컬럼1로 1차정렬 후 컬럼2로 2차정렬
		컬럼명, 조회된 컬럼의 순서, 컬럼의 별명
*/
-- 집합연산자
-- 교수테이블에서 교수이름, 학과코드, 급여, 연봉 조회
-- 보너스가 있는 경우 : 급여*12+보너스
-- 보너스가 없는 경우 : 급여*12
/*
	합집합 : union, union all
	union : 합집합. 중복을 제거하여 조회
	union all : 두개 쿼리 문장의 결과를 합하여 조회. 중복제거 안됨
	두개의 select문의 조회되는 컬럼의 갯수가 같아야 한다.
	첫번째 select 구문의 컬럼명으로 조회된다
*/
SELECT NAME , deptno, salary, bonus, salary*12+bonus
FROM professor
WHERE bonus Is NOT NULL
UNION
SELECT NAME , deptno, salary, bonus, salary*12
FROM professor
WHERE bonus Is NULL
--전공1학과가 202학과이거나, 전공2 학과가 101학과인 학생의
--학번, 이름, 전공1, 전공2 조회하기
SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202 OR major2 = 101

SELECT studno, NAME, major1, major2 from student
WHERE major1 = 202
UNION
SELECT studno, NAME, major1, major2 from student
WHERE major2 = 101

SELECT studno, NAME, major1, major2 from student
WHERE major1 = 202
UNION all
SELECT studno, NAME, major1, major2 from student
WHERE major2 = 101
/*
	교수 중 급여가 450이상인 경우 5% 인상예정이고.
	450 미만인 경우 10%인상 예정임
	교수번호, 교수명, 현재급여, 인상예정급여 조회하기
	인상예정급여가 큰순으로 조회하기
*/
SELECT NO, NAME, salary, salary*1.05 인상예정급여
FROM professor
WHERE salary >= 450
UNION
SELECT NO, NAME, salary, salary*1.1
FROM professor
WHERE salary <450
ORDER BY 인상예정급여 DESC
/*
	교집합 : intersect
	AND		
*/
/*
	전공1학과가 202이고, 전공2학과가 101인 학생의 학번, 이름, 전공1
*/
SELECT studno, NAME, major1, major2 FROM student
WHERE major1 = 202 AND major2 = 101

SELECT studno, NAME, major1, major2 FROM student
WHERE major1 = 202
INTERSECT
SELECT studno, NAME, major1, major2 FROM student
WHERE major2 = 101
