//
//  ApplyingModifier.swift
//  PetMate
//
//  Created by 김동경 on 10/23/24.
//

import SwiftUI

struct ApplyingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .font(.body)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 8)
            .foregroundStyle(.petTag)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
            }
            .padding(.trailing, 24)
    }
}
