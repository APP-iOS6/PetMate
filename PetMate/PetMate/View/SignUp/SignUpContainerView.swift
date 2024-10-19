//
//  SignUpContainerView.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import SwiftUI

struct SignUpContainerView: View {
    
    @Environment(AuthManager.self) var authManager
    private var viewModel: SignUpViewModel = .init()
    
    var body: some View {
        @Bindable var vm = viewModel

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
                        .transition(.opacity)
                case .profile:
                    SignUpProfileView(viewModel: viewModel)
                        .transition(.opacity)
                }
            }
            .animation(.smooth, value: viewModel.progress)
            .sheet(isPresented: $vm.isSearchModal) {
                SearchAddressModal { district in
                    viewModel.mateUser.location = district
                }
            }
            .padding()
        }
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onChange(of: viewModel.loadState) { oldValue, newValue in
            if newValue == .complete {
                authManager.authState = .welcome
            }
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
        switch viewModel.progress {
        case .address:
            authManager.authState = .unAuth
        case .profile:
            viewModel.progress = .address
        }
    }
}

#Preview {
    SignUpContainerView()
        .environment(AuthManager())
}
