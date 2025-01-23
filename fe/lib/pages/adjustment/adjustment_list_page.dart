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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정산 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create-room');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '정산 중'),
            Tab(text: '정산 완료'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ['전체', '개인', '단체'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedFilter = newValue;
                      });
                    }
                  },
                ),
                const Spacer(),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '검색',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAdjustmentList(isCompleted: false),
                _buildAdjustmentList(isCompleted: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildAdjustmentList({required bool isCompleted}) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(
                isCompleted ? '완료된 정산 ${index + 1}' : '진행 중인 정산 ${index + 1}'),
            subtitle: Text('총 ${(index + 1) * 10000}원'),
            trailing: Text(DateTime.now().toString().substring(0, 10)),
            onTap: () {
              Navigator.pushNamed(context, '/adjustment-detail');
            },
          ),
        );
      },
    );
  }
}
