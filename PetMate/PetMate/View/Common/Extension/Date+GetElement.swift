//
//  Date+GetElement.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

//이벤트 폼에서 날짜 시간을 지정하기 위해 Date타입을 쪼개주는 연산프로퍼티
import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
