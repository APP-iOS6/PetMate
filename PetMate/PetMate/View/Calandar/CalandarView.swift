//
//  CalandarView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI
//import EventKit
import EventKitUI

struct CalandarView: View {
    let testEvent = TestEvent(name: "테스트 이름", startDate: .now, endDate: .init(timeIntervalSinceNow: 600000), description: "설명설명설명")
    
    @State private var isPresent: Bool = false
    
    var body: some View {
        Button("캘린더 테스트"){
            isPresent.toggle()
        }.sheet(isPresented: $isPresent) {
            EventEditViewController(testEvent: testEvent)
        }
    }
}

struct EventEditViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController =  EKEventEditViewController ()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
    private let store = EKEventStore()
    
    let testEvent: TestEvent
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = testEvent.name
        if let startDate = testEvent.startDateElements, let endDate = testEvent.endDateElements {
            let startDateComponents = DateComponents(year: startDate.year,
                                                     month: startDate.month,
                                                     day: startDate.day,
                                                     hour: startDate.hour,
                                                     minute: startDate.minute)
            event.startDate = Calendar.current.date(from: startDateComponents)!
            let endDateComponents = DateComponents(year: endDate.year,
                                                   month: endDate.month,
                                                   day: endDate.day,
                                                   hour: endDate.hour,
                                                   minute: endDate.minute)
            event.endDate = Calendar.current.date(from: endDateComponents)!
            event.notes = testEvent.description
        }
        return event
    }
}


struct TestEvent: Identifiable{
    var id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var description: String
    
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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}


#Preview {
    CalandarView()
}
