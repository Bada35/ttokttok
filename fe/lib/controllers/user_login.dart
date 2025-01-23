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
import '../pages/home/home_page.dart'; // HomePage 임포트 추가

class LoginController extends GetxController {
  final UserController userController = Get.put(UserController());
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<void> loginWithKakao() async {
    // 임시 로그인 처리
    try {
      // 임시 사용자 데이터
      final Map<String, dynamic> mockData = {
        "id": 1,
        "kakao_id": 12345,
        "nickname": "테스트 사용자",
        "email": "test@example.com",
        "profileImageUrl": "",
        "accessToken": "temp_access_token",
        "refreshToken": "temp_refresh_token"
      };

      // 사용자 정보 업데이트
      await _updateUserInfo(mockData);

      // HomePage로 이동
      Get.to(() => HomePage());
    } catch (e) {
      print("임시 로그인 처리 실패: $e");
      Get.snackbar(
        "로그인 실패",
        "로그인 처리 중 오류가 발생했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    /* 소셜 로그인 복구를 위해 사용됨
    try {
      OAuthToken? token;

      if (kIsWeb) {
        token = await UserApi.instance.loginWithKakaoAccount();
      } else if (Platform.isAndroid || Platform.isIOS) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
        } catch (talkLoginError) {
          token = await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        throw Exception('지원하지 않는 플랫폼입니다.');
      }

      if (token?.accessToken.isNotEmpty ?? false) {
        final response = await _sendLoginRequest(token!.accessToken);
        
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes))["data"];
          await _updateUserInfo(data);
          Get.to(() => HomePage());
        }
      }
    } catch (e) {
      print("API 요청 실패: $e");
    }
    */
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
