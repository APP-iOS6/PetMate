//
//  Review.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct Review: Codable {
    @DocumentID var id: String? //문서 id
    var post: DocumentReference //어떤 글에 대한 리뷰인지 확인하기 위한 포스트 레퍼런스
    var bome: Int   //뼈따구 개수
    var content: String //리뷰 내용
    var createdAt: Date //리뷰 생성일
}
