//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
            PetMapView()
                .environment(PetPlacesStore())
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
    ContentView()
}
