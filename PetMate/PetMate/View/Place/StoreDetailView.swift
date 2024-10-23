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
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                AsyncImage(url: URL(string: placePost.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("📍\(placePost.placeName)")
                        .font(.title3)
                        .bold()
                        .padding(.vertical, 8)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("반려동물 동반")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(placePost.address)")
                }
                .font(.subheadline)
                .padding(.horizontal, 5)
                
                HStack(spacing: 6) {
                    Image(systemName: "fork.knife")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(placePost.category)
                }
                .font(.footnote)
                .padding(.horizontal, 5)
                if let phone = placePost.phone {
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(phone)
                    }
                    .font(.footnote)
                    .padding(.horizontal, 5)
                }
                HStack(spacing: 6) {
                    Image(systemName: "car.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(placePost.isParking ? "주차 가능" : "주차 불가")
                }
                .font(.footnote)
                .padding(.horizontal, 5)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4)
        )
        .padding()
    }
}
//
//// 프리뷰에 더미 데이터 적용
//struct StoreDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dummyPlacePost = PlacePost(id: "1", writeUser: "김정원", title: "카페 후기", content: "맛집이에요", location: GeoPoint(latitude: 37.5665, longitude: 126.9780), image: "", address: "경기도 수원시 매탄동 393", placeName: "카카오프렌즈 코엑스점", isParking: true, createdAt: Date(), updatedAt: Date())
//        
//        StoreDetailView(placePost: dummyPlacePost)
//    }
//}
