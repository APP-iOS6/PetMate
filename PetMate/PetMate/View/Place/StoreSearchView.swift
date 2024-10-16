//
//  PlaceSearchView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI
import CoreLocation

struct StoreSearchView: View {
    @State private var placeStore = PetPlacesStore()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("주소 또는 매장 이름 검색", text: $placeStore.query)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
                Spacer()
                if placeStore.isLoading {
                    ProgressView("검색 중...")
                        .padding()
                }
                
                if let errorMessage = placeStore.errorMessage, !placeStore.isLoading {
                    Text(errorMessage)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                if !placeStore.stores.isEmpty && !placeStore.isLoading {
                    List(placeStore.stores) { store in
                        VStack(alignment: .leading) {
                            NavigationLink(destination: StoreDetailView()) {
                                Text(store.place_name)
                                    .font(.headline)
                                Text(store.road_address_name.isEmpty ? store.address_name : store.road_address_name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                } else if placeStore.stores.isEmpty && !placeStore.query.isEmpty && !placeStore.isLoading {
                    Spacer()
                    Text("검색 결과가 없습니다.")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .navigationTitle("주소 검색")
            .onAppear {
                if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    if let location = locationManager.location {
                        placeStore.updateLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
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
    StoreSearchView()
}
