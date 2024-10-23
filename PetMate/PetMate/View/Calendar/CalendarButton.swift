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
                .frame(width: 42, height: 53)
        }
        .fullScreenCover(isPresented: $isPresent) {
            CalendarListView()
        }
    }
}

#Preview {
    CalendarButton()
}
