// controllers/user_picker.dart
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_friend.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // JSON 처리

import 'api.dart';
import '../dutchpay/dutch_together.dart';

class UserPicker extends GetxController {
  // 친구 목록을 저장하는 변수
  var friends = <SelectedUser>[].obs;

  // 친구 선택 기능
  Future<void> selectFriends(BuildContext context) async {
    // 파라미터 설정
    var params = PickerFriendRequestParams(
      title: '멀티 피커', // 피커 이름
      enableSearch: true, // 검색 기능 사용 여부
      showFavorite: true, // 즐겨찾기 친구 표시 여부
      showPickedFriend: true, // 선택한 친구 표시 여부, 멀티 피커에만 사용 가능
      maxPickableCount: 5, // 선택 가능한 최대 대상 수
      minPickableCount: 1, // 선택 가능한 최소 대상 수
      enableBackButton: true, // 뒤로 가기 버튼 사용 여부, 리다이렉트 방식 웹 또는 네이티브 앱에서만 사용 가능
    );

    // 피커 호출
    try {
      SelectedUsers users = await PickerApi.instance
          .selectFriends(params: params, context: context);
      print('친구 선택 성공: ${users.users?.length ?? 0}명');
      // 선택한 친구 목록을 업데이트
      if (users.users != null) {
        friends.assignAll(users.users!);
      }
    } catch (e) {
      print('친구 선택 실패: $e');
    }
  }

  Future<void> createRoom(BuildContext context) async {
    if (friends.isEmpty) {
      print("선택된 친구가 없습니다.");
      return;
    }

    // 참여자 목록 생성
    var participateList = friends.map((friend) => friend.id).toList();
    String roomName = "${friends.first.profileNickname}의 정산방";

    // POST 요청 데이터 생성
    var postData = {
      "roomName": roomName,
      "roomManager": friends.first.id,
      "roomParticipants": participateList,
    };

    try {
      // API 요청
      final response = await API.post(
        "/api/room/create",
        body: postData,
      );

      if (response.statusCode == 200) {
        print("방 생성 성공: ${response.body}");
        Map<String, dynamic> roomData =
            json.decode(utf8.decode(response.bodyBytes))["data"];

        // DutchTogetherPage로 데이터 전달
        Get.to(() => DutchTogetherPage(), arguments: roomData);
      } else {
        print("방 생성 실패: ${response.statusCode}");
        print("응답 내용: ${response.body}");
        Get.snackbar(
          "방 생성 실패",
          "응답 상태 코드: ${response.statusCode}\n내용: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("API 요청 실패: $e");
      Get.snackbar(
        "방 생성 실패",
        "API 요청 중 오류가 발생했습니다.\n$e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
