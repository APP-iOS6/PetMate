//
//  SignUpAddressView.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import SwiftUI

struct SignUpAddressView: View {
    
    var viewModel: SignUpViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("사는 지역을 입력해주세요.")
                .bold()
                .font(.title2)
                .padding(.bottom, .screenHeight * 0.03)
            
            
            
            let locationEmpty: Bool = viewModel.mateUser.location.isEmpty
            HStack {
                Text(locationEmpty ? "지역을 검색해주세요." : viewModel.mateUser.location)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(locationEmpty ? .secondary : .primary)
                
                Button {
                    viewModel.isSearchModal.toggle()
                } label: {
                    Text("검색")
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .foregroundStyle(Color.accentColor)
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.accentColor, lineWidth: 1)
                        }
                }
                
            }
            
            Divider()
                .frame(maxWidth: .screenWidth * 0.65)
                .padding(.bottom, .screenHeight * 0.1)
            
            Button {
                viewModel.progress = .profile
            } label: {
                Text("다음")
                    .modifier(ButtonModifier())
            }
            .disabled(viewModel.mateUser.location.isEmpty)
            
        }
        .padding()
        
    }
}

#Preview {
    SignUpAddressView(viewModel: SignUpViewModel())
        .padding()
}
