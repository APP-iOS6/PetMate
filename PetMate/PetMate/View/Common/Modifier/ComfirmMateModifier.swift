//
//  ComfirmMateModifier.swift
//  PetMate
//
//  Created by 김동경 on 10/23/24.
//

import SwiftUI

struct ComfirmMateModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .bold()
            .foregroundStyle(.petTag)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
            }
            .padding(.trailing, 12)
    }
}
