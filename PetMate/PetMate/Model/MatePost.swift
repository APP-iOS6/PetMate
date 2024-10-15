//
//  MatePost.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct MatePost: Codable {
    @DocumentID var id: String?         //문서Id
    var writeUser: DocumentReference    //작성자 레퍼런스
    var pet: DocumentReference         //펫 레퍼런스
    var startDate: Date //시작날짜
    var endDate: Date   //종료날짜
    var cost: Int   //비용
    var content: String //내용
    var location: String    //지역("도봉구, 내손동 이런식으로 받을거임)
    var reservationUser: DocumentReference? //예약 확정자 레퍼런스
    var postState: String   //글 예약 상태
    var createdAt: Date   //생성일
    var updatedAt: Date   //업데이트 일
}
