# 카카오 로그인 구현 가이드

## 1. 연관 파일
- `fe/lib/splash/login_page.dart`: 카카오 로그인 UI 및 로직
- `fe/lib/controllers/user_controller.dart`: 사용자 정보 및 토큰 관리
- `fe/lib/controllers/login_controller.dart`: 로그인 프로세스 관리
- `fe/lib/models/user.dart`: 사용자 모델
- `android/app/src/main/AndroidManifest.xml`: 카카오 로그인 설정
- `ios/Runner/Info.plist`: 카카오 로그인 설정

## 2. 로그인 프로세스
1. 사용자가 카카오 로그인 버튼 클릭
2. 카카오톡 설치 여부 확인
   - 설치된 경우: 카카오톡으로 로그인 시도
   - 미설치된 경우: 카카오계정으로 로그인 시도
3. 카카오 로그인 성공 시 액세스 토큰 획득
4. 서버에 토큰 전송하여 사용자 확인
   - 기존 회원: 홈 페이지로 이동
   - 신규 회원: 회원가입 페이지로 이동

## 3. 필요한 설정
### 3.1 Flutter 패키지
- `flutter_secure_storage`: 토큰 저장 및 관리
- `flutter_svg`: SVG 이미지 표시
- `flutter_dotenv`: 환경변수 관리
- `flutter_riverpod`: 상태 관리
- `flutter_riverpod_annotation`: 상태 관리 어노테이션
- `flutter_riverpod_annotation`: 상태 관리 어노테이션
