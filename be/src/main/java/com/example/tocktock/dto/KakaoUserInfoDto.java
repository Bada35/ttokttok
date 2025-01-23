package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KakaoUserInfoDto {

    private Long kakaoId;
    private String nickname;
    private String email;
    private String profileImageUrl;
}
