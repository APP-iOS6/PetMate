//
//  MatePostAddFirstView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddFirstView: View {
    @Environment(MatePostStore.self) var postStore
    
    @State var isPresent: Bool = false
    @FocusState.Binding var focus: MatePostAddFocus?
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
                HStack {
                    Text(postStore.location.isEmpty ? "서울시 마포구" : postStore.location)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(postStore.location.isEmpty ? .secondary : .primary)
                    
                    Button {
                        isPresent.toggle()
                    } label: {
                        Text("검색")
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .foregroundStyle(Color.accentColor)
                            .overlay {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            }
                    }
                    
                }
                Divider()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 1)
            }
            .sheet(isPresented: $isPresent) {
                SearchAddressModal { district in
                    self.postStore.location = district
                }
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
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .cost)
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
//        .environment(MatePostStore())
//}
