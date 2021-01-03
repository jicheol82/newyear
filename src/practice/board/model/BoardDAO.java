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
	// 총 record 갯수 반환 메서드
	public int countRecords() {
		int result=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select count(*) from board";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			if(rs.next()) {result = rs.getInt(1);} // 아무 레코드가 없어도 여기서 rs는 null이 아니다.
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return result;
	}
	// 조건에 맞는 총 record 갯수 반환 메서드
		public int countRecords(String sel, String search) {
			int result = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select count(*) from board where " + sel + " like '%" + search + "%'";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result = rs.getInt(1);
				}
			}catch(Exception e) {e.printStackTrace();}
			finally {close(conn, pstmt, rs);}
			return result;
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
			rs.next(); // max값이 null이어도 rs.next()는 true로 나오므로 한번 소비
			if(rs.getInt(1)>0) {	// 새글 또는 댓글
				num = rs.getInt(1)+1; 
				if(dto.getRef().equals("null")) { //새글일때
					ref = num;	// 새글일때는 ref와 Num은 일치
					re_step = 0;
					re_level = 0;
				}else { //댓글일때
					ref = Integer.parseInt(dto.getRef());	// 댓글은 읽은 글의 ref와 동일
					re_step = Integer.parseInt(dto.getRe_step()) + 1;	//읽은 글의 step의 밑 단계로 끼어들기
					// 그 이후의 re_step값들 +1하기
					// re_step 증가시키기
					sql = "update board set re_step=re_step+1 where ref=? and re_step>=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					pstmt.setInt(2, re_step);
					pstmt.executeUpdate();
					re_level = Integer.parseInt(dto.getRe_level()) + 1;	//읽은 글의 level에서 한단계 들여쓰기(가 댓글)
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
	// 전체 글 중에서 가져오기
	public List callRecords(int startNum, int endNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List records = new ArrayList();
		BoardDTO dto = null;
		try {
			conn = getConnection();
			// 정렬 sql 정렬순서 ref열의 내림차순, ref가 동일할 시 step의 내림차수 
			String sql = "SELECT * FROM (SELECT rownum r, A.* FROM (SELECT * FROM board ORDER by ref asc, re_step desc)A) WHERE ?>=r AND r>=? ORDER BY r desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startNum);
			pstmt.setInt(2, endNum);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getInt("num")>0) {
					dto = new BoardDTO();
					dto.setNum(Integer.toString(rs.getInt("num")));
					dto.setWriter(rs.getString("writer"));
					dto.setSubject(rs.getString("subject"));
					dto.setEmail(rs.getString("email"));
					dto.setContent(rs.getString("content"));
					dto.setPw(rs.getString("pw"));
					dto.setReg(rs.getTimestamp("reg"));
					dto.setReadcount(Integer.toString(rs.getInt("readcount")));
					dto.setRef(Integer.toString(rs.getInt("ref")));
					dto.setRe_step(Integer.toString(rs.getInt("re_step")));
					dto.setRe_level(Integer.toString(rs.getInt("re_level")));
					dto.setImg(rs.getString("img"));
					records.add(dto);
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		return records;
	}
	
	// 조건에 맞는 글 중에서 불러온다.
		public List callRecords(int startNum, int endNum, String sel, String search) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List records = new ArrayList();
			BoardDTO dto = null;
			try {
				conn = getConnection();
				// 정렬 sql
				String sql = "SELECT * FROM (SELECT * FROM (SELECT rownum r, A.* FROM (SELECT * FROM board WHERE ("+sel+" like '%"+search+"%') ORDER by ref asc, re_step desc)A) ORDER BY r desc) WHERE ?>=r AND r>=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, startNum);
				pstmt.setInt(2, endNum);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					if(rs.getInt("num")>0) {
						dto = new BoardDTO();
						dto.setNum(Integer.toString(rs.getInt("num")));
						dto.setWriter(rs.getString("writer"));
						dto.setSubject(rs.getString("subject"));
						dto.setEmail(rs.getString("email"));
						dto.setContent(rs.getString("content"));
						dto.setPw(rs.getString("pw"));
						dto.setReg(rs.getTimestamp("reg"));
						dto.setReadcount(Integer.toString(rs.getInt("readcount")));
						dto.setRef(Integer.toString(rs.getInt("ref")));
						dto.setRe_step(Integer.toString(rs.getInt("re_step")));
						dto.setRe_level(Integer.toString(rs.getInt("re_level")));
						dto.setImg(rs.getString("img"));
						records.add(dto);
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(conn, pstmt, rs);
			}
			return records;
		}
	
	public BoardDTO callRecord(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardDTO dto = null;
		try {
			conn = getConnection();
			// 조회수 증가
			String sql = "update board set readcount=readcount+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			// 글 가져오기
			sql = "select * from board where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getInt("num")>0) {
					dto = new BoardDTO();
					dto.setNum(Integer.toString(rs.getInt("num")));
					dto.setWriter(rs.getString("writer"));
					dto.setSubject(rs.getString("subject"));
					dto.setEmail(rs.getString("email"));
					dto.setContent(rs.getString("content"));
					dto.setPw(rs.getString("pw"));
					dto.setReg(rs.getTimestamp("reg"));
					dto.setReadcount(Integer.toString(rs.getInt("readcount")));
					dto.setRef(Integer.toString(rs.getInt("ref")));
					dto.setRe_step(Integer.toString(rs.getInt("re_step")));
					dto.setRe_level(Integer.toString(rs.getInt("re_level")));
					dto.setImg(rs.getString("img"));
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		return dto;
	}
}