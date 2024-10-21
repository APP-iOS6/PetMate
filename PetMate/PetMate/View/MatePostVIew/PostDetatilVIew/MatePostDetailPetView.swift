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
                    if let image = image.image{
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(.circle)
                    }else if (image.error != nil){
                        Image(systemName: "xmark")
                    }else{
                        ProgressView().progressViewStyle(.circular)
                    }
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
                        .stroke(lineWidth: 0.9)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    Text(pet.description)
                        .padding()
                }
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 0.8))
                .foregroundStyle(.secondary)
                .blur(radius: 1)
        }
    }
}

#Preview {
    MatePostDetailPetView(pet:
                            Pet(
                                name: "가디",
                                description: "눈웃음이 매력적입니다 귀여워요 애교가 많아요",
                                age: 3,
                                category1: "dog", category2: "small", tag: ["활발해요", "예방 접종 완료", "중성화 완료", "겁이 많아요", "애교 많아요"],
                                breed: "포메",
                                images: ["https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/4arX/image/yOxTvIj1eobuuV_A4OC0eu1aRAI.jpg"],
                                ownerUid: "정원",
                                createdAt: .now,
                                updatedAt: .now))
}
