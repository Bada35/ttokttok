import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/logo_and_notification.dart';
import '../widgets/user_info_container.dart';
import '../widgets/dutch_pay_options.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          const SizedBox(height: 50),
          LogoAndNotification(width: size.width, height: size.height),
          UserInfoContainer(width: size.width),
          const SizedBox(height: 16.0),
          DutchPayOptions(width: size.width),
          const SizedBox(height: 16.0),
          // 앱 정보 컨테이너
          // ... 기존 코드 유지
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
