//
//  AddPostViewModel.swift
//  PetMate
//
//  Created by Mac on 10/21/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class AddPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedUIImage: UIImage? = nil
    @Published var imageData: Data? = nil
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0 // 업로드 진행률을 나타내는 변수
    
    let db = Firestore.firestore()

    // 파이어베이스에 데이터를 저장하는 함수
    func savePost() {
        guard !title.isEmpty, !content.isEmpty, let selectedUIImage = selectedUIImage else {
            print("제목, 내용 또는 이미지가 누락되었습니다.")
            return
        }

        isUploading = true
        uploadProgress = 0.2 // 초기 진행률 (예: 20%)

        // 이미지를 Data로 변환
        imageData = selectedUIImage.jpegData(compressionQuality: 0.8)

        // Firestore에 새로운 문서 레퍼런스 생성
        let postRef = db.collection("Place").document()

        // 이미지를 base64로 인코딩하여 Firestore에 저장
        let base64String = imageData?.base64EncodedString()

        let newPost: [String: Any] = [
            "writeUser": "userID",
            "title": title,
            "content": content,
            "placeName": "카카오프렌즈 코엑스점",
            "imageBase64": base64String ?? "",
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]

        postRef.setData(newPost) { [weak self] error in
            DispatchQueue.main.async {
                self?.isUploading = false
                self?.uploadProgress = 1.0 // 업로드 완료 (100%)
            }
            if let error = error {
                print("Post 저장 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("Post가 성공적으로 저장되었습니다.")
            }
        }
    }
}
