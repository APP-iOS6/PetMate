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
    @State private var navigateToDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    Map(initialPosition: .region(MKCoordinateRegion(center: .convertUserLocationToCoordinate(x: placeStore.userLatitude , y: placeStore.userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
                        ForEach(placeStore.places) { place in
                            Annotation("\(place.placeName)", coordinate: .convertGeoPointToCoordinate(place.location)) {
                                Image("etc3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .onTapGesture(perform: {
                                        selectedPlace = place
                                        if let place = selectedPlace {
                                            showPlaceCardView.toggle()
                                        }
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
            .toolbar(.hidden)
            .navigationDestination(isPresented: $navigateToDetail, destination: {
                if let place = selectedPlace {
                    StoreDetailView(placePost: place)
                }
            })
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
                            
                            Text(place.address.extractDistrictAndNeighborhood())
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
                .onTapGesture {
                    showPlaceCardView.toggle()
                    navigateToDetail.toggle()
                    print("네비게이션 상태 \(navigateToDetail)")
                    
                }
                .padding()
                .presentationDetents([.height(150)])
                .presentationDragIndicator(.visible)
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
