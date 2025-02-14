//
//  MatePostStore.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//
//메이트 모집 게시물 관련 Store

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class MatePostStore{
    //let db = Firestore.firestore()
    var posts: [MatePost] = [] //포스트 리스트에서 불러오는 포스트들
    var selectedPost: MatePost? //선택한 포스트
    var writer: MateUser? //포스트디테일뷰에서 작성자 값을 불러와서 넣을 변수
    var pet: [Pet] = [] //포스트 디테일 뷰에서 펫을 불러와서 넣을 변수
    var pets: [Pet] = []
    
    //게시물 추가 용
    var category: String = "walk"
    var startDate: Date = Date()
    var endDate: Date = Date()
    var cost: String = ""
    var title: String = ""
    var content: String = ""
    var location: String = ""
    var postState: String = ""
    
    var selectedPets: Set<Pet> = []
    
    init() {
        //        getPosts()
        print("posts = \(posts)")
    }
    
    // MARK: - 파이어베이스에서 값을 가져오는 함수들
    //포스트 정보를 전부 불러오는 함수
    func getPosts(postCategory: String, petCategory1: String, petCategory2: String) {
        //print(postCategory, petCategory1, petCategory2)
        let db = Firestore.firestore()
        var newPosts: [MatePost] = []
        //print("getPosts")
        Task{
            let snapshots: QuerySnapshot?
            snapshots = try? await db.collection("MatePost")
                .whereField("category", isEqualTo: postCategory)
                .whereField("firstPet.category1", isEqualTo: petCategory1)
                .whereField("firstPet.category2", isEqualTo: petCategory2)
                .getDocuments()
            snapshots?.documents.forEach{ snapshot in
                print(snapshot.data())
                print("------------dsad")
                print(try? snapshot.data(as: MatePost.self))
                if let post = try? snapshot.data(as: MatePost.self){
                    newPosts.append(post)
                }
            }
            self.posts = newPosts
            
        }
    }
    
    //인자로 받은 유저 문서레퍼런스를 통해 User 옵셔널 데이터를 반환하는 함수
    func getUser(_ user: DocumentReference) async -> MateUser?{
        print(user)
        do{
            return try await user.getDocument().data(as: MateUser.self)
        }catch{
            print("getUser error: \(error)")
            return nil
        }
    }
    
    //인자로 받은 펫 문서레퍼런스를 통해 Pet 옵셔널 데이터를 반환하는 함수
    func getPet(_ pet: DocumentReference) async -> Pet?{
        do{
            return try await pet.getDocument().data(as: Pet.self)
        }catch{
            print("getPet error: \(error)")
            return nil
        }
    }
    //로그인한 계정이 가지고 있는 펫 정보들 모아서 반환
    func getMyPets() async -> [Pet] {
        let db = Firestore.firestore()
        let currentUser: String = Auth.auth().currentUser?.uid ?? ""
        //let currentUser: String = "희철"
        var pets: [Pet] = []
        let snapshots = try? await db.collection("Pet").whereField("ownerUid", isEqualTo: currentUser).getDocuments()
        snapshots?.documents.forEach{ snapshot in
            //print(try? snapshot.data(as:Pet.self))
            if let pet = try? snapshot.data(as: Pet.self){
                pets.append(pet)
            }
        }
        
        return pets
    }
    //포스트의 펫 정보들 호출
    func getPets() async -> Void {
        var pets: [Pet] = []
        if let selectedPost{
            for petDocu in selectedPost.pet{
                if let pet = await getPet(petDocu){
                    pets.append(pet)
                }
            }
            self.pet = pets
        }else{
            print("selectedPost is not Exist")
        }
    }
    
    func reset(){
        self.pets = []
    }
    
    // MARK: - 파이어베이스에 값을 넣는 함수
    func postMatePost() -> (){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser?.uid ?? ""
        //let currentUser: String = "희철"
        var petRefs: [DocumentReference] = []
        Array(selectedPets).forEach{
            guard let id = $0.id else { return }
            let petRef = db.collection("Pet").document(id)
            petRefs.append(petRef)
        }
        guard let firstPet = selectedPets.first else { return }
        let post = MatePost(
            writeUser: db.collection("User").document(currentUser),
            pet: petRefs,
            title: title,
            category: category,
            startDate: startDate,
            endDate: endDate,
            cost: Int(cost) ?? -1,
            content: content,
            location: location,
            postState: "finding",
            firstPet: firstPet,
            createdAt: .now,
            updatedAt: .now)
        do{
            try db.collection("MatePost").addDocument(from: post)
        }catch let error{
            print("Error posting mate post: \(error.localizedDescription)")
        }
    }
    
    func addPostReset(){
        category = "walk"
        startDate = Date()
        endDate = Date()
        cost = ""
        title = ""
        content = ""
        location = ""
        postState = ""
        
        var selectedPets: Set<Pet> = []
    }
    
}

