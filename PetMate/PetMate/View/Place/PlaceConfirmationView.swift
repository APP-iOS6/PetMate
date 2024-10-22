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
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .center ,spacing: 16) {
                    Spacer()
                    Text("반려동물 동반 가능한 곳이 맞나요 ?")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            Text("📍 \(store.place_name)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                            Spacer()
                        }
                        .padding(.top)
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "map.fill")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Text("\(store.address_name)")
                                }
                                
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("\(store.category_name)")
                                }
                                
                                if let phone = store.phone {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                        Text("\(phone)")
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.info)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                    
                    Button(action: {
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
                    Spacer()
                }
                .frame(width: proxy.size.width * 0.84)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    PlaceConfirmationView(store: Document(place_name: "카카오프렌즈 코엑스점", distance: "", place_url: "", category_name: "음식점 > 카페", address_name: "경기도 수원시 매탄동 393", road_address_name: "", x: "", y: "", phone: "010-1234-5678", category_group_code: "", category_group_name: ""))
        .environment(PetPlacesStore())
}
