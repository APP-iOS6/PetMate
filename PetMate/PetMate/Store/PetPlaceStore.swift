//
//  PetPlaceStore.swift
//  PetMate
//
//  Created by 김정원 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore
import MapKit
import Combine

@Observable
final class PetPlacesStore {
    var places: [PlacePost] = []
    var query: String = "" {
        didSet {
            querySubject.send(query)
        }
    }
    var stores: [Store] = []
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private let querySubject = PassthroughSubject<String, Never>()
    
    init() {
        fetchPlaces()
        setupQueryListener()
        
    }
    private func setupQueryListener() {
        querySubject
            .debounce(for: .seconds(1), scheduler: RunLoop.main) // 1초 디바운스
            .removeDuplicates()
            .sink { [weak self] newQuery in
                print("New query received: \(newQuery)") // 디버깅 로그
                self?.searchStores(query: newQuery)
            }
            .store(in: &cancellables)
    }
    private func searchStores(query: String) {
        print("Searching for: \(query)")
        guard !query.isEmpty else {
            DispatchQueue.main.async {
                self.stores = []
            }
            return
        }
        
        // 필터링 로직 (대소문자 무시)
        let filteredStores = allStores.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.address.localizedCaseInsensitiveContains(query)
        }
        
        // 메인 스레드에서 업데이트
        DispatchQueue.main.async {
            self.stores = filteredStores
        }
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
let allStores = [
    Store(id: UUID(), name: "스타벅스", address: "서울특별시 강남구"),
    Store(id: UUID(), name: "이디야", address: "서울특별시 종로구"),
    Store(id: UUID(), name: "할리스", address: "부산광역시 해운대구"),
    Store(id: UUID(), name: "투썸플레이스", address: "서울특별시 마포구"),
    Store(id: UUID(), name: "커피빈", address: "대구광역시 중구")
]
