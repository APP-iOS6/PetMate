//
//  PetProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct PetProfileView: View {
    @State private var profileImage: Image?
    @State private var isShowingDeleteConfirmation = false // 삭제 확인
    @State private var selectedPet: Pet? = nil // 선택한 펫 정보 저장
    private var viewModel: MyPageViewViewModel
    
    init(viewModel: MyPageViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let sortedPets = viewModel.petInfo.sorted { pet1, pet2 in
            return pet1.createdAt < pet2.createdAt
        } // 생성된 순으로 펫 프로필 나열
        
        let isSingle = sortedPets.count == 1 // 한 마리인지 확인하는 플래그
        
        VStack {
            if sortedPets.count > 1 {
                // 여러 마리일 때 스크롤 가능
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 16) {
                        petProfileCards(sortedPets: sortedPets)
                    }
                    .frame(maxWidth: .infinity)
                }
            } else {
                // 한 마리일 때 스크롤 없이 전체 화면 너비 사용
                HStack(alignment: .center, spacing: 0) {
                    petProfileCards(sortedPets: sortedPets, isSingle: isSingle)
                }
                .frame(maxWidth: .infinity) // 카드가 화면을 가득 채우도록 설정
            }
        }
        .sheet(item: $selectedPet) { pet in
            RegisterPetView(register: false, pet: pet) {
                // 수정 완료 후 처리
            }
        }
    }
    
    @ViewBuilder
    private func petProfileCards(sortedPets: [Pet], isSingle: Bool = false) -> some View {
        ForEach(sortedPets, id: \.self) { pet in
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
                                    selectedPet = pet // 선택한 펫 설정
                                }
                                Button("삭제하기", role: .destructive) {
                                    isShowingDeleteConfirmation = true
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.gray)
                                    .padding(16)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
                                    .offset(x: 8, y: -15)
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

                // 태그 섹션 추가
                tagSection(for: pet)

                VStack(alignment: .leading, spacing: 6) {
                    Text("나의 성격")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.top, 2)
                            .frame(minHeight: 100, maxHeight: 100)
                        
                        Text(pet.description.isEmpty == false ? pet.description : "저를 설명해주세요!")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(8)
                    }
                }
                .padding(.top, 4)
            }
            .padding() // 카드 내부 패딩만 유지
            .frame(width: isSingle ? UIScreen.main.bounds.width * 0.9 : 320) // 한 마리일 때 크기 조정
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.white.cornerRadius(12))
            )
        }
    }

    // 태그 섹션 컴포넌트
    private func tagSection(for pet: Pet) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("태그")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(pet.tag.isEmpty ? ["태그 없음"] : pet.tag, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
}



//#Preview {
//    PetProfileView()
//}
