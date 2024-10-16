//
//  StoreListView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceListView: View {
    private var placeStore: PetPlacesStore = .init()
    @Environment(\.dismiss) private var dismiss
    @State private var showSearchPlaceView = false 
    var body: some View {
        NavigationStack {
            VStack {
                Text("가디와 함께 어디를 가볼까?")
                    .font(.headline)
                
                ScrollView {
                    ForEach(placeStore.places) { place in
                        PlaceCardView(place: place)
                            .padding(.vertical, -5)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                Button(action: {
                    dismiss() // 'map' 버튼을 누르면 현재 뷰를 닫음
                }) {
                    Image(systemName: "map")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                
                Button(action: {
                    showSearchPlaceView.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
            }
        }
        .sheet(isPresented: $showSearchPlaceView) {
            StoreSearchView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        PlaceListView()
    }
}
