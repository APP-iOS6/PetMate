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
    @State private var viewModel: MyPageViewViewModel = MyPageViewViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 16) {
                    ZStack(alignment: .bottom) {
                        (profileImage ?? Image(viewModel.petInfo?.images.first ?? "placeholder"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .onTapGesture {
                                isShowingEditPetProfile = true
                            }
                        
                        Text("편집")
                            .font(.caption)
                            .padding(4)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.bottom, 4)
                    }
                    .sheet(isPresented: $isShowingEditPetProfile) {
                        PetProfileEditView()
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(viewModel.petInfo?.name ?? "이름 없음")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Text("\(viewModel.petInfo?.age ?? 0)살")
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
                        Text("📍\(viewModel.myInfo?.location ?? "위치 정보 없음")에 사는 \(viewModel.petInfo?.breed ?? "종 없음")")
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
                    // 태그(파베: tag: [String]) 띄우기
                    HStack {
                        ForEach(viewModel.petInfo?.tag ?? ["태그 없음"], id: \.self) { tag in
                            TagView(text: tag)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // 설명글
                    Text("나의 성격")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            .background(Color.white)
                            .frame(minHeight: 40)
                            .padding(.top, 2)
                        
                        Text(viewModel.petInfo?.description.isEmpty == false ? viewModel.petInfo!.description : "저를 설명해주세요!")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(8)
                    }
                }
                .padding(.top, 4)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PetProfileView()
}

// 프리뷰 확인용
//extension MyPageViewViewModel {
//    convenience init(initialPhase: Phase = .success) {
//        self.init()
//        self.phase = initialPhase
//        self.petInfo = Pet(
//            id: "1",
//            name: "가디",
//            description: "눈웃음이 매력입니다",
//            age: 3,
//            tag: ["활발함", "사람 좋아요", "예방 접종 완료"],
//            breed: "포메",
//            images: ["gadiProfile"],
//            ownerUid: "정원",
//            createdAt: Date(),
//            updatedAt: Date()
//        )
//    }
//}
