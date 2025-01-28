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
```
yaml
dependencies:
  kakao_flutter_sdk_user: ^1.8.0
```
### 3.2 Android 설정
`android/app/src/main/AndroidManifest.xml`에 추가:
```
xml
<activity android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity">
<intent-filter android:label="flutter_web_auth">
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data android:scheme="kakao{NATIVE_APP_KEY}" android:host="oauth"/>
</intent-filter>
</activity>
```
### 3.3 iOS 설정
`ios/Runner/Info.plist`에 추가:
```
xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>kakaokompassauth</string>
<string>kakaolink</string>
</array>
<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleURLSchemes</key>
<array>
<string>kakao{NATIVE_APP_KEY}</string>
</array>
</dict>
</array>
```

## 4. API 엔드포인트
- POST `/api/auth/login`: 카카오 토큰으로 로그인
- POST `/api/auth/register`: 신규 회원 등록

## 5. 에러 처리
- 카카오톡 미설치: 카카오계정으로 로그인 시도
- 토큰 만료: 리프레시 토큰으로 재발급
- 네트워크 오류: 스낵바로 사용자에게 알림
