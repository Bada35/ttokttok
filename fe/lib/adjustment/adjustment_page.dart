import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/home/home_page.dart';
import '../pages/user/user_page.dart';

class AdjustmentPage extends StatefulWidget {
  const AdjustmentPage({super.key});

  @override
  _AdjustmentPageState createState() => _AdjustmentPageState();
}

class _AdjustmentPageState extends State<AdjustmentPage> {
  String selectedTab = "정산 중"; // 현재 선택된 탭
  final List<Map<String, dynamic>> adjustmentData = [
    {"id": 1, "title": "똑똑팀", "amount": "금액 미입력"},
    {"id": 2, "title": "홍길동 외 2인", "amount": "총 26,500원"},
    {"id": 3, "title": "김유진", "amount": "총 4,000원"},
  ];

  String dropdownValue = "전체"; // 드롭다운 초기 값

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              // 방 생성 페이지로 이동하는 기능
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
        children: [
          // 드롭다운과 검색 버튼
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                      print("드롭다운 값 변경: $dropdownValue");
                    });
                  },
                  items: ["전체", "최근 1주", "최근 1달"]
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // 검색 버튼 클릭 로직
                    print("검색 버튼 클릭");
                  },
                ),
              ],
            ),
          ),

          // 탭 선택 영역
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "정산 중" 탭
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = "정산 중";
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "정산 중",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedTab == "정산 중"
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.4, // 탭의 폭 균등 분배
                        height: 2,
                        color: selectedTab == "정산 중"
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                // "정산 완료" 탭
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = "정산 완료";
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "정산 완료",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedTab == "정산 완료"
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.4, // 탭의 폭 균등 분배
                        height: 2,
                        color: selectedTab == "정산 완료"
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 정산 목록 (스크롤 가능)
          Expanded(
            child: ListView.builder(
              itemCount: adjustmentData.length,
              itemBuilder: (context, index) {
                final item = adjustmentData[index];
                return GestureDetector(
                  onTap: () {
                    // 정산 내역 페이지로 이동 (id 전달)
                    print("정산 내역으로 이동: ID ${item['id']}");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['amount'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
