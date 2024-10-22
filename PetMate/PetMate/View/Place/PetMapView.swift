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
    @ObservedObject private var locationManager = LocationManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showPlaceCardView = false
    @State private var selectedPlace: PlacePost? = nil
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { proxy in
                Map(initialPosition: .region(MKCoordinateRegion(center: .convertUserLocationToCoordinate(x: placeStore.userLatitude , y: placeStore.userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
                    ForEach(placeStore.places) { place in
                        Annotation("\(place.placeName)", coordinate: .convertGeoPointToCoordinate(place.location)) {
                            Image("etc2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
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
                .onReceive(locationManager.$location) { location in
                    if let location = location {
                        placeStore.updateLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
                    }
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
