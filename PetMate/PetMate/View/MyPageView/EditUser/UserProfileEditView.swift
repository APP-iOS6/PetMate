//
//  UserProfileEditView.swift
//  PetMate
//
//  Created by Mac on 10/21/24.
//

import SwiftUI
import PhotosUI

struct UserProfileEditView: View {
    @State var viewModel: UserProfileEditViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: PhotosPickerItem?
    @State private var isPickerPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""


    var body: some View {
        NavigationView {
            VStack {
                // 프로필 이미지 섹션
                ZStack(alignment: .bottomTrailing) {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                            .clipShape(Circle())
                            .foregroundColor(.gray.opacity(0.3))
                            .onTapGesture {
                                selectedItem = nil
                            }
                    } else {
                        // 프로필 이미지가 없을 경우 사람 아이콘과 카메라 아이콘 표시
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                            .clipShape(Circle())
                            .onTapGesture {
                                isPickerPresented = true
                            }
                        
                        Image(systemName: "camera.circle")
                            .font(.system(size: UIScreen.main.bounds.width * 0.08))
                            .foregroundColor(.gray.opacity(0.4))
                            .padding(.trailing, -UIScreen.main.bounds.width * 0.03)
                            .padding(.bottom, -UIScreen.main.bounds.width * 0.02)
                            .foregroundColor(.gray.opacity(0.3))
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                    
                    // 프로필 이미지가 있을 때 삭제 버튼 표시
                    if viewModel.profileImage != nil {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: UIScreen.main.bounds.width * 0.06))
                            .foregroundColor(.red)
                            .padding(.trailing, -UIScreen.main.bounds.width * 0.02)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.18)
                            .onTapGesture {
                                viewModel.profileImage = nil // 이미지 삭제
                            }
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.02)
                .padding(.top, UIScreen.main.bounds.height * 0.06)

                Divider()
                    .padding(UIScreen.main.bounds.height * 0.03)

                // 닉네임 입력 필드
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                    HStack {
                        Text("필수 입력 정보")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("*")
                            .foregroundColor(.red)
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.01)

                    HStack {
                        Text("닉네임")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("*")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.01)

                    TextField("닉네임을 입력하세요 (4-10자)", text: $viewModel.nickname)
                        .padding(.vertical, UIScreen.main.bounds.height * 0.01)
                        .overlay(
                            VStack {
                                Spacer()
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray)
                            }
                        )

                    if viewModel.nickname.isEmpty {
                        Text("펫메이트 닉네임 설정은 필수입니다.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                .padding(.bottom, UIScreen.main.bounds.height * 0.02)

                // 주소 입력 필드
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                    HStack {
                        Text("주소")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("*")
                            .font(.headline)
                            .foregroundColor(.red)
                    }

                    // 주소 선택 버튼
                    Button(action: {
                        viewModel.isSearchModal.toggle()  // 주소 선택 모달 토글
                    }) {
                        HStack {
                            Text(viewModel.address.isEmpty ? "주소를 선택하세요" : viewModel.address)
                                .foregroundColor(viewModel.address.isEmpty ? Color.gray : Color.primary)
                                .padding(.vertical, UIScreen.main.bounds.height * 0.01)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.gray)
                                    }
                                )

                            // 아래 화살표
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                        }
                    }

                    if viewModel.address.isEmpty {
                        Text("주소 입력은 필수입니다.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                Spacer()

                // 저장 버튼
                Button(action: {
                    if let nicknameError = viewModel.validateNickname() {
                        alertMessage = nicknameError
                        showAlert = true
                    } else if viewModel.address.isEmpty {
                        alertMessage = "주소는 필수 항목입니다."
                        showAlert = true
                    } else {
                        viewModel.saveProfile()
                    }
                }) {
                    Text("저장")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.07)
                        .background(Color.brown)
                        .cornerRadius(8)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("필수 항목 누락"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("확인")))
                }

                .padding(.bottom, UIScreen.main.bounds.height * 0.05)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("프로필 수정하기")
                        .font(.title3)
                        .bold()
                }
            }
            .photosPicker(
                isPresented: $isPickerPresented,
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: selectedItem) { old, newItem in
                viewModel.convertPickerItemToImage(newItem)
            }
            .sheet(isPresented: $viewModel.isSearchModal) {
                SearchAddressModal { selectedAddress in
                    viewModel.address = selectedAddress
                }
            }
        }
    }
}

struct UserProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        let mateUser = MateUser(id: nil, name: "", image: "", matchCount: 0, location: "", createdAt: Date())
        UserProfileEditView(viewModel: UserProfileEditViewModel(mateUser: mateUser))
    }
}
