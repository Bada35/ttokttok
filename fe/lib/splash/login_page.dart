// lib\splash\login_page.dart
// 앱 시작시 보여지는 로그인 페이지
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // getx

// 연결된 페이지
import '../controllers/user_login.dart';

// 카카오 소셜 로그인 기능
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final screenSize = MediaQuery.of(context).size;

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
              const SizedBox(height: 10), // 간격 추가
              GestureDetector(
                onTap: () => loginController.loginWithKakao(),
                child: Container(
                  width: screenSize.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFEE500),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '카카오톡으로 시작하기',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
