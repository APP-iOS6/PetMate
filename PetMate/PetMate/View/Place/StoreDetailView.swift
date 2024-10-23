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
            AsyncImage(url: URL(string: "https://fac.or.kr/wp-content/uploads/2024/05/tsa_icarus_A_cozy_and_modern_restaurant_with_a_warm_atmosphere__24474e76-904f-4762-9ba9-1c4086295079.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Color.gray
                    .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("📍\(placePost.placeName)") // 줄 넘어가면 이상해질수 있음
                        .font(.title2)
                        .bold()
                        .padding(.vertical, 8)
                    
                    Spacer()
                    
                    Text("반려동물 동반")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse") // 똑같이 못하고 비슷한걸로 대체
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(placePost.address)")
                }
                .font(.subheadline)
                .padding(.horizontal, 5)
                
                HStack(spacing: 6) {
                    Image(systemName: "fork.knife") //똑같이 못하고 비슷한걸로 대체
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("음식점 > 카페")
                }
                .font(.footnote)
                .padding(.horizontal, 5)
                
                HStack(spacing: 6) {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("전화번호: 010-1234-5678")
                }
                .font(.footnote)
                .padding(.horizontal, 5)
                
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
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding()
    }
}

//// 프리뷰에 더미 데이터 적용
//struct StoreDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dummyPlacePost = PlacePost(id: "1", writeUser: "김정원", title: "카페 후기", content: "맛집이에요", location: GeoPoint(latitude: 37.5665, longitude: 126.9780), address: "경기도 수원시 매탄동 393", placeName: "카카오프렌즈 코엑스점", isParking: true, createdAt: Date(), updatedAt: Date())
//        
//        StoreDetailView(placePost: dummyPlacePost)
//    }
//}
