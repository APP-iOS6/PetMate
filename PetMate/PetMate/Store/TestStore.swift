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
class TestStore {
    let db = Firestore.firestore()
    
    var testPost: MatePost
    var user: MateUser?
    var pet: Pet?
    var title: String
    
    init() {
        self.testPost = MatePost(
            writeUser: db.collection("User").document("희철"),
            pet: [db.collection("User/희철/pets").document("1")],
            title: "제목", startDate: .now, endDate: Date(timeIntervalSinceNow: 60000),
            cost: 15000,
            content: "testDescription",
            location: "강동구",
            postState: "reservated",
            firstPet: Pet(name: "애옹", description: "애옹 설명", age: 2, tag: ["귀여움"], breed: "봄베이고양이", images: ["https://d3544la1u8djza.cloudfront.net/APHI/Blog/2020/10-22/What+Is+a+Bombay+Cat+_+Get+to+Know+This+Stunning+Breed+_+ASPCA+Pet+Health+Insurance+_+close-up+of+a+Bombay+cat+with+gold+eyes-min.jpg"],
                          ownerUid: "희철",
                          createdAt: .now,
                          updatedAt: .now),
            createdAt: .now,
            updatedAt: .now)
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
        self.pet = try? await testPost.pet.first?.getDocument(as: Pet.self)
    }
    func getTitle() async -> String{
        let writer = try? await testPost.writeUser.getDocument().data()?["name"] as? String ?? ""
        let petName = try? await testPost.pet.first?.getDocument().data()?["name"] as? String ?? ""
        return (writer ?? "작성자") + (petName ?? "애옹")
    }

}
