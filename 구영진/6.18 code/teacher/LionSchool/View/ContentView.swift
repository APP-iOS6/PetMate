//
//  ContentView.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/17/24.
//

import SwiftUI

// View 프로토콜을 따르는
// ContentView라는 struct 타입
// 보통 세부 화면 View들을 담는 큰 그릇으로만 활용
struct ContentView: View {
    var body: some View {
        
        // 화면이 전환되는 컨테이너 만들기
        NavigationStack {
            SchoolView()
        }
    }
}

#Preview {
    ContentView()
}
