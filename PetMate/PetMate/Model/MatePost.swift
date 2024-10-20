//
//  MatePost.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct MatePost: Codable, Identifiable {
    @DocumentID var id: String?         //문서Id
    var writeUser: DocumentReference    //작성자 레퍼런스
    var pet: [DocumentReference]         //펫 레퍼런스
    var title: String   //제목
    var category: String //카테고리 - 돌봄, 산책
    var startDate: Date //시작날짜
    var endDate: Date   //종료날짜
    var cost: Int   //비용
    var content: String //내용
    var location: String    //지역("도봉구, 내손동 이런식으로 받을거임)
    var reservationUser: DocumentReference? //예약 확정자 레퍼런스
    var postState: String   //글 예약 상태
    var firstPet: Pet //해당 글의 대표 펫d
    var createdAt: Date   //생성일
    var updatedAt: Date   //업데이트 일
    
//    enum MatePostCategory: String, Codable{
//        case care = "care"
//        case walk = "walk"
//    }
    
    // MARK: - 캘린더에 날짜와 시간을 넣기 위해 Date값을 단위별로 나눠서 튜플로 반환하는 연산프로퍼티
    var startDateElements: (year: Int, month: Int, day: Int, hour: Int, minute: Int)? {
        let components = startDate.get(.day, .month, .year, .hour, .minute)
        if let year = components.year,
           let day = components.day,
           let month = components.month,
           let hour = components.hour,
           let minute = components.minute {
            return (year, month, day, hour, minute)
        }
        return nil
    }
    var endDateElements: (year: Int, month: Int, day: Int, hour: Int, minute: Int)? {
        let components = endDate.get(.day, .month, .year, .hour, .minute)
        if let year = components.year,
           let day = components.day,
           let month = components.month,
           let hour = components.hour,
           let minute = components.minute {
            return (year, month, day, hour, minute)
        }
        return nil
    }
}
