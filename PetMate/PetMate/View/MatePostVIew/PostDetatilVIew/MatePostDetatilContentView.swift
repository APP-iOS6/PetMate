//
//  MatePostDetatilContentView.swift
//  PetMate
//
//  Created by 권희철 on 10/20/24.
//

import SwiftUI
import FirebaseFirestore

struct MatePostDetatilContentView: View {
    let post: MatePost
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text(post.title)
                .font(.title3)
                .fontWeight(.bold)
            Text(post.content)
                .font(.headline)
            HStack(alignment: .bottom){
                VStack(alignment: .leading, spacing: 20){
                    VStack(alignment: .leading){
                        Text("기간")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Text("\(post.startDate, formatter: dateFormatter) ~")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("\(post.endDate, formatter: dateFormatter)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    VStack(alignment: .leading){
                        Text("메이트 비용")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Text("\(post.cost)~")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                Spacer()
                VStack{
                    Spacer()
                    ZStack{
                        Circle()
                            .stroke(lineWidth: 0.3)
                            .frame(width: 100)
                        Text(post.category == "care" ? "돌봄" : "산책")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.brown)
                    }
                }
            }
        }
        .frame(maxHeight: 400)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.3)
                .foregroundStyle(.secondary)
        }
    }
    
}

#Preview {
    let db = Firestore.firestore()
    MatePostDetatilContentView(post:
                                MatePost(
                                    writeUser: db.collection("User").document("희철"),
                                    pet: [db.collection("Pet").document("QbZPrPlY6HkbOsT87gpQ")],
                                    title: "딱 한 시간만 신나게 부탁드려요!",
                                    category: "care",
                                    startDate: .now,
                                    endDate: Date(timeIntervalSinceNow: 60000),
                                    cost: 20000,
                                    content: """
안녕하세요~
제가 오늘 일정이 너무 바빠서 가솜이 산책을 못 시킬 것 같아서요 ㅠㅠ 딱 1시간만 시원하게 놀아주실 분을 찾습니다... 사람을 좋아하고 활발해서 큰 어려움은 없으실 거에요! 체력이 좋아서 쉽게 지치지 않는 분이 필요합니다 ㅎㅎ 편하게 신청해 주세요!!!
""",
                                    location: "강동구",
                                    postState: "reservated",
                                    firstPet: Pet(name: "애옹", description: "애옹 설명", age: 2, category1: "cat", category2: "small", tag: ["귀여움"], breed: "봄베이고양이", images: ["https://d3544la1u8djza.cloudfront.net/APHI/Blog/2020/10-22/What+Is+a+Bombay+Cat+_+Get+to+Know+This+Stunning+Breed+_+ASPCA+Pet+Health+Insurance+_+close-up+of+a+Bombay+cat+with+gold+eyes-min.jpg"],
                                                  ownerUid: "희철",
                                                  createdAt: .now,
                                                  updatedAt: .now),
                                    createdAt: .now,
                                    updatedAt: .now))
}

