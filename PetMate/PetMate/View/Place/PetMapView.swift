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
    @State private var selectedPlace: PlacePost?
    
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
            }
        }
        .sheet(isPresented: $showPlaceCardView) {
            HStack {
                if let place = selectedPlace {
                    AsyncImage(url: URL(string: place.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("📍\(place.placeName)")
                            .font(.headline)
                            .lineLimit(1)
                            .fontWeight(.bold)
                            .padding(.vertical,3)
                        
                        Text(place.address)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
            .presentationDetents([.height(150)])
            .presentationDragIndicator(.visible)
        }
        
    }
    
}

#Preview {
    NavigationStack {
        PetMapView()
            .environment(PetPlacesStore())
    }
}
