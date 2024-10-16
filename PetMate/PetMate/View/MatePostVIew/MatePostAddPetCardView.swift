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
    @Binding var selectedPets: Set<Pet>
    
    var checkMark: String {
        selectedPets.contains(pet) ? "checkmark.square.fill" : "checkmark.square"
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
                    ForEach(pet.tag, id: \.self) { tag in
                        ZStack{
                            Capsule(style: .circular)
                                .frame(height: 30)
                                .frame(maxWidth: 100)
                                .foregroundStyle(.secondary)
                            Text(tag)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(width: proxy.size.width * 0.7)
        .border(.black)
        .onTapGesture {
            if !selectedPets.contains(pet){
                selectedPets.insert(pet)
            }else{
                selectedPets.remove(pet)
            }
        }
    }
}

//#Preview {
//    MatePostAddPetCardView()
//}
