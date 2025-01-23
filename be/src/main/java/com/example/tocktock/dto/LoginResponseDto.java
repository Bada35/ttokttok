package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class LoginResponseDto {

    private int id;
    private Long kakaoId;
    private String nickname;
    private String email;
    private String profileImageUrl;
    private String accessToken;
    private String refreshToken;
}
