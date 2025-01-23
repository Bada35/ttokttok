package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class JwtTokenDto {
    private String grantType;
    private String accessToken;
    private String refreshToken;
}
