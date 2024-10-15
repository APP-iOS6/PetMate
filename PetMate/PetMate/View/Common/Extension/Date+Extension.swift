//
//  Date+Extension.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation

extension Date {
    // 시간 차이를 기준으로 "방금", "n분 전", "오늘", "M월 d일 E요일" 형식으로 반환하는 extension
        var formattedTimeAgo: String {
            let now = Date()
            let calendar = Calendar.current

            let components = calendar.dateComponents([.minute, .hour, .day], from: self, to: now)

            if let day = components.day, day > 0 {
                if day == 1 {
                    return "어제"
                } else {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    formatter.dateFormat = "M월 d일 E요일"
                    return formatter.string(from: self)
                }
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)시간 전"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)분 전"
            } else {
                return "방금"
            }
        }
}
