# fe

더 똑똑한 더치페이 앱

## Project Structure
fe/
├── android/                    # 안드로이드 네이티브 설정
│   ├── app/
│   │   ├── src/
│   │   │   ├── debug/
│   │   │   ├── main/
│   │   │   │   ├── kotlin/
│   │   │   │   ├── res/
│   │   │   │   │   ├── drawable/
│   │   │   │   │   ├── mipmap/
│   │   │   │   │   └── values/
│   │   │   │   └── AndroidManifest.xml
│   │   │   └── profile/
│   │   ├── build.gradle
│   │   └── proguard-rules.pro
│   ├── gradle/
│   ├── build.gradle
│   ├── gradle.properties
│   └── settings.gradle
├── assets/
│   ├── fonts/                 # 폰트 파일
│   │   └── PretendardVariable.ttf
│   ├── images/               # 이미지 리소스
│   │   ├── app_logo.jpg
│   │   ├── app_logo_word.png
│   │   ├── back_button.svg
│   │   ├── green_check.svg
│   │   ├── kakao_login_medium_wide.png
│   │   └── profile_placeholder.png
│   └── .env                  # 환경 변수
├── lib/
│   ├── adjustment/           # 정산 관련 페이지
│   │   └── adjustment_page.dart
│   ├── controllers/         # 컨트롤러
│   │   ├── api.dart
│   │   ├── login_controller.dart
│   │   ├── user_controller.dart
│   │   └── user_login.dart
│   ├── dutchpay/           # 더치페이 관련 페이지
│   │   ├── dutch_alone.dart
│   │   └── dutch_together.dart
│   ├── pages/
│   │   ├── adjustment/     # 정산 관련 페이지
│   │   │   ├── adjustment_complete_page.dart
│   │   │   ├── adjustment_confirm_page.dart
│   │   │   ├── adjustment_list_page.dart
│   │   │   ├── adjustment_process_page.dart
│   │   │   └── create_room_page.dart
│   │   ├── home/          # 홈 관련 페이지
│   │   │   ├── home_page.dart
│   │   │   └── info_page.dart
│   │   └── user/          # 사용자 관련 페이지
│   │       ├── edit_profile_page.dart
│   │       ├── settings_page.dart
│   │       └── user_page.dart
│   ├── splash/            # 스플래시 화면
│   │   ├── login_page.dart
│   │   └── splash_page.dart
│   ├── utils/            # 유틸리티
│   │   └── token_storage.dart
│   ├── widgets/          # 재사용 가능한 위젯
│   │   ├── bottom_navigation_bar.dart
│   │   ├── dutch_pay_options.dart
│   │   ├── logo_and_notification.dart
│   │   └── user_info_container.dart
│   └── main.dart         # 앱 진입점
├── web/                  # 웹 관련 설정
│   ├── index.html
│   └── manifest.json
└── pubspec.yaml         # 프로젝트 설정 및 의존성


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
