package test;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class class1 {
	public static void colPrinter(ResultSetMetaData rsmd) throws SQLException {
		for(int i=1; i<=rsmd.getColumnCount();i++) {
			System.out.printf("%10s", rsmd.getColumnName(i));
		}
		System.out.println();
	}
	public static void recPrinter(ResultSet rs, ResultSetMetaData rsmd) throws SQLException {
		while(rs.next()) {	
			for(int i=1; i<=rsmd.getColumnCount();i++) {
				System.out.printf("%10s", rs.getString(i));
			}
			System.out.println();
		}
	}
    public static void count(ResultSet rs) throws SQLException {
        rs.last(); // 마지막 위치로 이동
        int count = rs.getRow(); // 마지막 위치의 행(레코드) 번호를 count 변수에 저장 
        System.out.println("레코드 건수: " + count); // 출력
        rs.beforeFirst(); // 다시 처음 위치로 reset
    }
}
