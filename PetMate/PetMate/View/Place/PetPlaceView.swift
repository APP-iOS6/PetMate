//
//  PlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/18/24.
//

import SwiftUI

struct PetPlaceView: View {
    @Environment(PetPlacesStore.self) private var placeStore
    private var locationManager: LocationManager = .shared
    @State private var isShowingMap: Bool = false
    @State private var showSearchPlaceView = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("🐾 펫 플레이스")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        isShowingMap.toggle()
                    }) {
                        Image(systemName: "map.fill")
                            .font(.title2)
                    }
                    Button(action: {
                        showSearchPlaceView.toggle()
                    }) {
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.title2)
                    }
                }
                .padding()
                Text("가디와 함께 어디를 가볼까?")
                    .font(.headline)
                    .padding(.horizontal)
                PlaceListView()
                .fullScreenCover(isPresented: $isShowingMap) {
                    PetMapView()
                }
                .fullScreenCover(isPresented: $showSearchPlaceView) {
                    AddPlaceView()
                        .padding(.top)
                }
            }
            .onAppear {
                if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    if let location = locationManager.location {
                        placeStore.updateLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
                        print("&*\(placeStore.userLongitude ?? 20.0) \(placeStore.userLatitude ?? 20.0)")
                    }
                }
            }
            .onReceive(locationManager.$location) { location in
                if let location = location {
                    placeStore.updateLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PetPlaceView()
            .environment(PetPlacesStore())
    }
}
