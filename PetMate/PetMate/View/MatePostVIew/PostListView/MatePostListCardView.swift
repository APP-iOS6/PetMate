//
//  MatePostListCardView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI
import FirebaseFirestore

struct MatePostListCardView: View {
    var post: MatePost
    var proxy: GeometryProxy
    let dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            AsyncImage(url: URL(string: post.firstPet.images.first ?? "")){ image in
                image
                    .resizable()
                    .frame(height: proxy.size.height * 0.45)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: proxy.size.width * 0.4)
            }placeholder:{
                ProgressView()
            }
            ZStack(alignment: .topLeading){
                RoundedRectangle(cornerRadius: 12)
                    .opacity(0.4)
                VStack(alignment: .leading){
                    HStack(alignment: .bottom){
                        Text("\(post.firstPet.category1 == "dog" ? "🐶" : post.firstPet.category1 == "cat" ?"🐱" : "🦄") \(post.firstPet.name)")
                            .font(.none)
                        Text(post.firstPet.breed)
                            .font(.caption)
                    }
                    .fontWeight(.bold)
                    Text("\(dateFormatter1.string(from: post.startDate)) ~ \(dateFormatter1.string(from: post.endDate))")
                    Text("\(post.category == "care" ? "돌봄" : "산책") 비용 : \(post.cost)")
                }
                .font(.caption)
                .padding()
                .foregroundStyle(.white)
            }
            .frame(height: proxy.size.height * 0.2)
            .padding(10)
            
            
        }
        .clipShape(.rect(cornerRadius: 12))
        .frame(width: proxy.size.width * 0.45, height: proxy.size.height * 0.4)
        .padding()
        
    }
}

#Preview {
    let db = Firestore.firestore()
    GeometryReader{ proxy in
        MatePostListCardView(post: MatePost(
            writeUser: db.collection("User").document("희철"),
            pet: [],
            title: "제목",
            category: "walk",
            startDate: .now,
            endDate: Date(timeIntervalSinceNow: 60000),
            cost: 20000,
            content: "애옹",
            location: "강동구 천호동",
            postState: "finding",
            firstPet: Pet(name: "애옹", description: "설명", age: 3, category1: "dog", category2: "small", tag: ["활발해요", "예방 접종 완료", "중성화 완료"], breed: "포메", images: ["https://i.namu.wiki/i/u6RY6Cwfgl5LU3zbiqxbOzmRfe2IEeICXexXNykfzxwnhMwIvV8KddLNkUxyNyDQzBwtvD9swGszVOXM_A0UFw.webp"], ownerUid: "희철", createdAt: .now, updatedAt: .now),
            createdAt: .now,
            updatedAt: .now)
                             , proxy: proxy)
    }
}
