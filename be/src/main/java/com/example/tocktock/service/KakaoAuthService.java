package com.example.tocktock.service;

import com.example.tocktock.dto.KakaoUserInfoDto;
import com.example.tocktock.dto.LoginResponseDto;

public interface KakaoAuthService {
    KakaoUserInfoDto getUserInfo(String KakaoAccessToken) throws Exception;
    Boolean checkUserExists(String email) throws Exception;
    void saveUser(KakaoUserInfoDto userInfo) throws Exception;
    LoginResponseDto kakaoLogin(Integer id, KakaoUserInfoDto userInfo) throws Exception;
}
