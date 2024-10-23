//
//  SubmitPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI
import PhotosUI

struct SubmitPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PetPlacesStore.self) private var placeStore
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage? = nil // UIImage로 변경
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var title: String = ""
    @State var content: String = ""
    @State private var uploadState: UploadState = .none
    
    var body: some View {
        ScrollView {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.primary.opacity(0.25))
                        Text("내가 방문한 플레이스의\n이미지를 보여주세요.")
                            .foregroundColor(.primary.opacity(0.25))
                            .multilineTextAlignment(.center)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                }
            }
            .padding()
            .onChange(of: selectedItem) {
                Task {
                    await loadSelectedImage()
                }
            }
            
            VStack(alignment: .leading) {
                Text("제목")
                    .font(.headline)
                TextField("30자 이내로 작성해 주세요.", text: $title)
                    .overlay(
                        VStack {
                            Divider()
                                .background(Color.black)
                                .offset(y: 20)
                        }
                    )
                
                Text("내용")
                    .font(.headline)
                    .padding(.top, 30)
                ScrollView {
                    TextEditor(text: $content)
                        .frame(height: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(.primary)
                        .onTapGesture {
                            hideKeyboard()
                        }
                }
                .background(Color.white) // ScrollView의 배경을 설정하여 터치 영역 확대
                .onTapGesture {
                    hideKeyboard() // ScrollView 외부 터치 시 키보드 내리기
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    await savePlace()
                }
            }) {
                Text("저장")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            
            Spacer()
        }
        .overlay {
            if uploadState == .loading {
                ProgressView()
            }
        }
        .alert("업로드 실패", isPresented: .constant(uploadState == .failed), actions: {
            Button("확인", role: .cancel) {
                uploadState = .none
            }
        }, message: {
            Text("이미지 업로드에 실패했습니다.")
        })
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @MainActor
    private func loadSelectedImage() async {
        if let selectedItem = selectedItem {
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        }
    }
    
    @MainActor
    private func savePlace() async {
        uploadState = .loading
        
        var imageURL: String?
        
        do {
            // 사용자가 선택한 이미지가 있으면 해당 이미지를 업로드
            if let image = selectedImage {
                imageURL = try await placeStore.uploadImage(image)
            } else {
                // 기본 이미지를 사용
                if let defaultImage = UIImage(named: "cafe2") {
                    imageURL = try await placeStore.uploadImage(defaultImage)
                }
            }
            
            placeStore.addPlace(
                writeUser: UUID().uuidString,
                title: title,
                content: content,
                category: placeStore.selectedPlace?.category_name ?? "",
                phone: placeStore.selectedPlace?.phone ?? "",
                address: placeStore.selectedPlace?.address_name ?? "",
                image: imageURL,
                placeName: placeStore.selectedPlace?.place_name ?? "",
                isParking: true,
                latitude: Double(placeStore.selectedPlace?.y ?? "0")!,
                longitude: Double(placeStore.selectedPlace?.x ?? "0")!,
                geoHash: ""
            ) { success in
                if success {
                    
                    placeStore.fetchPlaces()
                    dismiss()
                    placeStore.searchState = .searchPlace

                } else {
                    print("Failed to add place")
                }
            }
        } catch {
            uploadState = .failed
            print("Image upload failed: \(error.localizedDescription)")
        }
    }
}

enum UploadState {
    case none, loading, complete, failed
}

#Preview {
    SubmitPlaceView()
        .environment(PetPlacesStore())
}
