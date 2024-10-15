//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var loginStore = LoginStore()

    var body: some View {
        
        if loginStore.isLoggedIn {
            Text("로그인 성공! 환영합니다.")
        } else {
            LoginView(isLoggedIn: $loginStore.isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
