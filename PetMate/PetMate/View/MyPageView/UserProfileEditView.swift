//
//  UserProfileEditView.swift
//  PetMate
//
//  Created by Mac on 10/21/24.
//
import SwiftUI

struct UserProfileEditView: View {
    @ObservedObject var viewModel: UserProfileEditViewModel
    @Environment(\.presentationMode) var presentationMode  // 이전 페이지로 돌아가기

    var body: some View {
        NavigationView {
            VStack {
                // 프로필 이미지 섹션
                ZStack(alignment: .bottomTrailing) {
                    // 프로필 이미지가 있으면 해당 이미지를 보여주고, 없으면 기본 아이콘을 표시
                    (viewModel.profileImage ?? Image(systemName: "person.circle.fill"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                        .clipShape(Circle())
                        .foregroundColor(.gray.opacity(0.3))
                        .onTapGesture {
                            viewModel.isImagePickerPresented = true
                        }
                        .sheet(isPresented: $viewModel.isImagePickerPresented) {
                            ImagePicker(image: $viewModel.profileImage)
                        }

                    // 카메라 아이콘 (이미지가 없을 때만 표시)
                    if viewModel.profileImage == nil {
                        Image(systemName: "camera.circle")
                            .font(.system(size: UIScreen.main.bounds.width * 0.08))
                            .foregroundColor(.gray)
                            .padding(.trailing, -UIScreen.main.bounds.width * 0.03)
                            .padding(.bottom, -UIScreen.main.bounds.width * 0.02)
                            .opacity(0.30)
                            .onTapGesture {
                                viewModel.isImagePickerPresented = true
                            }
                    }

                    // 이미지가 있는 경우에만 X 아이콘 표시
                    if viewModel.profileImage != nil {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: UIScreen.main.bounds.width * 0.06))
                            .foregroundColor(.red)
                            .padding(.trailing, -UIScreen.main.bounds.width * 0.02)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.18)
                            .onTapGesture {
                                viewModel.profileImage = nil  // 이미지 삭제
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
                    saveProfile()
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
            .sheet(isPresented: $viewModel.isSearchModal) {
                SearchAddressModal { selectedAddress in
                    viewModel.address = selectedAddress
                }
            }
        }
    }

    private func saveProfile() {
        viewModel.updateUserProfile { success in
            if success {
                print("프로필 업데이트 성공")
                presentationMode.wrappedValue.dismiss()
            } else {
                print("프로필 업데이트 실패")
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
