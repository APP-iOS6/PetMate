//
//  PetPlaceStore.swift
//  PetMate
//
//  Created by 김정원 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore
import MapKit

@Observable
final class PetFriendlyPlacesStore {
    var places: [PlacePost] = []
    private var db = Firestore.firestore()
    
    init() {
        fetchPlaces()
    }
    
    func fetchPlaces() {
        Task {
            do {
                let querySnapshot = try await db.collection("Place").getDocuments()
                self.places = try querySnapshot.documents.compactMap { document in
                    try document.data(as: PlacePost.self)
                }
                print("장소 데이터 가져오기 성공")
            } catch {
                print("장소 데이터를 가져오지 못했습니다.")
                print(error.localizedDescription)
            }
        }
    }
   
    func convertGeoPointToCoordinate(geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}
