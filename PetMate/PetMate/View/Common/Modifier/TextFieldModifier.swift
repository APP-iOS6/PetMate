//
//  TextFieldModifier.swift
//  PetMate
//
//  Created by 김동경 on 10/16/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(4)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.loginText, lineWidth: 1)
                    .foregroundStyle(.clear)
                
            }
    }
}
