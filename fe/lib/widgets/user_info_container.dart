// widgets/user_info_container.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserInfoContainer extends StatelessWidget {
  final double width;

  const UserInfoContainer({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Center(
      child: Container(
        width: width * 0.8, // maxWidth 적용
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Obx(() {
          final nickname = userController.nickname.value;
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '똑똑! $nickname\n',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const TextSpan(
                  text: '정산 요청이 2건 있어요',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          );
        }),
      ),
    );
  }
}
