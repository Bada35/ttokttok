// splash_page.dart
// 앱 시작 3초 뒤 로그인 페이지로 이동
import 'package:flutter/material.dart';
import './login_page.dart'; // LoginPage 임포트 추가
// 임시용 메인으로 바로가는
// import '../home/home_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 스플래시 화면을 일정 시간 후에 자동으로 로그인 페이지로 이동
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        // 임시로 넣을게
        // MaterialPageRoute(builder: (context) => const HomePage()),
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
                left: (screenSize.width * 0.8) / 2, // 중앙 정렬
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
