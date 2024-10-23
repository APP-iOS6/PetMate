//
//  PetProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct PetProfileView: View {
    @State private var profileImage: Image?
    @State private var isShowingEditPetProfile = false // 편집 시트
    @State private var isShowingDeleteConfirmation = false // 삭제 확인
    private var viewModel: MyPageViewViewModel
    
    init(viewModel: MyPageViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(viewModel.petInfo, id: \.self) { pet in
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 16) {
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: pet.images.first ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            } placeholder: {
                                Image("")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                        .sheet(isPresented: $isShowingEditPetProfile) {
                            RegisterPetView(pet: pet){}
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(pet.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text("\(pet.age)살")
                                    .font(.system(size: 12))
                                Spacer()
                                
                                Menu {
                                    Button("수정하기") {
                                        isShowingEditPetProfile = true
                                    }
                                    Button("삭제하기", role: .destructive) {
                                        isShowingDeleteConfirmation = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.gray)
                                        .padding(8)
                                }
                            }
                            Text("📍\(pet.location)에 사는 \(pet.breed)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .alert(isPresented: $isShowingDeleteConfirmation) {
                        Alert(
                            title: Text("삭제 확인"),
                            message: Text("이 반려동물 프로필을 정말 삭제하시겠습니까?"),
                            primaryButton: .destructive(Text("삭제하기")) {
                                // 삭제 처리 로직
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            ForEach(pet.tag.isEmpty ? ["태그 없음"] : pet.tag, id: \.self) { tag in
                                TagView(text: tag)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Text("나의 성격")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                .background(Color.white)
                                .frame(minHeight: 100, maxHeight: 100)
                                .padding(.top, 2)
                            Text(pet.description.isEmpty == false ? pet.description : "저를 설명해주세요!")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .padding(8)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    PetProfileView()
//}
