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
            }
            .navigationTitle("반려동물 동반 카페")
            .sheet(isPresented: $showAddPlaceView) {
                AddPlaceView()
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
