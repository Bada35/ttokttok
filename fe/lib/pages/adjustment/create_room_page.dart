import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/back_button.svg'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8), // 앱바와 제목 사이 간격
            const Text(
              '방 이름을 알려주세요',
              style: TextStyle(
                color: Color.fromRGBO(51, 61, 75, 1),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40), // 제목과 입력 필드 사이 간격
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                hintText: '똑똑팀',
                hintStyle: TextStyle(
                  color: Color.fromRGBO(153, 163, 177, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF22BE67)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF22BE67), width: 2),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
              if (_roomNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('방 이름을 입력해주세요')),
                );
                return;
              }
              // 임시 데이터로 친구 목록 생성
              final selectedFriends = ['석유민', '배영환', '이재진'];
              Navigator.pushNamed(
                context,
                '/adjustment-process',
                arguments: {
                  'roomName': _roomNameController.text,
                  'participants': selectedFriends,
                },
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
              '다음',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
