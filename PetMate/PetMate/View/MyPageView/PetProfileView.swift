//
//  PetProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct PetProfileView: View {
    var mateUser: MateUser
    @State private var profileImage: Image?
    @State private var isShowingEditPetProfile = false // 편집 시트
    @State private var isShowingDeleteConfirmation = false // 삭제 확인
    // 더미 데이터 생성
    public let dummyPet = Pet(
        id: "1",
        name: "가디",
        description: "눈웃음이 매력입니다",
        age: 3, category1: "강아지",
        tag: ["활발함", "사람 좋아요", "예방 접종 완료"],
        breed: "포메",
        images: ["gadiProfile"],
        ownerUid: "정원",
        createdAt: Date(),
        updatedAt: Date()
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                (profileImage ?? Image(dummyPet.images.first ?? "placeholder"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(dummyPet.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text("\(dummyPet.age)살")
                            .font(.system(size: 12))
                        Spacer()
                        
                        // ... 버튼
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
                    Text("📍\(mateUser.location)에 사는 \(dummyPet.breed)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                }
            }
            .sheet(isPresented: $isShowingEditPetProfile) {
                PetProfileEditView()
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
                Text("나의 성격")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                // 설명글
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .background(Color.white)
                        .frame(minHeight: 40)
                        .padding(.top, 2)
                    
                    Text(dummyPet.description.isEmpty ? "저를 설명해주세요!" : dummyPet.description)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .padding(8)
                }
                
                // 태그(파베: tag: [String]) 띄우기
                HStack {
                    ForEach(dummyPet.tag, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top, 4)
            Spacer()
        }
        .padding()
        .frame(width: 365, height: 300, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
                .background(Color.white)
        )
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = MateUser(name: "김정원", image: "gardenProfile", matchCount: 5, location: "구월3동", createdAt: Date())
        PetProfileView(mateUser: user)
    }
}
