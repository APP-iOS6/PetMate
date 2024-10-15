//
//  PlacePost.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct PlacePost: Codable, Identifiable {
    @DocumentID var id: String? //문서 id
    var writeUser: String //작성자의 정보를 알기위한 유저 레퍼런스
    var title: String
    var content: String
    var location: GeoPoint
    var address: String
    var placeName: String
    var isParking: Bool
    var geoHash: String
    var createdAt: Date
    var updatedAt: Date
}
