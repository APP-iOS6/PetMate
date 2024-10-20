//
//  Pet.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct Pet: Codable, Identifiable, Hashable {
    @DocumentID var id: String? //문서 id
    var name: String    //이름
    var description: String //설명 및 주의사항
    var age: Int    //나이
    var type: String //강아지? 고양이? 그 외?
    var tag: [String]   //태그들
    var breed: String   //품종 및 종류
    var images: [String]    //사진 주소들
    var ownerUid: String //주인uid
    var createdAt: Date //생성일
    var updatedAt: Date //업데이트 일
}


enum PetType: String, CaseIterable {
    case dog = "dog"
    case cat = "cat"
    case others = "others"
    
    var petType: String {
        switch self {
        case .dog:
            "강아지"
        case .cat:
            "고양이"
        case .others:
            "그 외"
        }
    }
}
