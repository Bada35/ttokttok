// lib/controllers/api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../utils/token_storage.dart'; // TokenStorage 임포트
import 'user_login.dart'; // 로그인 로직 임포트

class API {
  static final String _baseUrl = dotenv.env['BASE_URL']!; // baseUrl 설정

  // 공통 헤더 가져오기
  static Future<Map<String, String>> _getHeaders() async {
    try {
      final tokens = await TokenStorage.getTokens();
      String? accessToken = tokens['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        print("토큰이 없습니다. 로그인 진행 중...");
        await Get.find<LoginController>().loginWithKakao();
        accessToken = (await TokenStorage.getTokens())['accessToken'];
      }

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("로그인 후에도 유효한 토큰을 가져오지 못했습니다.");
      }

      return {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      };
    } catch (e) {
      throw Exception("헤더 생성 실패: $e");
    }
  }

  // POST 요청
  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final Uri url = Uri.parse("$_baseUrl$endpoint");
    final headers = await _getHeaders();

    try {
      return await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
    } catch (e) {
      throw Exception("POST 요청 실패: $e");
    }
  }

  // GET 요청
  static Future<http.Response> get(String endpoint) async {
    final Uri url = Uri.parse("$_baseUrl$endpoint");
    final headers = await _getHeaders();

    try {
      return await http.get(
        url,
        headers: headers,
      );
    } catch (e) {
      print("GET 요청 실패: $e");
      // 전역 에러 처리
      Get.snackbar(
        "네트워크 오류",
        "GET 요청 중 문제가 발생했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
      throw Exception("GET 요청 실패: $e");
    }
  }
}
