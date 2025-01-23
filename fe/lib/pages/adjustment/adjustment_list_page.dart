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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-room');
              },
              child: const Text(
                '방 생성',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('정산 중'),
                          if (hasUnreadNotifications)
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
                    ),
                    const Tab(text: '정산 완료'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: selectedFilter,
                        items: <String>['전체', '개인', '단체']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          // TODO: 검색 기능 구현
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
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
              color: Color(0xFF6B7684),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            color: hasAmount ? const Color(0xFF8C98A8) : Colors.black54,
            height: 1.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/adjustment-detail');
        },
      ),
    );
  }
}
