package practice.board.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
	// db에 첫글일때, 새글작성일때, 댓글일때
	public boolean uploadContent(BoardDTO dto) {
		boolean result = false;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// num, reg column은 db에서 생성
			// ref는 num과 동일한 값 부여, 
			// re_step, re_level은 0
			conn = getConnection();
			// num구하기
			String sql = "select max(num) from board";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int num, ref, re_step, re_level;
			int readcount = 0;	//처음 생성된(첫글/새글/댓글이든) 글은 당연히 조회수 0
			System.out.println(rs.next()); // max값이 null이어도 rs.next()는 true로 나오므로 한번 소비
			if(rs.getInt(1)>0) {	// 새글 또는 댓글
				num = rs.getInt(1)+1; 
				System.out.println(rs.getInt(1));
				if(dto.getRef()==null) { //새글일때
					System.out.println("새글");
					ref = num;	// 새글일때는 ref와 Num은 일치
					re_step = 0;
					re_level = 0;
				}else { //댓글일때
					ref = dto.getRef();	// 댓글은 읽은 글의 ref와 동일
					re_step = dto.getRe_step() + 1;	//읽은 글의 step의 밑 단계로 끼어들기
					re_level = dto.getRe_level() + 1;	//읽은 글의 level에서 한단계 들여쓰기(가 댓글)
				}
			}else { // 첫글
				num = 1;
				ref = num;
				re_step = 0;
				re_level = 0;
			}
			sql = "insert into board values (board_seq.nextVal,?,?,?,?,?,sysdate,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getSubject());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getContent());
			pstmt.setString(5, dto.getPw());
			pstmt.setInt(6, readcount);
			pstmt.setInt(7, ref);
			pstmt.setInt(8, re_step);
			pstmt.setInt(9, re_level);
			pstmt.setString(10, dto.getImg());
			pstmt.executeUpdate();
			result = true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return result;
	}
	// board의 모든 글을 불러온다.
	// List에 dto형으로 반환
	// 정렬순서 ref열의 내림차순, ref가 동일할 시 step의 내림차수 
	public List callAllRecords() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List records = new ArrayList();
		BoardDTO dto = null;
		int count = 0;
		
		try {
			conn = getConnection();
			// 정렬 sql
			String sql = "select * from board order by ref desc, re_step desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getInt("num")>0) {
					dto = new BoardDTO();
					dto.setNum(rs.getInt("num"));
					dto.setWriter(rs.getString("writer"));
					dto.setSubject(rs.getString("subject"));
					dto.setEmail(rs.getString("email"));
					dto.setContent(rs.getString("content"));
					dto.setPw(rs.getString("pw"));
					dto.setReg(rs.getTimestamp("reg"));
					dto.setReadcount(rs.getInt("readcount"));
					dto.setRef(rs.getInt("ref"));
					dto.setRe_step(rs.getInt("re_step"));
					dto.setRe_level(rs.getInt("re_level"));
					dto.setImg(rs.getString("img"));
					records.add(dto);
					count++;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		records.add(count);	// 총 글 갯수를 showList의 마지막에 반환
		return records;
	}
}
