//
//  MatePostAddSecondView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostAddSecondView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var postStore: MatePostStore
    
    @State var isPresent: Bool = false
    @State var selectedPets: Set<Pet> = []
    
    let contentFieldText =
        """
        게시글 내용을 작성해주세요
        내 아이의 행복한 시간을 위해서 메이트에게 전당하고 싶은 여러 사항들을 자세하게 적어주세요
        """
    var body: some View {
        VStack(spacing: 50){
            if selectedPets.isEmpty{
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray)
                        .frame(width: 300, height: 150)
                        .opacity(0.3)
                    HStack{
                        Text("내 펫 불러오기")
                        Image(systemName: "plus.circle")
                    }.font(.largeTitle)
                }.onTapGesture {
                    isPresent.toggle()
                }
            }else{
                GeometryReader{ proxy in
                    VStack{
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(Array(selectedPets)){ pet in
                                    MatePostAddPetCardView(pet: pet, proxy: proxy, selectedPets: $selectedPets)
                                }
                            }
                        }.scrollIndicators(.hidden)
                        Button{isPresent.toggle()}label: {
                            Text("추가")
                        }
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("제목")
                    .font(.title2)
                TextField("30자 이내로 작성해주세요", text: $postStore.title)
                Rectangle()
                    .frame(height: 1)
            }
            VStack(alignment: .leading){
                Text("내용")
                    .font(.title2)
                ScrollView(.vertical) {
                    TextField(contentFieldText, text: $postStore.content)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.border(.black)
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isPresent, onDismiss: {postStore.reset()}) {
            MatePostAddPetsView(selectedPets: $selectedPets)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    @Previewable @State var postStore = MatePostStore()
    MatePostAddSecondView(postStore: $postStore)
}
