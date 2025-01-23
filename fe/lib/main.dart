// main.dart
// 앱의 시작
import 'dart:io'; // 플랫폼 구분을 위한 패키지 추가
import 'package:flutter/foundation.dart' show kIsWeb; // 웹 구분을 위한 플래그 추가
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // flutter_dotenv 임포트
import 'package:flutter/services.dart'; // SystemChrome 임포트
import 'package:device_info_plus/device_info_plus.dart'; // device_info_plus 임포트

import './splash/splash_page.dart'; // SplashPage 임포트 추가
import './pages/adjustment/adjustment_list_page.dart';
import './pages/adjustment/create_room_page.dart';
import './pages/adjustment/adjustment_process_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 초기화를 위해 추가
  await dotenv.load(fileName: "assets/.env"); // .env 파일 로드

  // 디바이스 정보를 가져오기 위해 device_info_plus 사용
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      print('Running on ${androidInfo.model}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
    }
  }

  // 세로 모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 웹 환경인지 확인
  if (kIsWeb) {
    // 웹 전용 초기화 로직
    KakaoSdk.init(
      javaScriptAppKey: dotenv.env['JAVASCRIPT_APP_KEY']!,
    );
  }
  // 안드로이드 환경인지 확인
  else if (Platform.isAndroid) {
    // Android 전용 초기화 로직
    KakaoSdk.init(
      nativeAppKey: dotenv.env['NATIVE_APP_KEY']!,
    );
  }
  // iOS 환경인지 확인
  else if (Platform.isIOS) {
    // iOS 전용 초기화 로직
    KakaoSdk.init(
      nativeAppKey: dotenv.env['NATIVE_APP_KEY']!,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '똑똑',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage()),
        GetPage(
            name: '/adjustment-list', page: () => const AdjustmentListPage()),
        GetPage(name: '/create-room', page: () => const CreateRoomPage()),
        GetPage(
            name: '/adjustment-process',
            page: () => const AdjustmentProcessPage()),
      ],
    );
  }
}
