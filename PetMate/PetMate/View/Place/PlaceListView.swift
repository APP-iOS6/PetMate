//
//  StoreListView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceListView: View {
    @Environment(PetPlacesStore.self) private var placeStore
    @Environment(\.dismiss) private var dismiss
    @State private var showSearchPlaceView = false
    var body: some View {
        ScrollView {
            ForEach(placeStore.places) { place in
                PlaceCardView(place: place)
                    .padding(.vertical, -5)
            }
        }
        .onAppear {
            placeStore.fetchPlaces()
        }
    }
}

#Preview {
    NavigationStack {
        PlaceListView()
    }
}
