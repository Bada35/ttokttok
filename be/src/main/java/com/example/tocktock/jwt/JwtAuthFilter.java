package com.example.tocktock.jwt;

import com.example.tocktock.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private static final List<String> WHITELIST = Arrays.asList("/api/auth/kakao");
//    private final RedisTemplate<String, Object> redisTemplate;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String requestURI = request.getRequestURI();

        // 화이트리스트에 포함된 엔드포인트는 JWT 검증 생략
        if (WHITELIST.contains(requestURI)) {
            filterChain.doFilter(request, response);
            return;
        }

        String authenticationHeader = request.getHeader("Authorization");

        if (authenticationHeader != null && authenticationHeader.startsWith("Bearer ")) {
            String token = authenticationHeader.substring(7);

            if (jwtUtil.validateToken(token)) {
                Integer id = jwtUtil.getUserIdFromAccessToken(token);
                String name = jwtUtil.getUserNameFromAccessToken(token);
                UserDetailsImpl userDetailsImpl = new UserDetailsImpl(id, name);

                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        userDetailsImpl, null, null);

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }

        filterChain.doFilter(request, response);
    }

}
