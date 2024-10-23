//
//  HomeView2.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/17/24.
//

// 임시로 사용 할 뷰
import SwiftUI

struct HomeView2: View {
    @Bindable var viewModel: HomeViewViewModel
    @State var isPresent: Bool = false

    
    init(viewModel: HomeViewViewModel = HomeViewViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.phase {
            case .loading:
                ProgressView()
            case .success:
                VStack {
                    HStack {
                        Image("home_logo_image")
                            .resizable()
                            .frame(width: 124, height: 25)
                            .padding(.bottom, 5)
                        
                        Spacer()
                        
                        CalendarButton()
                            .padding(.trailing, -5)
                            .padding(.bottom, -25)
                    }
                    .padding(.horizontal, 20)
                    
                    HomeMyLocationView(myInfo: viewModel.myInfo, nearbyFriendsCount: viewModel.nearPets.count) // 로고, 내 지역
                        .onTapGesture {
                            isPresent.toggle()
                        }
                        .sheet(isPresented: $isPresent) {
                            SearchAddressModal { district in
                                Task{
                                    await viewModel.updateLocationData(location: district)
                                }
                            }
                        }

                    ScrollView {
                        VStack(spacing: 30) {
                            HomeMainBannerView()
                            HomeFindMateView()
                            HomeReviewScrollView(viewModel: viewModel)
                            HomeFindFriendsScrollView(viewModel: viewModel)
                            
                            Image("report_banner")
                                .resizable()
                                .frame(width: 370, height: 84)
                                .padding(.top, -10)
                                .padding(.bottom, 30)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                // 채팅화면 네비게이션 추가
                .navigationDestination(isPresented: $viewModel.shouldNavigateToChat) {
                    if let chatUser = viewModel.selectedChatUser {
                        ChatDetailView(otherUser: chatUser)
                    }
                }
                .navigationDestination(isPresented: $viewModel.reviewNavigateToChat) {
                    if let review = viewModel.selectedReview {
                        ChatDetailView(otherUser: review.reviewUser)
                    } else {
                        Text("tet")
                    }
                }
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
    }
}

#Preview {
    let viewModel = HomeViewViewModel()
    viewModel.phase = .success
    return HomeView2(viewModel: viewModel)
}
