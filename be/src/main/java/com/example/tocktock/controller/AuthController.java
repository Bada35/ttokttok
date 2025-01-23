package com.example.tocktock.controller;

import com.example.tocktock.dto.ApiResponseDto;
import com.example.tocktock.dto.JwtTokenDto;
import com.example.tocktock.dto.KakaoUserInfoDto;
import com.example.tocktock.dto.LoginResponseDto;
import com.example.tocktock.entity.User;
import com.example.tocktock.repository.UserRepository;
import com.example.tocktock.service.KakaoAuthService;
import com.example.tocktock.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {

    private final KakaoAuthService kakaoAuthService;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    @GetMapping("/kakao")
    public ResponseEntity<ApiResponseDto<LoginResponseDto>> kakaoAuth(@RequestHeader("Authorization") String authorizationHeader) throws Exception {
        try {
            String KakaoAccessToken = authorizationHeader.substring(7);
            KakaoUserInfoDto userInfo = kakaoAuthService.getUserInfo(KakaoAccessToken);

            Boolean checkUserExists = kakaoAuthService.checkUserExists(userInfo.getEmail());
            if (!checkUserExists) {
                kakaoAuthService.saveUser(userInfo);
                User user = userRepository.findByKakaoId(userInfo.getKakaoId());
                return ApiResponseDto.success("회원가입 & 로그인 성공", kakaoAuthService.kakaoLogin(user.getId(), userInfo));
            }
            User user = userRepository.findByKakaoId(userInfo.getKakaoId());
            return ApiResponseDto.success("로그인 성공", kakaoAuthService.kakaoLogin(user.getId(), userInfo));
        } catch (Exception e) {
            return ApiResponseDto.unauthorized(e.getMessage());
        }
    }

    @PostMapping("/reissue")
    public ResponseEntity<ApiResponseDto<JwtTokenDto>> reissue(String refreshToken) {

        return ApiResponseDto.success("토큰 재발급 성공", jwtUtil.reissueToken(refreshToken));
    }

    @GetMapping("/test")
    public ResponseEntity<ApiResponseDto<String>> test() {

        return ApiResponseDto.success("토큰 재발급 성공");
    }
}
