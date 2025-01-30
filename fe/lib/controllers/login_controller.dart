import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user.dart';
import '../utils/token_storage.dart';

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
      await _processKakaoToken(token);
    } catch (error) {
      await _loginWithKakaoAccount();
    }
  }

  Future<void> _loginWithKakaoAccount() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      await _processKakaoToken(token);
    } catch (error) {
      Get.snackbar('로그인 실패', '카카오계정으로 로그인할 수 없습니다.');
    }
  }

  Future<void> _processKakaoToken(OAuthToken token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Authorization': 'Bearer ${token.accessToken}'},
      );

      if (response.statusCode == 200) {
        // 기존 회원
        final userData = json.decode(response.body);
        Get.offAllNamed('/home');
      } else if (response.statusCode == 404) {
        // 신규 회원
        final user = await UserApi.instance.me();
        Get.toNamed('/register', arguments: {
          'kakaoToken': token.accessToken,
          'email': user.kakaoAccount?.email,
          'nickname': user.kakaoAccount?.profile?.nickname,
        });
      } else {
        throw Exception('서버 오류');
      }
    } catch (error) {
      Get.snackbar('오류', '서버와 통신 중 오류가 발생했습니다.');
    }
  }
}
