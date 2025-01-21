// test/controllers/user_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fe/controllers/user_controller.dart';

void main() {
  group('UserController Test', () {
    late UserController userController;

    setUp(() {
      userController = Get.put(UserController());
    });

    tearDown(() {
      Get.delete<UserController>();
    });

    test('임시 데이터를 설정하고 검증합니다.', () {
      // 임시 데이터 설정
      userController.updateUser(
        id: 1,
        kakaoId: 12345,
        nickname: '임시 닉네임',
        email: 'test@example.com',
        profileImageUrl: 'https://via.placeholder.com/150',
        accessToken: '임시 액세스 토큰',
        refreshToken: '임시 리프레시 토큰',
      );

      // 데이터 검증
      expect(userController.id.value, 1);
      expect(userController.kakaoId.value, 12345);
      expect(userController.nickname.value, '임시 닉네임');
      expect(userController.email.value, 'test@example.com');
      expect(userController.profileImageUrl.value,
          'https://via.placeholder.com/150');
      expect(userController.accessToken.value, '임시 액세스 토큰');
      expect(userController.refreshToken.value, '임시 리프레시 토큰');
    });
  });
}
