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
    @Environment(MatePostStore.self) var postStore
    var body: some View {
        @Bindable var postStore = postStore
        
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
                            MatePostAddPetCardView(pet: pet, proxy: proxy)
                                
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
    //@Previewable @State var store = MatePostStore()
    MatePostAddPetsView()
        .environment(MatePostStore())
}
