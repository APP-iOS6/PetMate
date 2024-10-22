//
//  PetProfileViewModel.swift
//  PetMate
//
//  Created by 이다영 on 10/20/24.
//

import SwiftUI
import FirebaseFirestore

class PetProfileViewModel: ObservableObject {
    @Published var pet: Pet?
    
    private var db = Firestore.firestore()
    
    // 특정 반려동물 프로필을 FireStore에서 비동기적으로 가져와 뷰모엘의 pet 변수에 저장
    func fetchPetProfile(petId: String) async throws {
        let documentRef = db.collection("pets").document(petId)
        do {
            let document = try await documentRef.getDocument()
            if let data = document.data() {
                self.pet = try? Firestore.Decoder().decode(Pet.self, from: data)
            } else {
                throw NSError(domain: "PetProfileViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
            }
        } catch {
            throw error
        }
    }
    
    // pet 데이터를 Firebase에 업로드?
    func uploadPetProfile(_ petData: Pet) async throws -> Bool {
        do {
            let petEncode = try Firestore.Encoder().encode(petData)
            try await db.collection("pets").document(petData.id ?? UUID().uuidString).setData(petEncode)
            return true
        } catch {
            throw error
        }
    }
}
