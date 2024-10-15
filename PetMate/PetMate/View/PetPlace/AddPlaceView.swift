//
//  AddPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI
import FirebaseFirestore

struct AddPlaceView: View {
    @Environment(PetPlacesStore.self) private var placeStore
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var address: String = ""
    @State private var placeName: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var geoHash: String = ""
    @State private var isParking: Bool = false

    var body: some View {
        Form {
            Section(header: Text("장소 정보")) {
                TextField("장소 이름", text: $placeName)
                TextField("주소", text: $address)
                TextField("위도", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("경도", text: $longitude)
                    .keyboardType(.decimalPad)
                Toggle("주차 가능", isOn: $isParking)
            }
            
            Section(header: Text("설명")) {
                TextField("설명", text: $content)
            }
            
            Button("장소 추가") {
                guard let lat = Double(latitude), let lon = Double(longitude) else {
                    print("Invalid coordinates")
                    return
                }
                placeStore.addPlace(
                    writeUser: UUID().uuidString,
                    title: placeName,
                    content: content,
                    address: address,
                    placeName: placeName,
                    isParking: isParking,
                    latitude: lat,
                    longitude: lon,
                    geoHash: geoHash
                ) { success in
                    if success {
                        print("장소가 성공적으로 추가되었습니다.")
                    } else {
                        print("장소 추가에 실패했습니다.")
                    }
                }
            }
        }
        .navigationBarTitle("장소 추가")
    }
}

#Preview {
    AddPlaceView()
        .environment(PetPlacesStore())
}
