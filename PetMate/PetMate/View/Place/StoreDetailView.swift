//
//  StoreDetailView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI
import FirebaseFirestore

// 스토어 상세 뷰
struct StoreDetailView: View {
    var placePost: PlacePost
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // place 이미지
                VStack(alignment: .center) {
                    AsyncImage(url: URL(string: placePost.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 200)
                    }
                }.padding()
                
                // place Info & 반려동물동반 태그
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("📍\(placePost.placeName)")
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 8)
                            .lineLimit(1)
                            .padding(.leading, -3)
                        
                        Spacer()
                        
                        Text("반려동물 동반")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color("petTag_Color"))
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 12) {
                            Image(systemName: "map.fill")
                            Text("\(placePost.address)")
                        }
                        .font(.subheadline)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                            Text(placePost.category)
                        }
                        .font(.footnote)
                        
                        if let phone = placePost.phone {
                            HStack(spacing: 12) {
                                Image(systemName: "phone.fill")
                                Text(phone)
                            }
                            .font(.footnote)
//                            .padding(.horizontal, 5)
                        }
                        HStack(spacing: 12) {
                            Image(systemName: "car.fill")
                            Text(placePost.isParking ? "주차 가능" : "주차 불가")
                        }
                        .font(.footnote)
                    }
                    .foregroundColor(.gray)
                }
                .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .stroke(Color.secondary, lineWidth: 0.5)
            }
            .padding(.vertical)
            ReviewView(placePost: placePost)
        }
        .padding(.horizontal)
    }
}

// 프리뷰에 더미 데이터 적용
struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyPlacePost = PlacePost(id: "1", writeUser: "김정원", title: "카페 후기", content: "맛집이에요", location: GeoPoint(latitude: 37.5665, longitude: 126.9780), image: "", address: "경기도 수원시 매탄동 393", placeName: "카카오프렌즈 코엑스점", category: "", isParking: true, createdAt: Date(), updatedAt: Date())
        
        StoreDetailView(placePost: dummyPlacePost)
    }
}
