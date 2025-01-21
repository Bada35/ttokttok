import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DutchTogetherPage extends StatefulWidget {
  @override
  _DutchTogetherPageState createState() => _DutchTogetherPageState();
}

class _DutchTogetherPageState extends State<DutchTogetherPage> {
  int currentRound = 1;
  bool isDirectInput = false;
  TextEditingController amountController = TextEditingController();
  Map<String, int> individualAmounts = {}; // key: 사용자 ID, value: 입력 금액

  // 서버에서 받은 방 정보
  late Map<String, dynamic> roomData;
  late List<dynamic> participants;

  @override
  void initState() {
    super.initState();
    // Get.arguments로 받은 데이터 초기화
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      roomData = arguments;
      participants = roomData["roomParticipants"] ?? [];

      // 데이터가 제대로 들어왔는지 확인하기 위한 print 문
      print("roomData: $roomData");
      print("participants: $participants");
    } else {
      roomData = {};
      participants = [];
      Get.snackbar(
        "오류",
        "방 데이터가 올바르지 않습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addRound() {
    setState(() {
      currentRound += 1;
    });
  }

  void toggleInputMode() {
    setState(() {
      isDirectInput = !isDirectInput;
      if (!isDirectInput) {
        individualAmounts.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 금액 계산
    int totalAmount = isDirectInput
        ? individualAmounts.values.fold(0, (sum, amount) => sum + amount)
        : (int.tryParse(amountController.text) ?? 0);
    int perPersonAmount = (participants.isNotEmpty && !isDirectInput)
        ? totalAmount ~/ participants.length
        : 0;

    // 빌드가 될 때마다 데이터가 제대로 들어왔는지 출력
    print("totalAmount: $totalAmount");
    print("perPersonAmount: $perPersonAmount");
    print("participants length: ${participants.length}");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('정산하기(${currentRound}차)'),
        actions: [
          TextButton(
            onPressed: addRound,
            child: Text('차수추가', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 방 정보 표시
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '방 이름: ${roomData["roomName"] ?? "알 수 없음"}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4.0),
                  Text('방 생성자 ID: ${roomData["roomManager"] ?? "알 수 없음"}'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // 1/N 과 직접입력 토글 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => isDirectInput = false),
                  child: Text(
                    '1/N 하기',
                    style: TextStyle(
                      fontWeight:
                          isDirectInput ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: toggleInputMode,
                  child: Text(
                    '직접입력',
                    style: TextStyle(
                      fontWeight:
                          isDirectInput ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // 입력 필드
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              enabled: !isDirectInput,
              decoration: InputDecoration(
                labelText: '금액입력(원)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // TODO: 인원 편집 로직 추가 예정
              },
              child: Text('인원편집'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  var participant = participants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(participant.toString()[0]),
                    ),
                    title: Text('참여자 ID: ${participant.toString()}'),
                    trailing: isDirectInput
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  individualAmounts[participant.toString()] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '금액 입력',
                              ),
                            ),
                          )
                        : Text('${perPersonAmount}원'),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: 정산 완료 로직 추가
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
