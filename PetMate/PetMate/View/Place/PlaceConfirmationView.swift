//
//  PlaceConfirmationView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceConfirmationView: View {
    let store: Document
    @Environment(PetPlacesStore.self) private var placeStore
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 16) {
            Text("반려동물 동반 가능한 곳이 맞나요 ?")
                .font(.headline)
                .padding(.top, 16)
            
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Text("📍 \(store.place_name)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("\(store.address_name)", systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let phone = store.phone {
                        Label(phone, systemImage: "phone.fill")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Label(store.category_name, systemImage: "tag.fill")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.all, 16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            
            // 맞아요 버튼
            Button(action: {
                //                placeStore.addPlace(
                //                    writeUser: UUID().uuidString,
                //                    title: store.place_name,
                //                    content: "",
                //                    address: store.road_address_name,
                //                    placeName: store.place_name,
                //                    isParking: true,
                //                    latitude: Double(store.y)!,
                //                    longitude: Double(store.x)!,
                //                    geoHash: ""
                placeStore.searchState = .addPlace
            }){
                Text("맞아요")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 16)
            
            // 아니요 버튼
            Button(action: {
                placeStore.searchState = .searchPlace
            }) {
                Text("아니요. 다시 선택할래요")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown.opacity(0.2))
                    .foregroundColor(.brown)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding()
    }
}

//#Preview {
//    PlaceConfirmationView()
//}
