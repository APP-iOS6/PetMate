//
//  TabView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI

struct HomeTabView: View {
    @State private var showChatDetail = false
    var chatListViewModel: ChatRoomListViewModel = .init()

    var body: some View {
        
        TabView {
            NavigationStack {
                //Text("test")
                HomeView2(viewModel: HomeViewViewModel())
            }
            .tabItem {
                Text("Home")
                Image(systemName: "house")
            }
            NavigationStack {
                PetPlaceView()
                    .environment(PetPlacesStore())
            }
            
            .tabItem {
                Text("Place")
                Image(systemName: "pawprint")
            }
            
            ChatRoomListView(viewModel: chatListViewModel)
                .tabItem {
                    Text("Chat")
                    Image(systemName: "message.badge.rtl")
                }
                .badge(chatListViewModel.totalUnreadCount)
            MyPageView()
                .tabItem {
                    Text("My")
                    Image(systemName: "person")
                }
        }
    }
    
}

#Preview {
    HomeTabView()
}
