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
        }
        
    }
}

#Preview {
    ContentView()
}
