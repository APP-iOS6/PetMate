//
//  PetMateApp.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI
import FirebaseCore
import KakaoMapsSDK

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String

      FirebaseApp.configure()
      SDKInitializer.InitSDK(appKey: kakaoKey)
      print("KakaoMap SDK 초기화 완료")

    return true
  }
}

@main
struct PetMateApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}

