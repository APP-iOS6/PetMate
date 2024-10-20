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
            .bold()
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical)
            .background(selected ? .petTag : Color(uiColor: .systemGray6))
            .foregroundStyle(selected ? .white : .petTag)
            .clipShape(.rect(cornerRadius: 32))
    }
}

