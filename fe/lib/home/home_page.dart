// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 페이지 이동을 위한 import
import 'info_page.dart';
import '../pages/user/user_page.dart';
import '../pages/adjustment_page.dart';
import '../widgets/logo_and_notification.dart';
import '../widgets/user_info_container.dart';
import '../widgets/dutch_pay_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
          children: [
            const SizedBox(height: 50), // 상단 여백

            // 로고와 알림 아이콘
            LogoAndNotification(width: size.width, height: size.height),

            // 사용자 정보 컨테이너
            UserInfoContainer(width: size.width),

            const SizedBox(height: 16.0), // 컨테이너 사이 여백

            // 혼자 정산하기 & 같이 정산하기
            DutchPayOptions(width: size.width),

            const SizedBox(height: 16.0), // 컨테이너 사이 여백

            // 앱 정보 컨테이너
            GestureDetector(
              onTap: () {
                Get.to(() => InfoPage());
              },
              child: Container(
                width: size.width * 0.8, // maxWidth 적용
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '똑똑 이용법 알아보기',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 네비게이션 바
            BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: '정산 목록',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '내 정보',
                ),
              ],
              selectedItemColor: const Color(0xFF22BE67),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              onTap: (index) {
                switch (index) {
                  case 0: // 홈
                    Get.to(() => const HomePage());
                    break;
                  case 1: // 정산 목록
                    Get.to(() => const AdjustmentPage());
                    break;
                  case 2: // 내 정보
                    Get.to(() => const UserPage());
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
