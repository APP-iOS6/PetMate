//
//  CalandarStore.swift
//  PetMate
//
//  Created by 권희철 on 10/23/24.
//

import Foundation
import Observation
import EventKit

@Observable
class CalendarStore{
    let store = EKEventStore()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var events: [EKEvent]?
    
    func fetchEvents() -> [EKEvent]?{
        let calendar = Calendar.current
        
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)

        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.year = 1
        let oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)
        
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }
        
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate).filter{$0.title.contains("펫메이트")}
        }
        
        return events
    }
    
    func reqeustAccess() async{
        do{
            let access = try await store.requestFullAccessToEvents()
            if access{
                events = fetchEvents()
            }
            print("access: \(access)")
        }catch{
            print(error)
        }
    }
}
