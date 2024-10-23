//
//  CalandarReadTestView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/23/24.
//

import SwiftUI
import EventKit

struct CalendarListView: View {
    @Environment(\.dismiss) var dismiss
    let store = EKEventStore()
    let calendarStore = CalendarStore()
    @State private var isPresent: Bool = false
    
    // 날짜 포맷
    private let koreanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy년 MM월 dd일 (E) HH:mm"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                // 캘린더 이벤트가 nil이거나 빈 경우에 대한 처리
                if let events = calendarStore.events, !events.isEmpty {
                    List {
                        ForEach(events, id: \.eventIdentifier) { event in
                            VStack(spacing: 12) {
                                Text(event.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color("petTag_Color"))
                                        .frame(width: 3, height: 40)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(koreanDateFormatter.string(from: event.startDate))
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("~ \(koreanDateFormatter.string(from: event.endDate))")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                                
                                if let note = event.notes {
                                    Text(note)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                        .padding(.top, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .gray.opacity(0.5), radius: 1, x: 0, y: 1)
                            )
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // 일정이 없을 때 표시할 뷰
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("등록된 일정이 없습니다.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                await calendarStore.reqeustAccess()
            }
            .sheet(isPresented: $isPresent) {
                CalendarEditView(post: nil, title: "", calendarStore: calendarStore)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("일정 목록")
                        .font(.system(size: 16, weight: .bold))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresent.toggle()
                    }label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        CalendarListView()
    }
}
