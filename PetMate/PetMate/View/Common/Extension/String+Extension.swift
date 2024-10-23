//
//  File.swift
//  PetMate
//
//  Created by 김정원 on 10/24/24.
//

import Foundation

extension String {
    /// 구와 동만 꺼내는 변환
    func extractDistrictAndNeighborhood() -> String {
        let components = self.split(separator: " ")
        guard components.count > 2 else { return self }
        return "\(components[1]) \(components[2])"
    }
}
