//
//  PetMapView.swift
//  PetMate
//
//  Created by 김정원 on 10/15/24.
//

import SwiftUI
import KakaoMapsSDK

struct PetMapView: View {
    @State var draw: Bool = true

    var body: some View {
        KakaoMapView(draw: $draw).onAppear(perform: {
            self.draw = true
        }).onDisappear(perform: {
            self.draw = false
        }).frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PetMapView()
}
