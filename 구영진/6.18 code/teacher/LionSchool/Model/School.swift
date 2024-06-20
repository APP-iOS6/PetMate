//
//  School.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import Foundation

struct School: NameExist, CampaignExist {
    var name: String
    var campaign: String
    var levels: [Level]
}
