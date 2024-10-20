//
//  RegisterPetView.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import SwiftUI

struct RegisterPetView: View {
    var body: some View {
        ScrollView {
            VStack {
                headerSection()
                    .padding(.bottom, .screenHeight * 0.05)
                
                HStack {
                    ForEach(PetType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
            }
        }
        .padding()
    }
    
    private func headerSection() -> some View {
        HStack {
            Text("나의 펫 등록하기")
                .bold()
                .font(.title2)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .bold()
            }
        }
    }
}

#Preview {
    RegisterPetView()
}
