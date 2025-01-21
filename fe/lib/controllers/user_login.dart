// controllers/user_login.dart
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'dart:io'; // Platform 사용
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // flutter_dotenv 임포트

import 'user_controller.dart';
import '../utils/token_storage.dart'; // TokenStorage 임포트
import '../home/home_page.dart'; // HomePage 임포트 추가

class LoginController extends GetxController {
  final UserController userController = Get.put(UserController());
  static final String _baseUrl = dotenv.env['BASE_URL']!; // baseUrl 설정

  // 카카오 로그인 및 API 서버로 사용자 데이터 요청
  Future<void> loginWithKakao() async {
    try {
      OAuthToken? token;

      // 환경 확인
      if (kIsWeb) {
        // 웹 환경에서는 카카오 계정 로그인을 사용
        token = await UserApi.instance.loginWithKakaoAccount();
        print('웹 환경에서 카카오 계정으로 로그인 성공: ${token.accessToken}');
      } else if (Platform.isAndroid || Platform.isIOS) {
        // 모바일 앱 환경에서는 카카오톡 간편 로그인 시도
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오톡 앱으로 로그인 성공: ${token.accessToken}');
        } catch (talkLoginError) {
          print('카카오톡 앱 로그인 실패: $talkLoginError');
          token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오 계정으로 로그인 성공: ${token.accessToken}');
        }
      } else {
        throw Exception('지원하지 않는 플랫폼입니다.');
      }

      if (token?.accessToken.isNotEmpty ?? false) {
        // 직접 API 요청을 보내는 부분
        final response = await _sendLoginRequest(token!.accessToken);

        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes))["data"];
          print("서버에서 받은 사용자 데이터: $data");

          // 사용자 정보 업데이트
          await _updateUserInfo(data);

          // HomePage로 이동
          Get.to(() => HomePage());
        } else {
          print("서버 요청 실패: ${response.statusCode}");
          print("응답 내용: ${response.body}");

          // 에러 메시지 표시
          Get.snackbar(
            "로그인 실패",
            "서버에서 유효하지 않은 응답을 받았습니다.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        print("토큰이 유효하지 않습니다.");
      }
    } catch (e) {
      print("API 요청 실패: $e");
    }
  }

  // 사용자 정보를 업데이트하는 메서드
  Future<void> _updateUserInfo(Map<String, dynamic> data) async {
    final userId = data["id"] ?? 0; // null일 경우 0으로 대체
    final kakaoId = data["kakao_id"] ?? 0;
    final nickname = data["nickname"] ?? '';
    final email = data["email"] ?? '';
    final profileImageUrl = data["profileImageUrl"] ?? '';

    final accessToken = data["accessToken"] ?? '';
    final refreshToken = data["refreshToken"] ?? '';

    // 사용자 데이터 저장
    userController.updateUser(
      id: userId,
      kakaoId: kakaoId,
      nickname: nickname,
      email: email,
      profileImageUrl: profileImageUrl,
    );

    // 토큰이 유효한 경우 로컬스토리지에 저장
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      await TokenStorage.saveTokens(accessToken, refreshToken);
      print("토큰이 로컬스토리지에 저장되었습니다.");
    } else {
      print("토큰이 없어서 로컬스토리지에 저장되지 않았습니다.");
    }
  }

  // 로그인 API 요청을 직접 처리
  Future<http.Response> _sendLoginRequest(String accessToken) async {
    final Uri url = Uri.parse("$_baseUrl/api/auth/kakao"); // API URL

    try {
      return await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
    } catch (e) {
      throw Exception("API 요청 실패: $e");
    }
  }
}
