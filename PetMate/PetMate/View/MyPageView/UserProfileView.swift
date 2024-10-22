//
//  UserProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct UserProfileView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var isEditingIntroduction = false // 편집모드인지 여부
    @State private var introduction = "소개를 기다리고 있어요"
    
    @State private var viewModel: MyPageViewViewModel = MyPageViewViewModel()
    
//    init(viewModel: MyPageViewViewModel = MyPageViewViewModel()) {
//        _viewModel = State(initialValue: viewModel)
//    }
//
    var body: some View {
        VStack {
            switch viewModel.phase {
            case .loading:
                ProgressView()
            case .success:
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 16) {
                        ZStack(alignment: .bottom) {
                            (profileImage ?? Image(viewModel.myInfo?.image ?? "default_image"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                            
                            Text("편집")
                                .font(.caption)
                                .padding(4)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .padding(.bottom, 4)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(image: $profileImage)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(viewModel.myInfo?.name ?? "사용자 이름")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                Text("📍\(viewModel.myInfo?.location ?? "위치 정보 없음")")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            Text("메이트 횟수: \(viewModel.myInfo?.matchCount ?? 0)번")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        Text("쩰리 점수 ")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Text("")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            case .failure:
                Button {
                    Task {
                        await viewModel.getMyInfodata()
                    }
                } label: {
                    Text("오류 다시시도하기")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getMyInfodata()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    UserProfileView()
}

// 프리뷰 확인용
extension MyPageViewViewModel {
    convenience init(initialPhase: Phase = .success) {
        self.init()
        self.phase = initialPhase
        self.myInfo = MateUser(
            id: "preview",
            name: "프리뷰 사용자",
            image: "default_image_url",
            matchCount: 0,
            location: "강남구 개포1동",
            createdAt: Date()
        )
    }
}
