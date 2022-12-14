package com.bookshop01.admin.board.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.bookshop01.admin.board.vo.BoardVO;
import com.bookshop01.admin.board.vo.Criteria;

public interface BoardDAO {
	
		public List selectBoardList() throws DataAccessException ;
		
		public BoardVO textView(int bno) throws DataAccessException ;
		
		public int deleteTextView(int bno) throws DataAccessException;
		
		public int inerstTextView(BoardVO boardVO) throws DataAccessException;
		
		public int updateTextView(BoardVO boardVO) throws DataAccessException;
		
		public List<BoardVO> getListWithPaging(Criteria cri);
		
		public int countBoardList() throws DataAccessException;
}
