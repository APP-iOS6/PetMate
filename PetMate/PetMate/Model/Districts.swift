//
//  Address.swift
//  PetMate
//
//  Created by 김동경 on 10/19/24.
//

import Foundation

struct Districts: Codable, Identifiable {
    var id = UUID()
    var gu: String
    var dong: [String]
    
    private enum CodingKeys: String, CodingKey {
        case gu
        case dong
    }
}
