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

//캘린더 뷰컨트롤러 뷰
struct EventEditViewController: UIViewControllerRepresentable {
    //캘린더 뷰는 외부에서 호출하기 때문에 presentationMode의 dismiss를 통해 시트를 내려야 함
    @Environment(\.presentationMode) var presentationMode
    private let store = EKEventStore()
    let testEvent: TestEvent
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    //Delegate같은 VC의 대리자의 역할을 하기 위해 필요함
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    typealias UIViewControllerType = EKEventEditViewController
    //EKEventEditViewController를 반환함
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController =  EKEventEditViewController ()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
    //EKEventEditViewController를 띄웠을 때 폼의 값들을 미리 지정해줌
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

//테스트용 모델
struct TestEvent: Identifiable{
    var id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var description: String
    //이벤트 폼에서 날짜 시간을 지정하기 위해 Date타입을 쪼개주는 연산프로퍼티
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
//이벤트 폼에서 날짜 시간을 지정하기 위해 Date타입을 쪼개주는 연산프로퍼티
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
