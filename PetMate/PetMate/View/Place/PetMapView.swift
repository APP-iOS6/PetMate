//
//  PetMapView.swift
//  PetMate
//
//  Created by 김정원 on 10/15/24.
//

import SwiftUI
import MapKit

struct PetMapView: View {
    
    @Environment(PetPlacesStore.self) private var placeStore
    @State private var showAddPlaceView = false
    @State private var showSearchPlaceView = false

    var body: some View {
        NavigationStack {
            VStack {
                Map {
                    ForEach(placeStore.places) { place in
                        Annotation("\(place.placeName)", coordinate: placeStore.convertGeoPointToCoordinate(geoPoint: place.location)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.yellow)
                                Text("☕️")
                                    .padding(5)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showAddPlaceView.toggle()
                    }) {
                        Image(systemName: "pencil")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        showSearchPlaceView.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .navigationTitle("반려동물 동반 카페")
            .sheet(isPresented: $showAddPlaceView) {
                AddPlaceView()
            }
            .sheet(isPresented: $showSearchPlaceView) {
                StoreSearchView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PetMapView()
            .environment(PetPlacesStore())
    }
}
