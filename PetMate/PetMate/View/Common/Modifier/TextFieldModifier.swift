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

struct ReviewTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(.white)
            .background(.tag)
            .clipShape(RoundedRectangle(cornerRadius: 24))

    }
}
