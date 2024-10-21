//
//  Place.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import Foundation

enum SearchState {
    case searchPlace
    case confirmInfo
    case addPlace
    
    var progressValue: Double {
        switch self {
        case .searchPlace:
            return 0.33
        case .confirmInfo:
            return 0.66
        case .addPlace:
            return 1
        }
    }
}
struct KakaoAPIResponse: Codable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
    let same_name: SameName
}

struct SameName: Codable {
    let region: [String]
    let keyword: String
    let selected_region: String?
}

struct Document: Codable, Identifiable {
    var id: String { place_name } // Unique identifier로 place_name 사용 (실제 사용 시 ID를 적절히 설정)
    let place_name: String
    let distance: String?
    let place_url: String
    let category_name: String
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let phone: String?
    let category_group_code: String?
    let category_group_name: String?
}

struct Store: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
}
