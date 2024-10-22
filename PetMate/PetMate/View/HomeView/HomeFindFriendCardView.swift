//
//  HomeFindFriendCard.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeFindFriendCardView: View {
   let pet: Pet
   @State private var showingDetail = false
   @Bindable var viewModel: HomeViewViewModel
   
   var body: some View {
       VStack {
           AsyncImage(url: URL(string: pet.images.first ?? "")) { phase in
               switch phase {
               case .empty, .failure:
                   Image(systemName: "pawprint.circle.fill")
                       .resizable()
                       .scaledToFit()
                       .foregroundColor(Color.petTag)
               case .success(let image):
                   image
                       .resizable()
                       .scaledToFill()
               @unknown default:
                   EmptyView()
               }
           }
           .frame(width: 80, height: 80)
           .clipShape(Circle())
           .padding(.top, 10)
           
           Divider()
               .frame(width: 80)
               .background(Color.gray)
           
           Text(pet.name)
               .font(.system(size: 14, weight: .bold))
               .lineLimit(1)
               .padding(.bottom, 10)
       }
       .frame(width: 100, height: 130)
       .background(Color.white)
       .clipShape(RoundedRectangle(cornerRadius: 12))
       .shadow(color: Color.gray.opacity(1), radius: 0.5, x: 0, y: 0)
       .padding(.vertical, 5)
       .onTapGesture {
           showingDetail = true
       }
       .sheet(isPresented: $showingDetail) {
           NavigationStack {
               HomeFindFriendCardDetailView(pet: pet, viewModel: viewModel)
           }
       }
   }
}

// Preview
#Preview {
   HomeFindFriendCardDetailView(
       pet: Pet(
           id: "1",
           name: "갱얼쥐",
           description: "귀여운강아쥐",
           age: 3,
           category1: "dog",
           category2: "small",
           tag: ["활발해요", "산책 좋아요"],
           breed: "비글",
           images: ["https://example.com/dog.jpg"],
           ownerUid: "owner123",
           createdAt: Date(),
           updatedAt: Date(),
           location: "강남구 개포1동"
       ),
       viewModel: HomeViewViewModel()
   )
}
