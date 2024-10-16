//
//  Pet.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct Pet: Codable, Identifiable {
    @DocumentID var id: String? //문서 id
    var name: String    //이름
    var description: String //설명 및 주의사항
    var age: Int    //나이
    var tag: [String]   //태그들
    var breed: String   //품종 및 종류
    var images: [String]    //사진 주소들
    var ownerUid: String //주인uid
    var createdAt: Date //생성일
    var updatedAt: Date //업데이트 일
}
