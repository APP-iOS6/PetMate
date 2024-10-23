//
//  CalendarButton.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/22/24.
//

import SwiftUI

struct CalendarButton: View {
    @State private var isPresent: Bool = false
    
    var body: some View {
        Button(action: {
            isPresent.toggle()
        }) {
            Image("CalendarButton")
                .resizable()
                .frame(width: 60, height: 76)
        }
        .sheet(isPresented: $isPresent) {
            //CalandarView(post: nil, title: "일정 추가")
            CalandarReadTestView()
        }
    }
}

#Preview {
    CalendarButton()
}
