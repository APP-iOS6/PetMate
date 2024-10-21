//
//  SubmitPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI

struct SubmitPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PetPlacesStore.self) private var placeStore
    var body: some View {
        VStack {
            Text("저장")
            Spacer()
        }
    }
}

#Preview {
    SubmitPlaceView()
}
