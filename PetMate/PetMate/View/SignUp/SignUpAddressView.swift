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
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Text("나의 동네를 입력해 주세요.")
                    .bold()
                    .font(.title2)
                
                Spacer()
                    .frame(maxHeight: proxy.size.height * 0.15)
                
                let locationEmpty: Bool = viewModel.mateUser.location.isEmpty
                HStack {
                    Text(locationEmpty ? "서울시 마포구" : viewModel.mateUser.location)
                        .frame(maxWidth: proxy.size.width * 0.7, alignment: .leading)
                        .foregroundStyle(locationEmpty ? .secondary : .primary)
                    
                    Button {
                        
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
                    .frame(maxWidth: proxy.size.width * 0.7, alignment: .leading)
            }
            .padding()
        }
    }
}

#Preview {
    SignUpAddressView(viewModel: SignUpViewModel())
        .padding()
}
