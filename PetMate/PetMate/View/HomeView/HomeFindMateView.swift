//
//  HomeFindButtonsView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeFindMateView: View {
    @State var isPresented: Bool = false
    var body: some View {
        GeometryReader{ proxy in
            HStack{
                HomeFindMateButton(text: "돌봐주세요", color: .brown, proxy: proxy){
                    isPresented.toggle()
                }
                Spacer()
                HomeFindMateButton(text: "돌봐주세요", color: .brown, proxy: proxy){
                    isPresented.toggle()
                }
                Spacer()
                
            }.navigationDestination(isPresented: $isPresented) {
                MatePostListView()
            }
            .task {
                //await testStore.getUser()
                //await testStore.getPet()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeFindMateView()
    }
}
