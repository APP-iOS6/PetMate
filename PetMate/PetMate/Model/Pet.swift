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
    var category1: String = "dog" //강아지? 고양이? 그 외?
    var category2: String = "small"
    var tag: [String]   //태그들
    var breed: String   //품종 및 종류
    var images: [String]    //사진 주소들
    var ownerUid: String //주인uid
    var createdAt: Date //생성일
    var updatedAt: Date //업데이트 일
    var location: String = ""
}


enum PetType: String, CaseIterable {
    case dog = "dog"
    case cat = "cat"
    case others = "etc"
    
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

enum SizeType: String, CaseIterable {
    case small = "small"
    case midium = "midium"
    case large = "large"
    case baby = "baby"
    
    var sizeString: String {
        switch self {
        case .small:
            "소형견/묘"
        case .midium:
            "중형견/묘"
        case .large:
            "대형견/묘"
        case .baby:
            "아기"
        }
    }
}

let petTags: [String] = ["활발해요", "얌전해요", "말이 많아요", "예민해요", "사람 싫어요", "사람 좋아요", "애교 많아요", "산책 좋아", "겁이 많아요", "예방접종 완료", "중성화 완료"]
