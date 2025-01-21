# \lib
```
// main.dart
// 앱의 시작
import 'dart:io'; // 플랫폼 구분을 위한 패키지 추가
import 'package:flutter/foundation.dart' show kIsWeb; // 웹 구분을 위한 플래그 추가

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:get/get.dart';
import './splash/splash_page.dart'; // SplashPage 임포트 추가

void main() {
  // 웹 환경인지 확인
  if (kIsWeb) {
    // 웹 전용 초기화 로직
    KakaoSdk.init(
      javaScriptAppKey: 'ac1d7350a0ed33d54d982bfb88937541',
    );
  }
  // 안드로이드 환경인지 확인
  else if (Platform.isAndroid) {
    // Android 전용 초기화 로직
    KakaoSdk.init(
      nativeAppKey: 'd86001ed71db96a40261eb31723e3745',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '똑똑',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(), // 스플래시 페이지를 처음에 띄움
    );
  }
}
```


```
// 앱 메인화면
// lib\home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 페이지 임포트
import './dutchpay/dutch_alone.dart';
import './dutchpay/dutch_together.dart';
import './info_page.dart';
import './user_page.dart';
import './controllers/user_controller.dart';

// 홈페이지 코드
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height, // 전체 화면 크기
            decoration: ShapeDecoration(
              color: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Stack(
              children: [
                // 좌측 상단 아이콘
                Positioned(
                  left: width * 0.05, // 화면 너비의 5%
                  top: height * 0.12, // 화면 높이의 12%
                  child: SizedBox(
                    width: width * 0.1, // 화면 너비의 10%
                    height: height * 0.05, // 화면 높이의 5%
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/app_logo_word.png')
                        )
                      )
                    )
                  ),
                ),

                // 혼자 정산하기, 같이 정산하기 카드 (좌측 카드)
                Positioned(
                  left: width * 0.05,
                  top: height * 0.29,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DutchAlone(),
                        ),
                      );
                    },
                    child: Container(
                      width: width * 0.43, // 화면 너비의 43%
                      height: height * 0.25, // 화면 높이의 25%
                      decoration: ShapeDecoration(
                        color: Color(0xFF22BE67).withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '혼자\n정산하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 같이 정산하기 카드 (우측 카드)
                Positioned(
                  left: width * 0.51,
                  top: height * 0.29,
                  child: Container(
                    width: width * 0.43,
                    height: height * 0.25,
                    decoration: ShapeDecoration(
                      color: Color(0xFF22BE67).withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '같이\n정산하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                // 상단 메시지
                Positioned(
                  left: width * 0.05,
                  top: height * 0.18,
                  child: Container(
                    width: width * 0.89,
                    height: height * 0.09,
                    decoration: ShapeDecoration(
                      color: Color(0xFF22BE67).withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: width * 0.12,
                  top: height * 0.20,
                  child: const Text(
                    '똑똑~\n정산 요청이 2건 있어요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // 하단 버튼 영역
                Positioned(
                  left: width * 0.05,
                  top: height * 0.56,
                  child: Container(
                    width: width * 0.89,
                    height: height * 0.07,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: width * 0.12,
                  top: height * 0.58,
                  child: const Text(
                    '똑똑 이용법',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  left: width * 0.77,
                  top: height * 0.58,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      '알아보기',
                      style: TextStyle(
                        color: Color(0xFF22BE67),
                        fontSize: 9,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // 하단 네비게이션 바
                Positioned(
                  left: 0,
                  top: height * 0.88,
                  child: Container(
                    width: width,
                    height: height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),

                // 하단 네비게이션 아이콘들
                Positioned(
                  left: width * 0.13,
                  top: height * 0.90,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF22BE67),
                    radius: 17,
                    child: Icon(Icons.home, color: Colors.white),
                  ),
                ),
                Positioned(
                  left: width * 0.45,
                  top: height * 0.90,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 17,
                    child: Icon(Icons.account_circle, color: Colors.white),
                  ),
                ),
                Positioned(
                  left: width * 0.77,
                  top: height * 0.90,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 17,
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                ),

                // 우측 상단 알림 아이콘
                Positioned(
                  left: width * 0.93,
                  top: height * 0.12,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

```
// info_page.dart
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```


```
// user_page.dart
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```


## \splash
```
// splash_page.dart
// 앱 시작 시 잠깐 보여지는 페이지
// 3초 뒤 로그인 페이지로 이동
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 상태관리 라이브러리
import './login_page.dart'; // LoginPage 임포트 추가

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 스플래시 화면을 일정 시간 후에 자동으로 로그인 페이지로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });

    // 화면 크기 가져오기
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width, // 화면 너비
          height: screenSize.height, // 화면 높이
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF22BE67),
          ),
          child: Stack(
            children: [
              Positioned(
                left: (screenSize.width * 0.9) / 2, // 중앙 정렬
                top: (screenSize.height * 0.8 - 83.65) / 2, // 중앙 정렬
                child: Container(
                  width: 92,
                  height: 83.65,
                  // 앱 로고를 보여주는 컨테이너
                  child:
                      Image.asset('assets/images/app_logo.jpg'), // 앱 로고 이미지 추가
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

```
// lib\splash\login_page.dart
// 앱 시작시 보여지는 로그인 페이지
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // getx
import 'package:flutter/foundation.dart' show kIsWeb; // 웹 구분을 위한 플래그 추가
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'; // 카카오sdk
import 'package:http/http.dart' as http; // HTTP 패키지 추가
import 'dart:convert'; // JSON 처리

// 연결된 페이지
import '../controllers/user_controller.dart';
import '../home_page.dart'; // HomePage 임포트 추가

// 카카오 소셜 로그인 기능
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // // 서버에 토큰 전송
  // Future<void> _sendTokenToServer(String token) async {
  //   final url = Uri.parse('-----/api/auth'); // 서버 URL
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Authorization": "Bearer $token",
  //       "Content-Type": "application/json",
  //     },
  //   );
  //
  //   if (response.statusCode == 201) {
  //     final responseData = json.decode(response.body);
  //     final newAccessToken = responseData['data']['access_token'];
  //     final refreshToken = responseData['data']['refresh_token'];
  //
  //     // UserController에 저장
  //     final UserController userController = Get.find<UserController>();
  //     userController.setUser(newAccessToken, refreshToken);
  //     print('서버에서 토큰 수신 성공: $newAccessToken');
  //   } else {
  //     print('서버와의 통신 실패: ${response.statusCode}');
  //   }
  // }

  // 로그인 로직
  Future<void> _loginWithKakao(BuildContext context) async {
    // Get.put()을 사용해 UserController 인스턴스를 전역으로 등록
    final UserController userController = Get.put(UserController());

    if (kIsWeb) {
      // 웹에서 카카오 계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정으로 웹에서 로그인 성공');

        // UserController 인스턴스를 가져오고 토큰으로 사용자 정보 로드
        final UserController userController = Get.put(UserController());
        // 토큰으로 사용자 정보 로드
        await userController.fetchUserInfo(token.accessToken);

        // 로그인 성공 후 홈 페이지로 이동
        Get.to(() => const HomePage());
      } catch (error) {
        print('카카오 계정으로 로그인 실패 $error');
      }
    } else {
      // Android 또는 iOS에서 카카오톡으로 로그인 시도
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');

        // UserController 인스턴스를 가져오고 토큰으로 사용자 정보 로드
        final UserController userController = Get.put(UserController());
        // 토큰으로 사용자 정보 로드
        await userController.fetchUserInfo(token.accessToken);

        // 로그인 성공 후 홈 페이지로 이동
        Get.to(() => const HomePage());
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        // 카카오톡 로그인 실패 시, 카카오 계정으로 로그인 시도
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오 계정으로 로그인 성공');

          // UserController 인스턴스를 가져오고 토큰으로 사용자 정보 로드
          final UserController userController = Get.put(UserController());
          // 토큰으로 사용자 정보 로드
          await userController.fetchUserInfo(token.accessToken);

          // 로그인 성공 후 홈 페이지로 이동
          Get.to(() => const HomePage());
        } catch (accountError) {
          print('카카오 계정으로 로그인 실패 $accountError');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // 화면 크기 가져오기

    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width, // 전체 너비
          height: screenSize.height, // 전체 높이
          decoration: BoxDecoration(
            color: Color(0xFF22BE67),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 환영 메시지와 디자인 요소 추가
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenSize.width * 0.9, // 90% 너비
                    height: screenSize.height * 0.5, // 50% 높이
                    decoration: BoxDecoration(
                      color: Color(0xFF22BE67),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '더 ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: screenSize.width * 0.1, // 반응형 폰트 크기
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: '똑똑',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width * 0.1, // 반응형 폰트 크기
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' 해진 더치페이,\n',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: screenSize.width * 0.1, // 반응형 폰트 크기
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: '똑똑',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width * 0.1, // 반응형 폰트 크기
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' 과 함께',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: screenSize.width * 0.1, // 반응형 폰트 크기
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // 간격 추가
              GestureDetector(
                onTap: () => _loginWithKakao(context),
                child: Container(
                  width: screenSize.width * 0.8, // 버튼 너비
                  height: screenSize.height * 0.2, // 버튼 높이
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/kakao_login_original.psd'), // 카카오 로그인 이미지
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

## \dutchpay
```
// dutch_alone.dart 파일은 혼자 정산하기 페이지를 구현합니다.
// 혼자 정산하기
import 'package:flutter/material.dart';

class DutchAlone extends StatelessWidget {
  const DutchAlone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('혼자 정산하기'),
      ),
      body: Center(
        child: const Text('여기에 혼자 정산하기 페이지 내용을 추가하세요.'),
      ),
    );
  }
}
```

```
// dutch_together.dart
import 'package:flutter/material.dart';

class DutchTogether extends StatelessWidget {
  const DutchTogether({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
```