//
//  Level.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import Foundation

struct Level: NameExist, Identifiable {
    var id: UUID = UUID()
    var name: String
    var schoolClasses: [SchoolClass]
}
