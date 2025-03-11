/*
	사용자 관리
*/
-- 데이터베이스 생성
CREATE DATABASE mariadb
-- 데이터베이스 목록 조회
SHOW DATABASES
-- 테이블 목록 조회
SHOW TABLES

-- 사용자 생성하기
USE mariadb
CREATE USER test1
-- 비밀번호 설정하기
SET PASSWORD FOR 'test1' = PASSWORD('pass1')
-- 권한 주기
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, CREATE VIEW
ON mariadb.* TO 'test1'@'%'

GRANT ALTER ON mariadb.'*' TO 'test1'@'%'
--권한 조회
SELECT * FROM USER_PRIVILEGES
WHERE grantee = 'test1'

-- 권한 회수 : revoke
REVOKE ALL PRIVILEGES ON mariadb.* FROM test1@'%'

-- test1 사용자 삭제하기
DROP USER 'test1'@'%'
