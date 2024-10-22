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
            HomeFindFriendCardDetailView(pet: pet)
                .presentationDetents([.fraction(0.5)])
        }
    }
}
