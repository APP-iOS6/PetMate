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
final class PetPlacesStore {
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
    
    func addPlace(writeUser: String, title: String, content: String, address: String, placeName: String, isParking: Bool, latitude: Double, longitude: Double, geoHash: String, completion: @escaping (Bool) -> Void) {
        let newPlace = PlacePost(
            writeUser: writeUser,
            title: title,
            content: content,
            location: GeoPoint(latitude: latitude, longitude: longitude),
            address: address,
            placeName: placeName,
            isParking: isParking,
            geoHash: geoHash,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Firestore에 새 문서 추가
        do {
            let _ = try db.collection("Place").addDocument(from: newPlace) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                    completion(false)
                } else {
                    print("Document added successfully")
                    completion(true)
                }
            }
        } catch {
            print("Error saving place: \(error)")
            completion(false)
        }
    }
    
    func convertGeoPointToCoordinate(geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}
