//
//  Address.swift
//  PetMate
//
//  Created by 김동경 on 10/19/24.
//

import Foundation

struct Districts: Codable, Identifiable {
    var id: String = UUID().uuidString
    var gu: String
    var dong: [String]
}
