//
//  AddPostView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI
import PhotosUI

struct AddPostView: View {
    let document: Document
    @StateObject var viewModel = AddPostViewModel() // 뷰모델 객체 생성
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: Image? = nil // Image를 저장할 상태 변수
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // 프로그레스바
                ProgressView(value: 1.0, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .brown))
                    .frame(height: 5)
                    .offset(y:-60)
                
                // 이미지 선택 버튼
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
                
                // 제목과 내용 입력 필드
                VStack(alignment: .leading) {
                    Text("제목")
                        .font(.headline)
                    TextField("30자 이내로 작성해 주세요.", text: $viewModel.title)
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
                    TextEditor(text: $viewModel.content)
                        .frame(height: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(viewModel.content.isEmpty ? .gray : .primary)
                        .overlay(
                            VStack(alignment: .leading) {
                                if viewModel.content.isEmpty {
                                    Text("'\(document.place_name)' 어떠셨나요?\n자세한 후기는 반려인에게 도움이 됩니다!")
                                        .opacity(0.25)
                                        .padding(.top, 8)
                                        .offset(x:-10,y:-110)
                                }
                            }
                        )
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("📍\(document.place_name)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        viewModel.savePost()
                    }
                    .disabled(viewModel.isUploading)
                }
            }
        }
    }
}

#Preview {
    AddPostView(document: Document(
        place_name: "카카오프렌즈 코엑스점",
        distance: "418",
        place_url: "http://place.map.kakao.com/26338954",
        category_name: "가정,생활 > 문구,사무용품 > 디자인문구 > 카카오프렌즈",
        address_name: "서울 강남구 삼성동 159",
        road_address_name: "서울 강남구 영동대로 513",
        x: "127.05902969025047",
        y: "37.51207412593136",
        phone: "02-6002-1880",
        category_group_code: "",
        category_group_name: ""
    ))
}
