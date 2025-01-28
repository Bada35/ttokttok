import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdjustmentCompletePage extends StatelessWidget {
  const AdjustmentCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 76,
              height: 76,
              child: SvgPicture.asset(
                'assets/images/green_check.svg',
              ),
            ),
            const SizedBox(height: 36),
            const Text(
              '정산 요청을 완료했어요',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333D48),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '정산이 완료되면 알려드릴게요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // 정산 목록 페이지로 돌아가기
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/adjustment-list',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22BE67),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
