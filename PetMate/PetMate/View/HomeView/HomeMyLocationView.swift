//
//  HomeMyLocationView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeMyLocationView: View {
    var body: some View {
        HStack{
            Image(systemName: "mappin")
            Text("영동구 매탄동")
        }
    }
}

#Preview {
    HomeMyLocationView()
}
