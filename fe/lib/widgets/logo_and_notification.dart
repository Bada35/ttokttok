// widgets/logo_and_notification.dart
import 'package:flutter/material.dart';

class LogoAndNotification extends StatelessWidget {
  final double width;
  final double height;

  const LogoAndNotification({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: width * 0.8, // 전체 너비의 80%로 제한
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 로고를 양옆에 배치
          children: [
            // 로고
            Image.asset(
              'assets/images/app_logo_word.png',
              height: 40,
            ),
            // 알림 아이콘
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: height * 0.3,
                    child: const Center(
                      child: Text("알림창 내용"),
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
