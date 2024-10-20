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
    @Environment(\.dismiss) private var dismiss
    @State private var showPlaceCardView = false
    @State private var selectedPlace: PlacePost? = nil // 선택된 장소를 저장하는 상태
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { proxy in
                Map {
                    ForEach(placeStore.places) { place in
                        Annotation("\(place.placeName)", coordinate: placeStore.convertGeoPointToCoordinate(geoPoint: place.location)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.yellow)
                                Text("☕️")
                                    .padding(5)
                            }
                            .onTapGesture(perform: {
                                selectedPlace = place
                                showPlaceCardView.toggle()
                            })
                        }
                    }
                }
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.square.fill")
                        .resizable()
                        .background(.white)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                }
                .onAppear {
                    placeStore.fetchPlaces()
                }
                .overlay(
                    Group {
                        if showPlaceCardView, let place = selectedPlace {
                            PlaceCardView(place: place)
                                .onTapGesture {
                                    showPlaceCardView = false
                                }
                        }
                    },
                    alignment: .bottom
                )
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
