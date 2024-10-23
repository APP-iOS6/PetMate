//
//  CalandarReadTestView.swift
//  PetMate
//
//  Created by 권희철 on 10/22/24.
//

import SwiftUI
import EventKit

struct CalendarListView:View {
    @Environment(\.dismiss) var dismiss
    let store = EKEventStore()
    let calendarStore = CalendarStore()
    @State private var isPresent: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if let events = calendarStore.events{
                    List{
                        ForEach(events, id: \.self){ event in
                            VStack{
                                Text("제목: \(event.title)")
                                Text("시간: \(dateFormatter.string(from : event.startDate)) ~ \(dateFormatter.string(from: event.endDate))")
                                if let note = event.notes{
                                    Text("내용: \(note)")
                                }
                            }
                        }
                    }
                }else{
                    Text("이벤트를 못불러옴 ㅅㄱ")
                }
            }.task {
                await calendarStore.reqeustAccess()
            }
            .sheet(isPresented: $isPresent) {
                CalendarEditView(post: nil, title: "")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("뒤로"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        isPresent.toggle()
                    }label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            
        }
    }
}



#Preview{
    NavigationStack{
        CalendarListView()
    }
}
