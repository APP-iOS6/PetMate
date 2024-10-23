//
//  SendReviewView.swift
//  PetMate
//
//  Created by 김동경 on 10/23/24.
//

import SwiftUI

struct SendReviewView: View {
    @Environment(\.dismiss) private var dismiss
    let otherUser: MateUser
    let post: MatePost
    
    var viewModel: SendReviewViewModel = SendReviewViewModel()
    @State private var rating: Int = 1
    @State private var review: String = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: otherUser.image)) { phase in
                    switch phase {
                    case let.success(image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    case .failure(_):
                        Image(.welcome)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading) {
                    if post.category == "walk" {
                        Text("산책")
                            .modifier(ReviewTextModifier())
                    } else {
                        Text("돌봄")
                            .modifier(ReviewTextModifier())
                    }
                    
                    Text("메이트에 대한 후기를 남겨주세요.")
                        .font(.system(size: 16))
                        .bold()
                    
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { index in
                            Button {
                                withAnimation {
                                    rating = index
                                }
                            } label: {
                                Image(index <= rating ? .etc : .emptyetc)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(index <= rating ? .yellow : .gray)
                                    
                            }
                        }
                        Spacer()
                    }
                }
            }
            TextEditor(text: $review)
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($focusedField, equals: .description)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
                .overlay(alignment: .topLeading) {
                    if review.isEmpty {
                        Text("다른 메이트들을 위해 후기를 자세하게 작성해 주세요!!")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .offset(x: 5, y: 12)
                    }
                }
            
            Button {
                Task {
                    await viewModel.uploadReview(otherUserId: otherUser.id ?? "", otherUserProfile: otherUser.image, postId: post.id ?? "", review: review, rating: rating)
                }
            } label: {
                Text("리뷰 남기기")
                    .bold()
                    .modifier(ButtonModifier())
            }
            .padding(.vertical)
            Spacer()
        }
        .onChange(of: viewModel.loadState, { old, new in
            if new == .complete {
                dismiss()
            }
        })
        .overlay {
            if viewModel.loadState == .loading {
                ProgressView()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .tint(Color(uiColor: .systemGray4))
                    .padding([.top, .trailing], 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

