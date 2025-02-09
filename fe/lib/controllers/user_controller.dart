import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  // 사용자 데이터
  var id = 0.obs;
  var kakaoId = 0.obs;
  var nickname = ''.obs;
  var email = ''.obs;
  var profileImageUrl = ''.obs;
  var accessToken = ''.obs;
  var refreshToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // 앱 시작시 저장된 사용자 정보 로드
  }

  // 사용자 정보 업데이트
  Future<void> updateUser({
    required int id,
    required int kakaoId,
    required String nickname,
    required String email,
    required String profileImageUrl,
    required String accessToken,
    required String refreshToken,
  }) async {
    // 메모리상의 데이터 업데이트
    this.id.value = id;
    this.kakaoId.value = kakaoId;
    this.nickname.value = nickname;
    this.email.value = email;
    this.profileImageUrl.value = profileImageUrl;
    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;

    // SharedPreferences에 데이터 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
    await prefs.setInt('kakaoId', kakaoId);
    await prefs.setString('nickname', nickname);
    await prefs.setString('email', email);
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 저장된 사용자 정보 로드
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    id.value = prefs.getInt('id') ?? 0;
    kakaoId.value = prefs.getInt('kakaoId') ?? 0;
    nickname.value = prefs.getString('nickname') ?? '';
    email.value = prefs.getString('email') ?? '';
    profileImageUrl.value = prefs.getString('profileImageUrl') ?? '';
    accessToken.value = prefs.getString('accessToken') ?? '';
    refreshToken.value = prefs.getString('refreshToken') ?? '';
  }

  // 사용자 정보 초기화 (로그아웃)
  Future<void> clearUser() async {
    // 메모리상의 데이터 초기화
    id.value = 0;
    kakaoId.value = 0;
    nickname.value = '';
    email.value = '';
    profileImageUrl.value = '';
    accessToken.value = '';
    refreshToken.value = '';

    // SharedPreferences에서 데이터 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('kakaoId');
    await prefs.remove('nickname');
    await prefs.remove('email');
    await prefs.remove('profileImageUrl');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  // 로그인 상태 확인
  bool get isLoggedIn => accessToken.value.isNotEmpty;
}
