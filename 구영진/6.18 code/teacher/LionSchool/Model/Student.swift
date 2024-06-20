//
//  Student.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import Foundation

struct Student: NameExist, Identifiable {
    var id: UUID = UUID()
    var name: String
}
