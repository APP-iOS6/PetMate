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
    var stores: [Document] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var userLongitude: String?
    var userLatitude: String?
    var searchRadius: Int? = 20000 //20Km
    var query: String = "" {
        didSet {
            querySubject.send(query)
        }
    }
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private let querySubject = PassthroughSubject<String, Never>()
    private let apiClient: KakaoAPIClient = KakaoAPIClient()
    
    init() {
        fetchPlaces()
        setupQueryListener()
    }
    // MARK: 주위 검색 기반 메서드
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
        guard !query.isEmpty else {
            self.stores = []
            self.errorMessage = nil
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        apiClient.searchPlaces(query: query, x: userLongitude, y: userLatitude, radius: searchRadius)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error searching places: \(error)")
                    self.errorMessage = "장소 검색 중 오류."
                    self.stores = []
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.stores = response.documents
                if self.stores.isEmpty {
                    self.errorMessage = "검색 결과가 없습니다."
                }
            })
            .store(in: &cancellables)
    }
    
    func updateLocation(longitude: Double, latitude: Double) {
        self.userLongitude = String(longitude)
        self.userLatitude = String(latitude)
    }
    
    // MARK: 사용자가 등록한 장소 관련 메서드
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
