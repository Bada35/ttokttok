import 'dart:async';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pages/home/home_page.dart';
import 'user_controller.dart';

class LoginController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  static final String _baseUrl = dotenv.env['BASE_URL']!;
  final UserController userController = Get.find<UserController>();

  Future<void> loginWithKakao() async {
    if (_isLoading.value) return;

    _isLoading.value = true;
    try {
      bool hasToken = await AuthApi.instance.hasToken();
      if (hasToken) {
        try {
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

          User user = await UserApi.instance.me();
          await _processKakaoLogin(
              await AuthApi.instance.refreshToken() ?? tokenInfo.accessToken);
        } catch (error) {
          print('토큰 정보 조회 실패: $error');
          await _loginProcess();
        }
      } else {
        print('발급된 토큰 없음');
        await _loginProcess();
      }
    } catch (e) {
      print('로그인 프로세스 실패: $e');
      _handleError('로그인 처리 중 문제가 발생했습니다.');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loginProcess() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패: $error');
          if (error is PlatformException && error.code == 'CANCELED') {
            _handleError('로그인이 취소되었습니다.');
            return;
          }
          token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      }
      await _processKakaoLogin(token);
    } catch (e) {
      print('로그인 프로세스 실패: $e');
      _handleError('로그인 처리 중 문제가 발생했습니다.');
    }
  }

  Future<void> _processKakaoLogin(OAuthToken token) async {
    try {
      User user = await UserApi.instance.me();

      await userController.updateUser(
        id: user.id.toInt(),
        kakaoId: user.id.toInt(),
        nickname: user.kakaoAccount?.profile?.nickname ?? '',
        email: user.kakaoAccount?.email ?? '',
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl ?? '',
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );

      Get.offAll(() => const HomePage());
    } catch (e) {
      print('사용자 정보 처리 실패: $e');
      _handleError('사용자 정보를 가져오는데 실패했습니다.');
    }
  }

  void _handleError(String message) {
    Get.snackbar(
      '오류',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // 로그아웃 기능 추가
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      await userController.clearUser(); // UserController에 clearUser 메서드 필요
      Get.offAll(() => const HomePage()); // 또는 로그인 페이지로 이동
    } catch (e) {
      print('로그아웃 실패: $e');
      _handleError('로그아웃 처리 중 문제가 발생했습니다.');
    }
  }
}
