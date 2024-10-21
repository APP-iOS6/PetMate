//
//  HomeView2.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/17/24.
//

// 임시로 사용 할 뷰
import SwiftUI

struct HomeView2: View {
    // 홈뷰2가 불릴 때 홈뷰뷰모델도 같이 생성이 됨
    //    private var viewModel: HomeViewViewModel = HomeViewViewModel()
    
    @State private var viewModel: HomeViewViewModel
    
    init(viewModel: HomeViewViewModel = HomeViewViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    @State private var currentPage = 0
    // 광고배너
    private let images = ["Advertising_banner", "homebanner"]
    // 후기
    private let reviewImages = ["review_image", "review_image1"]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        switch viewModel.phase {
        case .loading:
            ProgressView()
        case .success:
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Image("home_logo_image")
                            .resizable()
                            .frame(width: 124, height: 25)
                            .padding(.bottom, 20)
                        
                        HStack {
                            Text("📍\(viewModel.myInfo?.location ?? "")")
                                .font(.subheadline)
                            
                            Text("지금 근처에 3명의 친구가 있어요")
                                .font(.caption)
                                .foregroundColor(Color.location)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack(alignment: .bottom) {
                            TabView(selection: $currentPage) {
                                ForEach(images.indices, id: \.self) { index in
                                    Image(images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 360, height: 140)
                                        .tag(index)
                                }
                            }
                            .frame(width: 360, height: 140)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .onReceive(timer) { _ in
                                withAnimation {
                                    currentPage = (currentPage + 1) % images.count
                                }
                            }
                            
                            // 커스텀 페이지 컨트롤러
                            ZStack {
                                HStack(spacing: 5) {
                                    ForEach(images.indices, id: \.self) { index in
                                        Circle()
                                            .fill(index == currentPage ? Color.brown : Color.gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                            .padding(.bottom, 5)
                        }
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                print("돌봄 버튼")
                            }) {
                                Image("care_button")
                                    .resizable()
                                    .frame(width: 175, height: 127)
                            }
                            
                            Button(action: {
                                print("산책 버튼")
                            }) {
                                Image("walk_button")
                                    .resizable()
                                    .frame(width: 175, height: 127)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 5)
                        
                        
                        VStack(alignment: .leading) {
                            Text("메이트 후기가 궁금해요!")
                                .font(.headline)
                                .padding(.horizontal, 30)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 11) {
                                    ForEach(reviewImages, id: \.self) { image in
                                        Button(action: {
                                        }) {
                                            Image(image)
                                                .resizable()
                                                .frame(width: 320, height: 107.68)
                                        }
                                    }
                                }
                                .padding(.horizontal, 28)
                            }
                        }
                        .padding(.bottom, 5)
                        
                        
                        VStack(alignment: .leading) {
                            Text("내 주변 댕댕이 친구 찾아주기")
                                .font(.headline)
                                .padding(.horizontal, 30)
                            
                            HomeFindFriendsScrollView(viewModel: viewModel)
                        }
                        .padding(.bottom, 5)
                        
                        Image("report_banner")
                            .resizable()
                            .frame(width: 360, height: 79)
                            .padding(.top, -20)
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 30)
                }
            }
        case .failure:
            Button {
                Task {
                    await viewModel.getMyInfodata()
                }
            } label: {
                Text("오류 다시시도하기") // 에러에 대한 처리가 가장 중요
            }
        }
        
    }
}

#Preview {
    let viewModel = HomeViewViewModel(initialPhase: .success)
    viewModel.nearPets = [
        Pet(id: "1", name: "멍멍이", description: "귀여운 강아지", age: 3, tag: [], breed: "골든 리트리버", images: ["dog1"], ownerUid: "owner1", createdAt: Date(), updatedAt: Date(), location: "강남구 개포1동"),
        Pet(id: "2", name: "야옹이", description: "사랑스러운 강아지", age: 2, tag: [], breed: "불독", images: ["dog2"], ownerUid: "owner2", createdAt: Date(), updatedAt: Date(), location: "강남구 개포1동"),
        Pet(id: "3", name: "토토", description: "장난꾸러기 강아지", age: 1, tag: [], breed: "진돗개", images: ["dog3"], ownerUid: "owner3", createdAt: Date(), updatedAt: Date(), location: "강남구 개포1동"),
        Pet(id: "4", name: "얌얌", description: "말썽쟁이 강아지", age: 1, tag: [], breed: "비숑", images: ["dog4"], ownerUid: "owner3", createdAt: Date(), updatedAt: Date(), location: "강남구 개포1동")
    ]
    return HomeView2(viewModel: viewModel)
}
