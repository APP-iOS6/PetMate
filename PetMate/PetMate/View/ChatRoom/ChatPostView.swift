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
    let acion: (comfirmType) -> Void
    
    init(
        post: MatePost,
        otherUser: MateUser,
        acion: @escaping (comfirmType) -> Void = {_ in }
    ) {
        self.post = post
        self.otherUser = otherUser
        self.acion = acion
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: post.firstPet.images.first ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                case .failure(_):
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(width: 80, height: 80)
                @unknown default:
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(width: 80, height: 80)
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
                if post.reservationUser != nil {
                    if post.reservationUser?.documentID != otherUser.id {
                        Text("매칭 성사")
                            .modifier(ApplyingModifier())
                    } else {
                        Text("완료된 매칭")
                            .modifier(ApplyingModifier())
                    }
                } else {
                    Text("신청중")
                        .modifier(ApplyingModifier())
                }
            } else {
                if post.reservationUser != nil {
                    if post.reservationUser?.documentID == otherUser.id {
                        Button {
                            acion(.review)
                        } label: {
                            Text("후기 보내기")
                                .modifier(ComfirmMateModifier())
                        }
                    } else {
                        Text("완료된 매칭")
                            .modifier(ComfirmMateModifier())
                    }
                } else {
                    Button {
                        acion(.comfirm)
                    } label: {
                        Text("메이트 확정하기 ✅")
                            .modifier(ComfirmMateModifier())
                    }
                }
            }
        }
    }
}

enum comfirmType {
    case comfirm
    case review
}


