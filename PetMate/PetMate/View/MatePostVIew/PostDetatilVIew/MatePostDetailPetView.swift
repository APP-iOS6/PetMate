//
//  MatePostDetailPetView.swift
//  PetMate
//
//  Created by 권희철 on 10/20/24.
//

import SwiftUI

struct MatePostDetailPetView: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: pet.images.first ?? "")){image in
                    image.image?.resizable()
                        .frame(height: 180)
                        .scaledToFit()
                        .clipShape(.circle)
                }
                VStack(alignment: .leading){
                    HStack{
                        Text(pet.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("\(pet.age)살")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                    Text(pet.breed)
                        .font(.caption)
                }
            }
            FlowLayout {
                ForEach(pet.tag, id: \.self) { tag in
                    TagToggle(tag: tag, isSelected: true){}
                }
            }
            
            VStack(alignment: .leading){
                Text("나의 성격")
                ZStack(alignment: .topLeading){
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 0.8)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    Text(pet.description)
                        .padding()
                    
                }
            }
        }
    }
}

#Preview {
    MatePostDetailPetView(pet:
                            Pet(
                                name: "가디",
                                description: "눈웃음이 매력적입니다 귀여워요 애교가 많아요",
                                age: 3,
                                tag: ["활발해요", "예방 접종 완료", "중성화 완료", "겁이 많아요", "애교 많아요"],
                                breed: "포메",
                                images: ["https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/4arX/image/yOxTvIj1eobuuV_A4OC0eu1aRAI.jpg"],
                                ownerUid: "정원",
                                category1: "dog",
                                category2: "small",
                                createdAt: .now,
                                updatedAt: .now))
}
