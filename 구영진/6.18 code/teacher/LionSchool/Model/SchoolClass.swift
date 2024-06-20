//
//  SchoolClass.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import Foundation

struct SchoolClass: NameExist, CampaignExist, Identifiable {
    var id: UUID = UUID()
    var name: String
    var campaign: String
    var students: [Student]
}
