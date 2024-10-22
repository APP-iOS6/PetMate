//
//  ChatPostView.swift
//  PetMate
//
//  Created by 김동경 on 10/22/24.
//

import SwiftUI

struct ChatPostView: View {
    
    let post: MatePost
    let otherUser: MateUser
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: post.firstPet.images.first ?? "")) { phase in
                switch phase {
                case .empty:
                    Image(.dog)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                case .failure(_):
                    Image(.dog)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                @unknown default:
                    Image(.dog)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .bold()
                HStack {
                    Text(post.firstPet.name)
                        .bold()
                    Text(post.firstPet.breed)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
               
                Text(post.startDate.formattedDate + "~" + post.endDate.formattedDate)
                    .font(.caption)
                
                Text("산책 비용: \(post.cost)")
                    .font(.caption)
                
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .overlay(alignment: .bottomTrailing) {
            if post.writeUser.documentID == otherUser.id {
                Text("확정하기")
            } else {
                Text("신청중")
            }
        }
    }
}


