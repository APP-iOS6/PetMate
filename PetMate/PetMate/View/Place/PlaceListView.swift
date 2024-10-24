//
//  StoreListView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceListView: View {
    @Environment(PetPlacesStore.self) private var placeStore
    var body: some View {
        ScrollView {
            ForEach(placeStore.places) { place in
                NavigationLink(destination: StoreDetailView(placePost: place)) {
                    
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: place.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("📍\(place.placeName)")
                                .font(.headline)
                                .lineLimit(1)
                                .fontWeight(.bold)
                                .padding(.vertical,3)
                            
                            Text(place.address.extractDistrictAndNeighborhood())
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundColor(.gray)
                                .padding(.vertical, 3)
                            
                            Text("반려동물 동반")
                                .font(.caption)
                                .bold()
                                .foregroundColor(Color("petTag_Color"))
                                .padding(6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 4)
                    )
                    .padding()
                    .padding(.vertical, -5)
                    
                }
            }
            
        }
        .onAppear {
            placeStore.fetchPlaces()
        }
    }
}

#Preview {
    NavigationStack {
        PlaceListView()
    }
}
