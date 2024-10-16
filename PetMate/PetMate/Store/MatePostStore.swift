//
//  MatePostStore.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//
//메이트 모집 게시물 관련 Store

import Foundation
import FirebaseFirestore
import Observation

@Observable
class MatePostStore{
    let db = Firestore.firestore()
    var posts: [MatePost] = []
    var selectedPost: MatePost?
    var writer: MateUser?
    var pet: Pet?
    
    init() async{
        await getPosts()
    }
    
    //포스트 정보를 전부 불러오는 함수
    private func getPosts() async{
        let snapshots = try? await db.collection("matePosts").getDocuments()
        snapshots?.documents.forEach{ snapshot in
            if let post = try? snapshot.data(as: MatePost.self){
                posts.append(post)
            }
        }
    }
    
    //인자로 받은 유저 문서레퍼런스를 통해 User 옵셔널 데이터를 반환하는 함수
    func getUser(_ user: DocumentReference) async -> MateUser?{
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
}

