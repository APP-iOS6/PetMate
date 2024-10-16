//
//  MatePostAddFirstView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddFirstView: View {
    @Binding var location: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var cost: String
    var body: some View {
        VStack(spacing: 50){
            VStack(alignment: .leading){
                Text("동네 선택")
                    .font(.title2)
                TextField("동", text: $location)
                    .padding()
                    .overlay(Capsule(style: .circular)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondary))
            }
            
            VStack(alignment: .leading){
                Text("기간")
                    .font(.title2)
                DatePicker("시작일:", selection: $startDate)
                DatePicker("종료일:", selection: $endDate)
            }
            
            VStack(alignment: .leading){
                Text("의뢰비")
                    .font(.title2)
                TextField("₩", text: $cost)
                    .padding()
                    .overlay(Capsule(style: .circular)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondary))
            }
            
            Spacer()
            
        }.padding()
    }
}

//#Preview {
//    MatePostAddFirstView()
//}
