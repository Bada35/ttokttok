package com.example.tocktock.util;

import com.example.tocktock.entity.User;
import com.example.tocktock.repository.UserRepository;
import io.jsonwebtoken.*;
import com.example.tocktock.dto.JwtTokenDto;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtUtil {

    private final Key key;
    private final UserRepository userRepository;

    @Value("${jwt.access.token.expiration}")
    private Long accessTokenExpiration;

    @Value("${jwt.refresh.token.expiration}")
    private Long refreshTokenExpiration;

    public JwtUtil(@Value("${jwt.secretKey}") String secretKey, UserRepository userRepository) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
        this.userRepository = userRepository;
    }

    public JwtTokenDto generateJwtToken(Integer id, String nickname, String profileImageUrl) {

        long now = (new Date()).getTime();

        // access token의 유효기간: 1시간 = 60 * 60 * 1000
        Date accessTokenExpiresIn = new Date(now + accessTokenExpiration);
        String accessToken = Jwts.builder()
                .setSubject(id.toString())
                .claim("nickname", nickname)
                .claim("profileImageUrl", profileImageUrl)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();


        // refreshToken 유효기간: 30일 = 30 * 24 * 60 * 60 * 1000
        Date refreshTokenExpiresIn = new Date(now + refreshTokenExpiration);
        // refresh token 생성
        String refreshToken = Jwts.builder()
                .setSubject(String.valueOf(id))
                .setExpiration(refreshTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        return JwtTokenDto.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    public Integer getUserIdFromAccessToken(String accessToken) {
        // 토큰 복호화
        Claims claims = parseClaims(accessToken);

        return Integer.parseInt(claims.getSubject());
    }

    public String getUserNameFromAccessToken(String accessToken) {
        // 토큰 복호화
        Claims claims = parseClaims(accessToken);

        return claims.get("name", String.class);
    }

    // token 유효성 검증
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch(io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
            throw new MalformedJwtException("invalid jwt token");
        } catch(ExpiredJwtException e) {
            throw new ExpiredJwtException(null,null,"expired jwt token");
        } catch(UnsupportedJwtException e) {
            throw new UnsupportedJwtException("unsupported jwt token");
        }

    }

    // accessToken 복호화
    private Claims parseClaims(String accessToken) {
        try {
            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody();
        } catch(ExpiredJwtException e) { // jwt의 유효시간이 지났음
            return e.getClaims();
        }
    }

    // accessToken 남은 유효기간 구하기
    public Long getExpiration(String accessToken) {
        Date expiration = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody().getExpiration();
        // 현재 시간
        long now = new Date().getTime();
        return (expiration.getTime() - now);
    }

    public JwtTokenDto reissueToken(String refreshToken) {
        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(refreshToken).getBody();
        Integer id = Integer.valueOf(claims.getSubject());
        User user = userRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        String nickname = user.getNickname();
        String profileImageUrl = user.getProfileImageUrl();

        return generateJwtToken(id, nickname, profileImageUrl);
    }
}
