package com.example.tocktock.repository;

import com.example.tocktock.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    User save(User user);
    Boolean existsByEmail(String email);

    boolean existsByKakaoId(Long participant);

    User findByKakaoId(Long participant);
}
