import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';

class AdjustmentPage extends StatefulWidget {
  const AdjustmentPage({super.key});

  @override
  _AdjustmentPageState createState() => _AdjustmentPageState();
}

class _AdjustmentPageState extends State<AdjustmentPage> {
  String selectedTab = "정산 중";
  final List<Map<String, dynamic>> adjustmentData = [
    {"id": 1, "title": "똑똑팀", "amount": "금액 미입력"},
    {"id": 2, "title": "홍길동 외 2인", "amount": "총 26,500원"},
    {"id": 3, "title": "김유진", "amount": "총 4,000원"},
  ];
  String dropdownValue = "전체";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "정산 목록",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              print("방 생성 버튼 클릭");
            },
            child: const Text(
              "방 생성",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: const [
          // ... 기존 body 내용 유지
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
