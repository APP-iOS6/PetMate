//
//  MatePostAddPetsView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MatePostAddPetsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var postStore: MatePostStore
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                HStack{
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                    }
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20){
                        ForEach(postStore.pets) { pet in
                            MatePostAddPetCardView(pet: pet, proxy: proxy, postStore: $postStore)
                                
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .task {
            postStore.pets = await postStore.getMyPets()
            //print(pets)
        }
        .padding()
    }
    
}

#Preview {
    @Previewable @State var store = MatePostStore()
    MatePostAddPetsView(postStore: $store)
}
