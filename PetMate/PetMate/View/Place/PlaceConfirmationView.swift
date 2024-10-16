//
//  PlaceConfirmationView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceConfirmationView: View {
    let document: Document
    @State private var placeStore: PetPlacesStore = .init()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 16) {
            Text("찾으시는 장소가 맞나요?")
                .font(.headline)
                .padding(.top, 16)
            
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Text("📍 \(document.place_name)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("\(document.address_name)", systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let phone = document.phone {
                        Label(phone, systemImage: "phone.fill")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Label(document.category_name, systemImage: "tag.fill")
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
                placeStore.addPlace(
                    writeUser: UUID().uuidString,
                    title: document.place_name,
                    content: "",
                    address: document.road_address_name,
                    placeName: document.place_name,
                    isParking: true,
                    latitude: Double(document.y)!,
                    longitude: Double(document.x)!,
                    geoHash: ""
                ) { success in
                    if success {
                        dismiss()
                        print("장소가 성공적으로 추가되었습니다.")
                    } else {
                        print("장소 추가에 실패했습니다.")
                    }
                }
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
                dismiss()
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
