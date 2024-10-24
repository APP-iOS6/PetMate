//
//  SignUpProfileView.swift
//  PetMate
//
//  Created by 김동경 on 10/19/24.
//

import SwiftUI
import PhotosUI

struct SignUpProfileView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    var viewModel: SignUpViewModel
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(alignment: .leading) {
            Text("사용자 프로필")
                .bold()
                .font(.title2)
                .padding(.bottom, .screenHeight * 0.03)
            
            VStack(alignment: .center) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 100)
                            .clipped()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 100)
                            .padding()
                            .background(Circle()
                                .stroke(Color(uiColor: .systemGray3), lineWidth: 1))
                            .tint(Color(uiColor: .systemGray3))
                        
                    }
                }
                .padding(.bottom, .screenHeight * 0.06)
                .frame(maxWidth: .infinity)
                .onChange(of: selectedItem) { oldValue, newValue in
                    viewModel.convertPickerItemToImage(newValue)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("닉네임")
                    .bold()
                    .padding(.bottom, 8)
                TextField("닉네임 변경가능, 최소 2~8자", text: $vm.mateUser.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 18))
                    .padding(.bottom, .screenHeight * 0.1)
            }
            
            Button {
                Task {
                    await viewModel.uploadUserData()
                }
            } label: {
                Text("완료")
                    .modifier(ButtonModifier())
            }
            .disabled(viewModel.mateUser.name.count <= 1 || viewModel.mateUser.name.count >= 9)
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    SignUpProfileView(viewModel: SignUpViewModel())
}
