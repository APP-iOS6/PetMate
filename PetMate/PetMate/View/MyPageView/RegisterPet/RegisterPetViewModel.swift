//
//  RegisterPetViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Observation
import _PhotosUI_SwiftUI

@Observable
class RegisterPetViewModel {
    
    private let db = Firestore.firestore()
    
    var myPet: Pet = Pet(id: UUID().uuidString, name: "", description: "", age: 0, category1: "dog", tag: [], breed: "", images: [], ownerUid: "", createdAt: Date(), updatedAt: Date())
    var images: [UIImage] = []     //이미지배열
    var selectedPhotos: [PhotosPickerItem] = [] //선택된 포토아이템 배열
    var loadState: LoadState = .none
    var errorMessage: String?
    
    //UIImage 배열을 Storage에 업로드 하기 위해 UIImage를 -> Data로 변환하여 반환하는 함수
    func convertImageToData() -> [Data] {
        return self.images.compactMap { uiImage in
            uiImage.jpegData(compressionQuality: 0.2)
        }
    }
    
    func getUpdatePet(pet: Pet) async {
        let updatingPet = Pet(
            id: pet.id,
            name: pet.name,
            description: pet.description,
            age: pet.age,
            category1: pet.category1,
            category2: pet.category2,
            tag: pet.tag,
            breed: pet.breed,
            images: pet.images,
            ownerUid: pet.ownerUid,
            createdAt: pet.createdAt,
            updatedAt: pet.updatedAt)
        
        myPet = updatingPet
        do{
            for url in pet.images{
                if let image = try await getUrlImage(urlString: url){
                    images.append(image)
                }
            }
        }catch{
            print(error)
        }
        print(images)
    }
    
    //편집할 때 url주소를 UIImage로 변환하는 함수 - 희철
    func getUrlImage(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            errorMessage = "Failed to load image"
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            errorMessage = "Image cannot be created"
            return nil
        }
        
        return image
    }
    
    @MainActor
    func uploadMyPet() async {
        guard let userUid = Auth.auth().currentUser?.uid else {
            errorMessage = "로그인 상태가 아님"
            return
        }
        self.loadState = .loading
        myPet.ownerUid = userUid
        do {
            let imageDatas = convertImageToData()
            myPet.images = try await uploadImages(imageDatas, documentId: myPet.id ?? UUID().uuidString)
            myPet.location = try await getUserData(userUid)
            let petEncode = try Firestore.Encoder().encode(myPet)
            _ = try await self.db.collection("Pet").document(myPet.id ?? UUID().uuidString).setData(petEncode, merge: true)
            self.loadState = .complete
        } catch {
            self.loadState = .none
            self.errorMessage = "펫 등록에 실패했습니다. 다시 시도해 주세요."
        }
    }
    
    @MainActor
    func uploadImages(_ images: [Data], documentId: String) async throws -> [String] {
        var imageUrls: [String] = []
        let StorageRef = Storage.storage().reference()
        
        do {
            for image in images {
                let ref = StorageRef.child("Pet").child(documentId).child(UUID().uuidString)
                let _ = try await ref.putDataAsync(image)
                let url = try await ref.downloadURL()
                imageUrls.append(url.absoluteString)
            }
            return imageUrls
        } catch {
            throw UploadError.upLoadImageFailed
        }
    }
    
    func getUserData(_ userUid: String) async throws -> String {
        do {
            return try await self.db.collection("User").document(userUid).getDocument(as: MateUser.self).location
        } catch {
            throw UploadError.upLoadFailed
        }
    }
    
    
    //PhotosPickerItem을 UIImage로 변환하여 images 배열에 값을 추가하는 함수
    @MainActor
    func convertPickerItemToImage() {
        if !selectedPhotos.isEmpty {
            for photo in selectedPhotos {
                Task {
                    if let imageData = try await photo.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
    }
    
    func removeImageInArray(image: UIImage){
        images.enumerated().forEach { index, value in
            if value == image {
                images.remove(at: index)
            }
        }
    }
    
    func tagTapped(_ tag: String) {
        if let index = myPet.tag.firstIndex(where: { $0 == tag }) {
            myPet.tag.remove(at: index)
        } else {
            myPet.tag.append(tag)
        }
    }
}
