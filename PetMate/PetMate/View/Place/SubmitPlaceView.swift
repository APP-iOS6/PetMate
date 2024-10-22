//
//  SubmitPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI

struct SubmitPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PetPlacesStore.self) private var placeStore
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: Image? = nil // Image를 저장할 상태 변수
    @State var title: String = ""
    @State var content: String = ""
    var body: some View {
        VStack {
            Button(action: {
                isImagePickerPresented = true
            }) {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                        .offset(y:-30)
                } else {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.primary.opacity(0.25))
                            .offset(y:-30)
                        Text("내가 방문한 플레이스의\n이미지를 보여주세요.")
                            .foregroundColor(.primary.opacity(0.25))
                            .multilineTextAlignment(.center)
                            .fontWeight(.medium)
                            .offset(y:-30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
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
                TextEditor(text: $content)
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}


#Preview {
    SubmitPlaceView()
        .environment(PetPlacesStore())
}
