// info_page.dart
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 정보'),
      ),
      body: Center(
        child: Text('혼자 정산하기\n 친구 초대 필요 없이 간편하게 정산할 수 있어요.\n 금액을 입력하고 정산하기를 누르면 끝!\n 상대방에게 자동으로 정산 요청이 발송되기 떄문에\n 더 이상 번거롭게 계산할 필요가 없어요'),
      ),
    );
  }
}
