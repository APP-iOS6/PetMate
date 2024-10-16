//
//  CalandarTestView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//
import SwiftUI
import FirebaseFirestore

struct CalandarTestView: View {
    
    let testStore = TestStore()
    
    @State private var isPresent: Bool = false
    
    var body: some View {
        Button("캘린더 테스트"){
            isPresent.toggle()
        }.sheet(isPresented: $isPresent) {
            CalandarView(post: testStore.testPost, title: testStore.title)
        }.task {
            testStore.title = await testStore.getTitle()
        }
    }
}

#Preview{
    CalandarTestView()
}
