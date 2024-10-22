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
    
    init(viewModel: HomeViewViewModel = HomeViewViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.phase {
        case .loading:
            ProgressView()
        case .success:
            VStack {
                HomeMyLocationView(myInfo: viewModel.myInfo, nearbyFriendsCount: viewModel.nearPets.count) // 로고, 내 지역
                ScrollView {
                    VStack(spacing: 30) {
                        HomeMainBannerView()
                        HomeFindMateView()
                        HomeReviewScrollView()
                        HomeFindFriendsScrollView(viewModel: viewModel)
                        
                        Image("report_banner")
                            .resizable()
                            .frame(width: 360, height: 98)
                            .padding(.top, -10)
                            .padding(.bottom, 30)
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
