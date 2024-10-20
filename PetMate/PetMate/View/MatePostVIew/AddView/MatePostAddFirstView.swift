//
//  MatePostAddFirstView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddFirstView: View {
    @Environment(MatePostStore.self) var postStore
    var category = ["산책, 돌봄"]
    var body: some View {
        @Bindable var postStore = postStore
        
        VStack(spacing: 50){
            VStack(alignment: .leading){
                Text("메이트에게 무엇을 부탁하실 건가요?")
                    .font(.title2)
                Picker("메이트에게 무엇을 부탁하실 건가요?", selection: $postStore.category) {
                    Text("산책").tag("walk")
                    Text("돌봄").tag("care")
                }.pickerStyle(.segmented)
                
            }
            VStack(alignment: .leading){
                Text("동네 선택")
                    .font(.title2)
                TextField("동", text: $postStore.location)
                    .padding()
                    .overlay(Capsule(style: .circular)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondary))
            }
            
            VStack(alignment: .leading){
                Text("기간")
                    .font(.title2)
                DatePicker("시작일:", selection: $postStore.startDate)
                DatePicker("종료일:", selection: $postStore.endDate)
            }
            
            VStack(alignment: .leading){
                Text("의뢰비")
                    .font(.title2)
                TextField("₩", text: $postStore.cost)
                    .padding()
                    .overlay(Capsule(style: .circular)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondary))
            }
            
            Spacer()
            
        }.padding()
    }
}

#Preview {
    MatePostAddFirstView()
        .environment(MatePostStore())
}
