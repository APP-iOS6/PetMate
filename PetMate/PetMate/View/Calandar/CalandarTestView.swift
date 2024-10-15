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
            EventEditViewController(post: testStore.testPost, title: testStore.title)
        }.task {
            testStore.title = await testStore.getTitle()
        }
    }
}

@Observable
class TestStore{
    let db = Firestore.firestore()
    
    var testPost: MatePost
    var title: String
    
    init() {
        self.testPost = MatePost(writeUser: db.collection("User").document("희철"), pet: db.collection("User/희철/pets").document("1"), startDate: .now, endDate: Date(timeIntervalSinceNow: 60000), cost: 15000, content: "testDescription", location: "강동구", postState: "reservated", createdAt: .now, updatedAt: .now)
        self.title = "애옹"
    }
    init(testPost: MatePost, title: String){
        self.testPost = testPost
        self.title = title
    }
    
    func getTitle() async -> String{
        let writer = try? await testPost.writeUser.getDocument().data()?["name"] as? String ?? ""
        let petName = try? await testPost.pet.getDocument().data()?["name"] as? String ?? ""
        return (writer ?? "작성자") + (petName ?? "애옹")
    }
    
    
}

#Preview{
    CalandarTestView()
}
