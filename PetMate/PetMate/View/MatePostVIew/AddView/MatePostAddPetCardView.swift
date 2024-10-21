//
//  MatePostAddPetCardView.swift
//  PetMate
//
//  Created by 권희철 on 10/17/24.
//

import SwiftUI

struct MatePostAddPetCardView: View {
    let pet: Pet
    var proxy: GeometryProxy
    @Environment(MatePostStore.self) var postStore: MatePostStore
    
    var checkMark: String {
        postStore.selectedPets.contains(pet) ? "checkmark.square.fill" : "checkmark.square"
    }
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    AsyncImage(url: URL(string: pet.images.first!)){ image in
                        image.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(.circle)
                            .frame(width: 50, height: 50)
                    }
                    VStack{
                        HStack{
                            Text(pet.name)
                            Text("\(pet.age)살")
                                .font(.caption)
                        }
                        Text(pet.breed)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: checkMark)
                        .font(.title)
                }
                Text("나의 성격")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(pet.description)
                    .font(.caption)
                HStack{
                    FlowLayout {
                        ForEach(pet.tag, id: \.self) { tag in
                            TagToggle(tag: tag, isSelected: true){}
                        }
                    }

                }
            }
            .padding()
        }
        .frame(width: proxy.size.width * 0.7)
        .frame(minHeight: 200)
        .border(.black)
        .onTapGesture {
            if !postStore.selectedPets.contains(pet){
                postStore.selectedPets.insert(pet)
            }else{
                postStore.selectedPets.remove(pet)
            }
        }
    }
}

//#Preview {
//    MatePostAddPetCardView()
//}
