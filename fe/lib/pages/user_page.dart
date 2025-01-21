import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../controllers/user_controller.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 프로필 이미지
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
              image: DecorationImage(
                image: AssetImage('assets/images/profile_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 사용자 이름
          const Text(
            '석유민님',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),

            // 내 정산 내역
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildMenuCard(
                    title: '내 정산내역',
                    subtitle: '',
                    onTap: () {
                      // 정산 내역 페이지로 이동
                      print('정산 내역 페이지로 이동');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 계정 관리
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildMenuCard(
                    title: '정보 수정',
                    subtitle: '카카오계정 1234@gmail.com',
                    onTap: () {
                      // 정보 수정 페이지로 이동
                      print('정보 수정 페이지로 이동');
                    },
                  ),
                  _buildMenuCard(
                    title: '환경설정',
                    subtitle: '',
                    onTap: () {
                      // 환경설정 페이지로 이동
                      print('환경설정 페이지로 이동');
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
