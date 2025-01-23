package com.example.tocktock.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Table(name = "user")
public class User extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "kakao_id", nullable = false)
    @NotNull
    private Long kakaoId;

    @Column(name = "email", nullable = false)
    @NotNull
    private String email;

    @Column(name = "nickname", nullable = false)
    @NotNull
    private String nickname;

    @Column(name = "profile_image_url")
    private String profileImageUrl;
}
