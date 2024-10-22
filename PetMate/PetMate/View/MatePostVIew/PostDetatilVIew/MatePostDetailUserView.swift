//
//  MatePostDetailUserView.swift
//  PetMate
//
//  Created by 권희철 on 10/20/24.
//

import SwiftUI

struct MatePostDetailUserView: View {
    var writer: MateUser
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: writer.image)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle()) // 원형 이미지
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100) // 로딩 중 회색 원
            }
            .padding(.top, 15)
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    Text(writer.name)
                        .font(.title)
                    Text("📍\(writer.location)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                }
                Text("메이트 횟수: \(writer.matchCount)번")
                    .foregroundStyle(.pink)
                    .fontWeight(.light)
                    .font(.title3)
                Text("소개를 기다리고 있어요")
                    .foregroundStyle(.secondary)
                    .fontWeight(.bold)
                    .font(.title3)
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 0.8))
                .foregroundStyle(.secondary)
        }

    }
}

#Preview {
    MatePostDetailUserView(writer:
                            MateUser(
                                name: "덱정원",
                                image: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F08%2Fone-piece-luffys-anime-voice-actress-says-she-doesnt-read-the-manga-ft.jpg?w=960&cbr=1&q=90&fit=max",
                                matchCount: 5,
                                location: "구월 3동",
                                createdAt: .now))
}
