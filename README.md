# 토스 iOS SDK
토스 iOS SDK를 위한 모노레포입니다.

## 설치하기
### 요구 사항
토스 iOS SDK를 설치하기 전에 최소 요구 사항을 확인하세요.

- iOS 13.0 이상
- Swift 5.3 이상

### Swift Package Manager(SPM)로 설치하기
Xcode에서 아래 토스 iOS SDK의 레포지토리(Repository) URL를 검색 후 추가하세요.
```
https://github.com/toss/toss-sdk-ios.git
```

## 사전 설정
### 앱 실행 허용 목록 설정
토스앱을 열 수 있는지 확인할 수 있게 `Info.plist` 파일에 Array 타입 키(Key)인 `LSApplicationQueriesSchemes`를 추가하고, 해당 키의 [Item]으로 `"supertoss"`를 추가하세요.
추가하지 않으면 토스앱이 열리지 않아요.

### URL Scheme 설정
로그인 후 서비스 앱으로 돌아오기 위해, `[Info] > [URL Types] > [URL Schemes]`에 `toss${APP_KEY}`를 추가하세요.
예를 들어 앱 키가 "AB12CD34EF56GH78"이라면 [URL Schemes]에 "tossAB12CD34EF56GH78"를 입력하세요.

## 시작하기
### SDK 초기화
`AppDelegate.swift`에 앱 키를 사용해 SDK를 초기화하는 과정이 필요해요. 
```swift
import TossFoundation

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ...
    TossSDK.shared.initSDK(appKey: "${APP_KEY}")
    ...
}
```

### 토스 로그인 
토스로 로그인을 하기 위한 설정이에요.

#### 로그인 완료 처리를 위한 설정
사용자가 토스앱에서 [동의하기] 버튼 또는 [닫기] 버튼을 누르면 토스앱에서 서비스앱으로 이동해요.
서비스앱으로 돌아왔을 때 정상적으로 완료하기 위해 `AppDelegate.swift` 또는 `SceneDelegate.swift` 파일에 `handleOpenUrl(_:)`을 추가하세요.

AppDelegate.swift: 
```swift
import TossLogin
...

class AppDelegate: UIResponder, UIApplicationDelegate {
    ...
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if TossLoginController.shared.isCallbackURL(url) {
            return TossLoginController.shared.handleOpenUrl(url)
        }

        return false
    }
    ...
}
```

SceneDelegate.swif:
```swift
import TossLogin
...

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    ...
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, TossLoginController.shared.isCallbackURL(url) {
            _ = TossLoginController.shared.handleOpenUrl(url)
        }
    }
    ...
}
```

##### 로그인 요청
토스로 로그인을 하기 위해, `login(completion:)`을 호출하세요.
`isLoginAvailable` 변수로 토스앱 실행 가능 여부를 확인할 수 있어요. 
> 사전 설정의 `앱 실행 허용 목록 설정`을 하지 않으면 토스앱이 설치되어 있어도, 토스앱을 실행할 수 없어요.

토스앱이 설치되어있지 않아 실행이 불가능하면, `moveToAppstore()`를 호출해 앱스토어로 이동할 수 있어요.

```swift
guard TossLoginController.shared.isLoginAvailable else {
    TossLoginController.shared.moveToAppstore()
    return
}

TossLoginController.shared.login(completion: { result in
    switch result {
        case let .success(authCode):
            // authCode 를 통해 accessToken을 발급받으세요.
            break
                    
        case let .error(error):
            print("error code : \(error.code), error message: \(error.message)")

        case .cancelled:
            // 사용자가 취소했어요.
            break
    }
})
```
