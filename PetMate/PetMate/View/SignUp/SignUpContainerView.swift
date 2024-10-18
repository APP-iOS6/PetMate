//
//  SignUpContainerView.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import SwiftUI

struct SignUpContainerView: View {
    
    private var viewModel: SignUpViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack {
                
                TopHeader()
                
                ProgressView(value: viewModel.progress.rawValue, total: 1.0)
                    .tint(Color.accentColor)
                    .progressViewStyle(.linear)
                    .padding(.bottom, 24)
                    .animation(.easeInOut(duration: 0.1), value: viewModel.progress)
                
                switch viewModel.progress {
                case .address:
                    SignUpAddressView(viewModel: viewModel)
                case .profile:
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    private func TopHeader() -> some View {
        HStack {
            Text("사용자 정보 입력하기")
                .font(.title2)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            Button {
                goBack()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    
    private func goBack() {
        
    }
}

#Preview {
    SignUpContainerView()
}
