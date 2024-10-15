//
//  PetProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct PetProfileView: View {
    var mateUser: MateUser
    @State private var profileImage: Image?
    @State private var isShowingEditPetProfile = false //편집 시트
    @State private var pet: Pet = Pet(name: "가디", description: "", age: 3, tag: [], breed: "포메", images: [], createdAt: .distantPast, updatedAt: .distantPast)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                (profileImage ?? Image("placeholder"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(pet.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text("\(pet.age)살")
                            .font(.system(size: 12))
                        Spacer()
                        
                        // 편집 버튼
                        Button(action: {
                            isShowingEditPetProfile = true
                        }) {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    Text("📍\(mateUser.location)에 사는 \(pet.breed)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                }
            }
            .sheet(isPresented: $isShowingEditPetProfile) {
                PetProfileEditView() 
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("나의 성격")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                // 설명글
                Text(pet.description.isEmpty ? "저를 표현해주세요!" : pet.description)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                //TODO: 태그(파베: tag: [String]) 띄우기
                HStack {
                    ForEach(["활발해요", "사람좋아!", "우사인볼트"], id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top, 4)
        }
        .padding()
        .background( // 바깥 네모 테두리
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
                .frame(width: 365, height: 350)
        )
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// 태그
struct TagView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(.systemGray6))
            .foregroundStyle(Color(UIColor.systemBrown))
            .cornerRadius(12)
    }
}

struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = MateUser(name: "김정원", image: "", matchCount: 5, location: "구월3동", createdAt: Date())
        PetProfileView(mateUser: user)
    }
}
