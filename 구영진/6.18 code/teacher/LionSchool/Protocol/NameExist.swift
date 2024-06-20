//
//  NameExist.swift
//  LionSchool
//
//  Created by Jongwook Park on 6/18/24.
//

import Foundation

// 이 프로토콜을 따르는 타입들은 이름 항목이 꼭 있어야 한다
protocol NameExist {
    var name: String { get set }
}
