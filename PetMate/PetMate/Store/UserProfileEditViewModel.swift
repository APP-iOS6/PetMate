//
//  UserProfileEditViewModel.swift
//  PetMate
//
//  Created by Mac on 10/21/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

final class UserProfileEditViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var address: String = ""
    @Published var profileImage: Image? = nil  // 이미지 선택 상태
    @Published var isImagePickerPresented = false
    @Published var isSearchModal: Bool = false  // 주소 선택 모달 표시 여부
    
    private var cancellables = Set<AnyCancellable>()
    var mateUser: MateUser
    
    init(mateUser: MateUser) {
        self.mateUser = mateUser
        self.nickname = mateUser.name
        self.address = mateUser.location
    }
    
    // Firestore에 사용자 프로필 업데이트
    func updateUserProfile(completion: @escaping (Bool) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            completion(false)
            return
        }

        let userRef = Firestore.firestore().collection("User").document(userUID)

        let updatedData: [String: Any] = [
            "name": nickname,
            "location": address,
            "image": profileImage?.toBase64() ?? "",  // 이미지 데이터를 Base64로 저장
            "updatedAt": Date()
        ]

        userRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User profile successfully updated.")
                completion(true)
            }
        }
    }
    
    // 주소 선택 시 호출되는 메서드
    func updateAddress(with address: String) {
        self.address = address
        self.isSearchModal = false  // 주소 선택 후 모달 닫기
    }
}

// 이미지 데이터를 Base64로 변환하는 확장
extension Image {
    func toBase64() -> String {
        // 이미지를 Base64로 변환하는 로직 추가 (예: UIImage 변환 후 Base64 인코딩)
        return ""
    }
}
