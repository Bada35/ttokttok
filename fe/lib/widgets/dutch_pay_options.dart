// widgets/dutch_pay_options.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dutchpay/dutch_alone.dart';
import '../dutchpay/dutch_together.dart';
import '../controllers/user_picker.dart';

class DutchPayOptions extends StatelessWidget {
  final double width;

  const DutchPayOptions({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserPicker userPicker = Get.put(UserPicker());

    return Container(
      width: width * 0.8, // 80% 너비 제한
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우로 공간 분배
        children: [
          // 혼자 정산하기 컨테이너
          Flexible(
            child: GestureDetector(
              onTap: () {
                Get.to(() => DutchAlonePage());
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: width * 0.38),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft, // 가로 왼쪽, 세로 중앙
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0), // 왼쪽 여백 추가
                        child: Text(
                          '혼자\n정산하기',
                          textAlign: TextAlign.left, // 텍스트 좌측 정렬
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.door_front_door,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 같이 정산하기 컨테이너
          SizedBox(width: 16), // 버튼 간격 추가
          Flexible(
            child: GestureDetector(
              onTap: () async {
                await userPicker.selectFriends(context);
                if (userPicker.friends.isNotEmpty) {
                  await userPicker.createRoom(context);
                } else {
                  Get.snackbar("오류", "최소 한 명 이상의 친구를 선택해야 합니다.",
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: width * 0.38),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft, // 가로는 왼쪽, 세로는 중앙
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          '같이\n정산하기',
                          textAlign: TextAlign.left, // 좌측 정렬
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.door_back_door,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
