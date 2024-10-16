//
//  TabView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                //Text("test")
                HomeView()
            }
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
            NavigationStack {
                PetMapView()
                    .environment(PetPlacesStore())
            }
                .tabItem {
                    Text("Place")
                    Image(systemName: "map")
                }
            ChatRoomListView()
                .tabItem {
                    Text("Chat")
                    Image(systemName: "message.badge.rtl")
                }
            MyPageTabView()
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
