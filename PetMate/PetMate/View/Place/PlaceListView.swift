//
//  StoreListView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceListView: View {
    private var placeStore: PetPlacesStore = .init()
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
            .toolbar {
                NavigationLink(destination: Text("dd")) {
                    Image(systemName: "map")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                
                NavigationLink(destination: Text("dd")){
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlaceListView()
    }
}
