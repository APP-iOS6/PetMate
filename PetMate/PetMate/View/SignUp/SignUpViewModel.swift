//
//  SignUpViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Observation
import _PhotosUI_SwiftUI


@Observable
class SignUpViewModel {
    
    enum Progress: Double {
        case address = 0.5
        case profile = 1.0
    }
    
    var progress: Progress = .address
    var mateUser: MateUser = MateUser(
        id: nil,
        name: "",
        image: "https://firebasestorage.googleapis.com/v0/b/petmate-f8cbb.appspot.com/o/gadi.png?alt=media&token=4a2b43f6-f1d6-4a38-a87f-585a0aea7a57",
        matchCount: 0,
        location: "",
        createdAt: Date()
    )
    var isSearchModal: Bool = false
    var errorMessage: String?
    var loadState: LoadState = .none
    var image: UIImage? //이미지
    
    private let db = Firestore.firestore() //파이어스토어
    private let StorageRef = Storage.storage().reference() //파이어 스토리지
    
    
    func uploadImage(_ image: UIImage, userUid: String) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            throw UploadImageError.invalidImageData
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        do {
            let ref = StorageRef.child("User").child(userUid).child("\(UUID().uuidString).jpeg")
            _ = try await ref.putDataAsync(imageData, metadata: metaData)
            return try await ref.downloadURL().absoluteString
        } catch {
            throw UploadImageError.uploadError
        }
    }
    
    @MainActor
    func uploadUserData() async {
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }
        loadState = .loading
        mateUser.id = userUid
        do {
            if let image = self.image {
                let uploadedImage = try await uploadImage(image, userUid: userUid)
                self.mateUser.image = uploadedImage
            }
            let userEncode = try Firestore.Encoder().encode(self.mateUser)
            _ = try await db.collection("User").document(userUid).setData(userEncode)
            self.loadState = .complete
        } catch {
            self.loadState = .none
            errorMessage = "회원 가입에 실패하였습니다. 다시 시도해 주세요"
        }
    }
    
    
    @MainActor
    func convertPickerItemToImage(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            do {
                if let imageData = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    self.image = image
                } else {
                    self.errorMessage = "이미지를 불러오는 데 실패"
                }
            } catch {
                self.errorMessage = "이미지를 불러오는 중 오류발생"
            }
        }
    }
}

enum UploadImageError: Error {
    case invalidImageData
    case uploadError
}
