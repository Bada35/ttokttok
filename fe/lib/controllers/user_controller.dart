// controllers/user_controller.dart
import 'package:get/get.dart';

class UserController extends GetxController {
  // 사용자 데이터
  var id = 0.obs;
  var kakaoId = 0.obs;
  var nickname = ''.obs;
  var email = ''.obs;
  var profileImageUrl = ''.obs;

  // 사용자 정보 업데이트
  void updateUser({
    required int id,
    required int kakaoId,
    required String nickname,
    required String email,
    required String profileImageUrl,
  }) {
    this.id.value = id;
    this.kakaoId.value = kakaoId;
    this.nickname.value = nickname;
    this.email.value = email;
    this.profileImageUrl.value = profileImageUrl;
  }
}
