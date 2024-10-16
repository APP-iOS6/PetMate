//
//  Bundle+Extension.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import Foundation

extension Bundle {
    var kakaoAppKey: String {
        guard let key = infoDictionary?["KAKAO_APP_KEY"] as? String, !key.isEmpty else {
            fatalError("KAKAO_APP_KEY is missing in Info.plist")
        }
        return key
    }
}
