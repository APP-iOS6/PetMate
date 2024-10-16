//
//  TestStore.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//
import SwiftUI
import FirebaseFirestore

// 테스트용 Store
// Store에서 미리 post를 만들어놔야 캘린더 편집 시트를 띄웠을 때 post가 nil이 아님
@Observable
class TestStore{
    let db = Firestore.firestore()
    
    var testPost: MatePost
    var user: MateUser?
    var pet: Pet?
    var title: String
    
    init() {
        self.testPost = MatePost(writeUser: db.collection("User").document("희철"), pet: db.collection("User/희철/pets").document("1"), startDate: .now, endDate: Date(timeIntervalSinceNow: 60000), cost: 15000, content: "testDescription", location: "강동구", postState: "reservated", createdAt: .now, updatedAt: .now)
        self.title = "애옹"
    }
    init(testPost: MatePost, title: String){
        self.testPost = testPost
        self.title = title
    }
    
    func getUser() async {
        self.user = try? await testPost.writeUser.getDocument(as: MateUser.self)
    }
    
    func getPet()async {
        self.pet = try? await testPost.pet.getDocument(as: Pet.self)
    }
    func getTitle() async -> String{
        let writer = try? await testPost.writeUser.getDocument().data()?["name"] as? String ?? ""
        let petName = try? await testPost.pet.getDocument().data()?["name"] as? String ?? ""
        return (writer ?? "작성자") + (petName ?? "애옹")
    }

}
