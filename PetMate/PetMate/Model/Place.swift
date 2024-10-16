//
//  Place.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import Foundation

struct Store: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
}
