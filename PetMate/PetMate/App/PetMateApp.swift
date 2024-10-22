//
//  PetMateApp.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
    
}

@main
struct PetMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var matePostStore = MatePostStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthManager())
                .environment(PetPlacesStore())
                .environment(matePostStore)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}



