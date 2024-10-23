//
//  CalandarReadTestView.swift
//  PetMate
//
//  Created by 권희철 on 10/22/24.
//

import SwiftUI
import EventKit

struct CalandarReadTestView:View {
    let store = EKEventStore()

    @State var events : [EKEvent]?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack{
            Text("뷰는 있음..")
            if let events{
                List{
                    ForEach(events, id: \.self){ event in
                        VStack{
                            Text("제목: \(event.title)")
                            Text("시간: \(dateFormatter.string(from : event.startDate)) ~ \(dateFormatter.string(from: event.endDate))")
                            Text("내용: \(String(describing: event.notes))")
                        }
                    }
                }
            }else{
                Text("이벤트를 못불러옴 ㅅㄱ")
            }
        }.task {
            await requestAccess()
            //print(events)
        }
    }
    
    func testCalandar() -> [EKEvent]?{
        
        let calendar = Calendar.current
        
        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)
        
        
        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.year = 1
        let oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)
        
        
        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }
        
        
        // Fetch all events that match the predicate.
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate).filter{$0.title.contains("펫메이트")}
        }
        
        return events
    }
    
    func requestAccess() async{
        do{
            let access = try await store.requestFullAccessToEvents()
            if access{
                events = testCalandar()
            }
            print("access: \(access)")
        }catch{
            print(error)
        }
        
    }
}



#Preview{
    CalandarReadTestView()
}
