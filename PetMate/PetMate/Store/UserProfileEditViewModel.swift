//
//  UserProfileEditViewModel.swift
//  PetMate
//
//  Created by Mac on 10/21/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

@Observable
final class UserProfileEditViewModel {
    var nickname: String = ""
    var address: String = ""
    var profileImage: UIImage? = nil
    var isImagePickerPresented = false
    var isSearchModal: Bool = false
    var mateUser: MateUser
    private let storageRef = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    init(mateUser: MateUser) {
        self.mateUser = mateUser
        self.nickname = mateUser.name
        self.address = mateUser.location
        self.loadProfileImage()
    }

    private func loadProfileImage() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }

        let storageRef = storageRef.child("User/\(userUID)/profile_image.jpg")

        storageRef.downloadURL { [weak self] url, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image URL: \(error.localizedDescription)")
                return
            }
            
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error downloading image data: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImage = image
                        }
                    }
                }.resume()
            }
        }
    }
    // 필수 항목 알람
    func validateNickname() -> String? {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedNickname.isEmpty {
            return "닉네임은 필수 항목입니다."
        } else if trimmedNickname.count < 4 || trimmedNickname.count > 10 {
            return "닉네임은 4~10자 이내여야 합니다."
        } else if !isValidNickname(trimmedNickname) {
            return "닉네임은 공백,특수문자,단일모음을 포함할 수 없습니다."
        } else if address.isEmpty {
            return "주소는 필수 항목입니다."
    }
    
    return nil
}

    private func isValidNickname(_ nickname: String) -> Bool {
        let validCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789가나다라마바사아자차카타파하")
        return nickname.rangeOfCharacter(from: validCharacterSet.inverted) == nil
    }

    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            throw UploadImageError.invalidImageData
        }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        do {
            let userUID = Auth.auth().currentUser?.uid ?? "unknown_user"
            let ref = storageRef.child("User/\(userUID)/profile_image.jpg")
            _ = try await ref.putDataAsync(imageData, metadata: metaData)
            return try await ref.downloadURL().absoluteString
        } catch {
            throw UploadImageError.uploadError
        }
    }
    
    @MainActor
    func saveProfile() {
        let userUID = Auth.auth().currentUser?.uid ?? "unknown_user"
        let userProfileData: [String: Any] = [
            "nickname": self.nickname,
            "address": self.address,
            "profileImage": self.profileImage?.jpegData(compressionQuality: 0.2)?.base64EncodedString() ?? ""
        ]
        
        db.collection("users").document(userUID).setData(userProfileData) { error in
            if let error = error {
                print("Error saving profile: \(error.localizedDescription)")
            } else {
                print("Profile saved successfully!")
            }
        }
    }
    
    @MainActor
    func convertPickerItemToImage(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            do {
                if let imageData = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    self.profileImage = image
                } else {
                    print("Failed to load image.")
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
