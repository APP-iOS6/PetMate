//
//  PlaceSearchView.swift
//  PetMate
//
//  Created by 김정원 on 10/16/24.
//

import SwiftUI

struct StoreSearchView: View {
    @State private var placeStore = PetPlacesStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("주소 또는 매장 이름 검색", text: $placeStore.query)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
                
                // 매장 리스트
                if placeStore.stores.isEmpty && !placeStore.query.isEmpty {
                    Spacer()
                    Text("검색 결과가 없습니다.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(placeStore.stores) { store in
                        VStack(alignment: .leading) {
                            NavigationLink(destination: StoreDetailView()) {
                                Text(store.name)
                                    .font(.headline)
                                Text(store.address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("주소 검색")
        }
    }
}

#Preview {
    StoreSearchView()
}
