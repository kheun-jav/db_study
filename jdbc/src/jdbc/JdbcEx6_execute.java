package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/*
 * 
 */
public class JdbcEx6_execute {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
//		String sql = "select * from student";
		String sql = "delete from depttest2";
		Connection conn = DBConnection.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		if(pstmt.execute()) { //sql 실행후, select 구문인 경우 : true 리턴
			//getResultset() : ResultSet 객체를 리턴
			ResultSet rs = pstmt.getResultSet();
			ResultSetMetaData rsmd = rs.getMetaData();
			for(int i=1; i<=rsmd.getColumnCount(); i++) {
				System.out.printf("%10s", rsmd.getColumnName(i));
			}
			System.out.println();
			while(rs.next()) {
				for(int i=1; i<=rsmd.getColumnCount();i++) {
					System.out.printf("%10s", rs.getString(i));
				}
				System.out.println();
			}
		} else { // select 구문 이외의 sql 문장인 경우
			System.out.println("변경된 레코드 건수:"+pstmt.getUpdateCount());
		}
	
	}
}
