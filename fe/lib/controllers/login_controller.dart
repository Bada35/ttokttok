import 'dart:async';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<void> loginWithKakao() async {
    _isLoading.value = true;
    try {
      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        await _loginWithKakaoTalk();
      } else {
        await _loginWithKakaoAccount();
      }
    } catch (error) {
      Get.snackbar('로그인 실패', '로그인 중 오류가 발생했습니다.');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loginWithKakaoTalk() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡 로그인 성공: ${token.accessToken}'); // 디버깅용
      await _processKakaoToken(token);
    } catch (error) {
      print('카카오톡 로그인 에러: $error'); // 디버깅용
      if (error is PlatformException && error.code == 'CANCELED') {
        // 사용자가 취소한 경우
        return;
      }
      // 다른 에러의 경우 카카오계정으로 로그인 시도
      await _loginWithKakaoAccount();
    }
  }

  Future<void> _loginWithKakaoAccount() async {
    try {
      print('=== 카카오계정 로그인 시작 ===');
      print('카카오계정 로그인 시도');

      // 로그인 시도 전 상태 확인
      final installed = await isKakaoTalkInstalled();
      print('카카오톡 설치 여부: $installed');

      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정 로그인 성공: ${token.accessToken}');

      // 사용자 정보 요청
      print('사용자 정보 요청 시작');
      User user = await UserApi.instance.me();
      print('사용자 정보: ${user.id}, ${user.kakaoAccount?.email}');

      await _processKakaoToken(token);
    } catch (error) {
      print('=== 카카오계정 로그인 에러 상세 ===');
      print('에러 타입: ${error.runtimeType}');
      print('에러 메시지: $error');
      if (error is PlatformException) {
        print('PlatformException 코드: ${error.code}');
        print('PlatformException 메시지: ${error.message}');
        print('PlatformException 상세: ${error.details}');
      }
      Get.snackbar('로그인 실패', '카카오계정으로 로그인할 수 없습니다.');
    }
  }

  Future<void> _processKakaoToken(OAuthToken token) async {
    try {
      print('토큰 처리 시작');
      print('서버 URL: $_baseUrl/api/auth/login'); // URL 확인
      print('토큰 값: ${token.accessToken}'); // 토큰 값 확인

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
          'Content-Type': 'application/json', // Content-Type 헤더 추가
        },
      ).timeout(
        // 타임아웃 추가
        const Duration(seconds: 10),
        onTimeout: () {
          print('서버 요청 타임아웃');
          throw TimeoutException('서버 요청 시간 초과');
        },
      );

      print('서버 응답 코드: ${response.statusCode}');
      print('서버 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        print('파싱된 유저 데이터: $userData');
        Get.offAllNamed('/home');
      } else if (response.statusCode == 404) {
        final user = await UserApi.instance.me();
        print(
            '카카오 사용자 정보: ${user.kakaoAccount?.email}, ${user.kakaoAccount?.profile?.nickname}');
        Get.toNamed('/register', arguments: {
          'kakaoToken': token.accessToken,
          'email': user.kakaoAccount?.email,
          'nickname': user.kakaoAccount?.profile?.nickname,
        });
      } else {
        print('예상치 못한 상태 코드: ${response.statusCode}');
        throw Exception('서버 오류 (상태 코드: ${response.statusCode})');
      }
    } catch (error) {
      print('토큰 처리 중 에러 발생: $error');
      print('에러 타입: ${error.runtimeType}');
      if (error is TimeoutException) {
        Get.snackbar('오류', '서버 응답 시간이 초과되었습니다.');
      } else {
        Get.snackbar('오류', '서버와 통신 중 오류가 발생했습니다.');
      }
    }
  }
}
