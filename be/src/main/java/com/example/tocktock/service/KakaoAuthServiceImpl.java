package com.example.tocktock.service;

import com.example.tocktock.dto.JwtTokenDto;
import com.example.tocktock.dto.KakaoUserInfoDto;
import com.example.tocktock.dto.LoginResponseDto;
import com.example.tocktock.entity.User;
import com.example.tocktock.repository.UserRepository;
import com.example.tocktock.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class KakaoAuthServiceImpl implements KakaoAuthService{

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final RedisTemplate<String, Object> redisTemplate;

    @Value("${jwt.refresh.token.expiration}")
    private Long refreshTokenExpiration;


    @Override
    public KakaoUserInfoDto getUserInfo(String KakaoAccessToken) throws Exception {

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + KakaoAccessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(headers);
        ResponseEntity<String> response = restTemplate.exchange(
                "https://kapi.kakao.com/v2/user/me" +
                        "?secure_resource=true" +
                        "&property_keys=[\"kakao_account.profile.nickname\",\"kakao_account.profile.profile_image_url\", \"kakao_account.email\"]",
                HttpMethod.GET,
                httpEntity,
                String.class
        );

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(response.getBody());
        JSONObject kakaoAccount = (JSONObject) jsonObj.get("kakao_account");
        JSONObject profile = (JSONObject) kakaoAccount.get("profile");

        Long kakaoId = (Long) jsonObj.get("id");
        String nickname = (String) profile.get("nickname");
        String profileImageUrl = (String) profile.get("profile_image_url");
        String email = (String) kakaoAccount.get("email");

        return KakaoUserInfoDto.builder()
                .kakaoId(kakaoId)
                .nickname(nickname)
                .email(email)
                .profileImageUrl(profileImageUrl)
                .build();
    }

    @Override
    public Boolean checkUserExists(String email) throws Exception {
        return userRepository.existsByEmail(email);
    }

    @Override
    public void saveUser(KakaoUserInfoDto userInfo) throws Exception {
        User user = User.builder()
                .kakaoId(userInfo.getKakaoId())
                .email(userInfo.getEmail())
                .nickname(userInfo.getNickname())
                .profileImageUrl(userInfo.getProfileImageUrl())
                .build();

        userRepository.save(user);
    }

    @Override
    public LoginResponseDto kakaoLogin(Integer id, KakaoUserInfoDto userInfo) throws Exception {

        JwtTokenDto jwtTokenDto = jwtUtil.generateJwtToken(id, userInfo.getNickname(), userInfo.getProfileImageUrl());
        redisTemplate.opsForValue()
                .set("RT: "+userInfo.getEmail(), jwtTokenDto.getRefreshToken(), refreshTokenExpiration, TimeUnit.MILLISECONDS);
        return LoginResponseDto.builder()
                .id(id)
                .kakaoId(userInfo.getKakaoId())
                .nickname(userInfo.getNickname())
                .email(userInfo.getEmail())
                .profileImageUrl(userInfo.getProfileImageUrl())
                .accessToken(jwtTokenDto.getAccessToken())
                .refreshToken(jwtTokenDto.getRefreshToken())
                .build();
    }
}
