package practice.board.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	// singleton 만들기
	private static BoardDAO singleton = new BoardDAO();
	private BoardDAO() {}
	public static BoardDAO getInstance() {return singleton;}
	
	// db 연결/해제 메서드
	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context) ctx.lookup("java:comp/env");
		DataSource ds = (DataSource) env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs!=null) try {rs.close();} catch(Exception e) {e.printStackTrace();}
		if(pstmt!=null) try {pstmt.close();} catch(Exception e) {e.printStackTrace();}
		if(conn!=null) try {conn.close();} catch(Exception e) {e.printStackTrace();}
	}
	
	// writePro에서 생성된 게시글을 db에 저장
	public void uploadContent(BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		
	}
}
