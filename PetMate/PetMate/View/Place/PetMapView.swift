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
    @State private var showPlaceCardView = false
    @State private var selectedPlace: PlacePost? = nil // 선택된 장소를 저장하는 상태
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack {
                    Text("가디와 함께 어디를 가볼까?")
                        .font(.headline)
                        .padding()
                    
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
                    .padding(.horizontal)
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
                .toolbar {
                    NavigationLink(destination: PlaceListView()) {
                        Image(systemName: "list.star")
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
                .sheet(isPresented: $showAddPlaceView) {
                    AddPlaceView()
                }
                .sheet(isPresented: $showSearchPlaceView) {
                    StoreSearchView()
                }
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
