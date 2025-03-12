package jdbc;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//문제 : 교수테이블에서 교수의 번호, 이름, id,입사일, 급여, 보너스, 학과코드를 화면에 출력하기
public class Exam1 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection
				("jdbc:mariadb://localhost:3306/gdjdb", "gduser", "1234");
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select * from professor");
		while(rs.next()) { //database에 대한 java의 인덱스 번호는 1부터이다.
			System.out.print("번호:"+rs.getInt("no"));
			System.out.print(",이름:"+rs.getString("name"));
			System.out.print(",id:"+rs.getString("id"));
			System.out.print(",입사일:"+rs.getString("hiredate"));
			System.out.print(",급여:"+rs.getInt("Salary"));
			System.out.print(",보너스:"+rs.getInt("bonus"));
			System.out.println(",학과코드:"+rs.getInt("deptno"));
		}
	}

}
