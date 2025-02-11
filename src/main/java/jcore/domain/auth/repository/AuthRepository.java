package jcore.domain.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jcore.domain.user.model.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface AuthRepository extends JpaRepository<User,String> {
    Optional<User> findByUserCd(String userCd);
    Optional<User> findByUserId(String userId);
    List<User> findAll();
}