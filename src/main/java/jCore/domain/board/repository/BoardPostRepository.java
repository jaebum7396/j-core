package jCore.domain.board.repository;

import jCore.domain.board.model.entity.Board;
import jCore.domain.board.model.entity.BoardPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardPostRepository extends JpaRepository<BoardPost, String>, QuerydslPredicateExecutor<BoardPost>, BoardPostRepositoryQ {
}