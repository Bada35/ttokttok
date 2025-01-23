import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation_bar.dart';

class AdjustmentListPage extends StatefulWidget {
  const AdjustmentListPage({super.key});

  @override
  State<AdjustmentListPage> createState() => _AdjustmentListPageState();
}

class _AdjustmentListPageState extends State<AdjustmentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = '전체';
  bool hasUnreadNotifications = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              _tabController.index == 0 ? '정산 중' : '정산 완료',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_tabController.index == 0 && hasUnreadNotifications)
              Container(
                margin: const EdgeInsets.only(left: 4),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF04452),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: 검색 기능 구현
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/create-room');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          onTap: (index) {
            setState(() {}); // 탭 변경 시 제목 업데이트를 위해
          },
          tabs: const [
            Tab(text: '정산 중'),
            Tab(text: '정산 완료'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 정산 중 탭
          ListView(
            children: [
              _buildDateGroup('9월 1일', [
                _buildAdjustmentItem('똑똑팀', '금액 미입력', false),
                _buildAdjustmentItem('홍길동 외 2인', '총 26,500원', true),
              ]),
              _buildDateGroup('8월 27일', [
                _buildAdjustmentItem('김유진', '총 4,000원', true),
              ]),
            ],
          ),
          // 정산 완료 탭
          ListView(
            children: [
              _buildDateGroup('8월 25일', [
                _buildAdjustmentItem('완료된 정산 1', '총 15,000원', true),
                _buildAdjustmentItem('완료된 정산 2', '총 30,000원', true),
              ]),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildDateGroup(String date, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildAdjustmentItem(String title, String amount, bool hasAmount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            color: hasAmount ? const Color(0xFF8C98A8) : Colors.black54,
            height: 1.8,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/adjustment-detail');
        },
      ),
    );
  }
}
