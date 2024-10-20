//
//  RegisterPetView.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import SwiftUI

struct RegisterPetView: View {
    
    private var viewModel: RegisterPetViewModel = RegisterPetViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                headerSection()
                    .padding(.bottom, .screenHeight * 0.05)
                
                HStack {
                    Spacer()
                    ForEach(PetType.allCases, id: \.self) { type in
                        PetTypeButton(type: type, selected: viewModel.myPet.type == type.petType) {
                            viewModel.myPet.type = type.petType
                        }
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity)
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

struct PetTypeButton: View {
    
    let type: PetType
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(type.petType)
                .font(.headline)
                .bold()
                .foregroundStyle(selected ? .white : Color.accentColor)
            Image(type.rawValue)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(selected ? Color.accentColor : Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}




#Preview {
    RegisterPetView()
}
