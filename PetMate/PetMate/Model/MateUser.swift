//
//  User.swift
//  PetMate
//
//  Created by 권희철 on 10/14/24.
//

import Foundation
import FirebaseFirestore

struct MateUser: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var image: String
    var matchCount: Int
    var location: String
    var createdAt: Date
}
