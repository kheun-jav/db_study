package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/*
 * 학생의 학번, 이름, 학년, 학과코드, 학과명, 지도교수 이름을 출력하기
 * 출력시 Header에 컬럼도 출력하기
 */
public class Exam3 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		String sql = "select s.studno, s.name, s.grade, s.major1, m.name mname, p.name pname"
				+ " from student s, professor p, major m "
				+ "where s.profno = p.no and s.major1 = m.code";
		Connection conn = DBConnection.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);				
		ResultSet rs = pstmt.executeQuery();
		ResultSetMetaData rsmd = rs.getMetaData();
		// header 컬럼 출력
		for(int i =1; i<=rsmd.getColumnCount(); i++) {
			System.out.printf("%10s", rsmd.getColumnName(i));
		}
		System.out.println();
		while(rs.next()) {
			for(int i=1; i<=rsmd.getColumnCount();i++) {
				System.out.printf("%10s", rs.getString(i));
			}
			System.out.println();
		}
	
	}

}
