//
//  TagModifier.swift
//  PetMate
//
//  Created by 김동경 on 10/20/24.
//

import SwiftUI

struct TagModifier: ViewModifier {
    
    let selected: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .bold))
            .frame(width: 70, height: 30)
            .background(selected ? Color.petTag : Color(uiColor: .systemGray6))
            .foregroundColor(selected ? .white : .petTag)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(uiColor: .systemGray4), lineWidth: selected ? 0 : 1)
            )
    }
}

extension View {
    func tagStyle(selected: Bool) -> some View {
        self.modifier(TagModifier(selected: selected))
    }
}

