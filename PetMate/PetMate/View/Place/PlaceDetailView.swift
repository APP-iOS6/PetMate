//
//  PlaceDetailView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceDetailView: View {
    let document: Document

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 이미지 섹션 (실제 이미지 URL을 사용하려면 추가 작업 필요)
                Image("cafe1") // 실제 이미지 이름으로 교체
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()

                // 장소 정보 섹션
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("📍 \(document.place_name)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Label(document.address_name, systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Label(document.road_address_name.isEmpty ? document.address_name : document.road_address_name, systemImage: "road.lanes")
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
                }
                .padding([.leading, .trailing], 16)

                Divider()

                // 리뷰 섹션 (예시 데이터)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image("gadiProfile") // 사용자 프로필 이미지 이름으로 교체
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text("김정원") // 예시 사용자 이름
                                .font(.headline)
                            Text("📍 구월 3동") // 예시 사용자 위치
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("어제 다녀왔는데 맛집이네요")
                            .font(.body)
                            .fontWeight(.bold)
                        Text("사장님이 강아지를 무척이나 좋아하세요^^ 이쁜 한가득 받고 온 울 가디..")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 4)
                }
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 16)

                Spacer()
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding()
        }
        .navigationTitle("장소 추가")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    PlaceDetailView(document: Document(
        place_name: "카카오프렌즈 코엑스점",
        distance: "418",
        place_url: "http://place.map.kakao.com/26338954",
        category_name: "가정,생활 > 문구,사무용품 > 디자인문구 > 카카오프렌즈",
        address_name: "서울 강남구 삼성동 159",
        road_address_name: "서울 강남구 영동대로 513",
        x: "127.05902969025047",
        y: "37.51207412593136",
        phone: "02-6002-1880",
        category_group_code: "",
        category_group_name: ""
    ))
}
