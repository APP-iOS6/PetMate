//
//  CalandarView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI
import EventKitUI

//캘린더 뷰컨트롤러 뷰
struct CalendarEditView: UIViewControllerRepresentable {
    //캘린더 뷰는 외부에서 호출하기 때문에 presentationMode의 dismiss를 통해 시트를 내려야 함
    @Environment(\.presentationMode) var presentationMode
    private let store = EKEventStore()
    let post: MatePost?
    let title: String
    var calendarStore: CalendarStore
    
    typealias UIViewControllerType = EKEventEditViewController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    //Delegate같은 VC의 대리자의 역할을 하기 위해 필요함
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: CalendarEditView
        
        init(_ controller: CalendarEditView) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            if action == .saved {
                Task {
                    await parent.calendarStore.reqeustAccess() // 이벤트 추가 후 데이터를 다시 불러옵니다.
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    //EKEventEditViewController를 반환함
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController =  EKEventEditViewController ()
        eventEditViewController.event = event
        eventEditViewController.event?.title = "[펫메이트]\(title)"
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    //EKEventEditViewController를 띄웠을 때 폼의 값들을 미리 지정해줌
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        if let post{
            if let startDate = post.startDateElements, let endDate = post.endDateElements {
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
                event.notes = post.content
            }
            return event
        }
        else{
            return event
        }
    }
}

