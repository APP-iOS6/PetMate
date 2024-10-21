//
//  PlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/18/24.
//

import SwiftUI

struct PetPlaceView: View {
    @Environment(PetPlacesStore.self) private var placeStore 
    @State private var isShowingMap: Bool = false
    @State private var showSearchPlaceView = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("가디와 함께 어디를 가볼까 ?")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        isShowingMap.toggle()
                    }) {
                        Image(systemName: "map.fill")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        showSearchPlaceView.toggle()
                    }) {
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 10)
                PlaceListView()
                .fullScreenCover(isPresented: $isShowingMap) {
                    PetMapView()
                }
                .fullScreenCover(isPresented: $showSearchPlaceView) {
                    AddPlaceView()
                        .padding(.top)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PetPlaceView()
            .environment(PetPlacesStore())
    }
}
