package jcore.domain.board.repository;

import jcore.domain.board.model.entity.Board;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardRepository extends JpaRepository<Board, String>, QuerydslPredicateExecutor<Board>, BoardRepositoryQ {
}