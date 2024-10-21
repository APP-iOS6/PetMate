//
//  PetMateProgressView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI

struct PetMateProgressView: View {
    var val: Double
    
    var body: some View {
        ProgressView(value: val, total: 1.0)
            .tint(Color.accentColor)
            .progressViewStyle(.linear)
            .padding(.bottom, 24)
            .animation(.easeInOut(duration: 0.1), value: val)
    }
}

#Preview {
    PetMateProgressView(val: 0.3)
}
