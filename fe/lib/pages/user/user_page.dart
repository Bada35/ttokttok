import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../controllers/user_controller.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Widget _buildProfileSection() {
    final UserController userController = Get.find<UserController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28), // radius를 24로 수정
              color: const Color(0xFFDDE2E5),
              border: Border.all(
                color: const Color(0xFFD9DADE),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/profile_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                '${userController.nickname.value}님',
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF343943),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showCheckIcon = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 12, right: 16),
      minLeadingWidth: 6,
      leading: showCheckIcon
          ? SvgPicture.asset(
              'assets/images/green_check.svg',
              width: 20,
              height: 20,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          color: Color(0xFF333D48),
          letterSpacing: -0.30,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      body: SafeArea(
        // SafeArea로 감싸서 상단 여백 확보
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 90), // 추가 상단 여백
              _buildProfileSection(),
              const SizedBox(height: 20),

              // 내 정산 내역
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildMenuCard(
                  title: '내 정산내역',
                  subtitle: '',
                  showCheckIcon: true,
                  onTap: () {
                    print('정산 내역 페이지로 이동');
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 계정 관리 섹션
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildMenuCard(
                      title: '정보 수정',
                      subtitle: '',
                      onTap: () => Get.to(() => const EditProfilePage()),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildMenuCard(
                      title: '카카오계정',
                      subtitle: '1234@gmail.com',
                      onTap: () {
                        print('카카오계정 정보');
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildMenuCard(
                      title: '환경설정',
                      subtitle: '',
                      onTap: () => Get.to(() => const SettingsPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
