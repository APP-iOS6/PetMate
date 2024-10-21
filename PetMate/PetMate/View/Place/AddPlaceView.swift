//
//  AddPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI

struct AddPlaceView: View {
    @Environment(PetPlacesStore.self) private var petPlace
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            switch petPlace.searchState {
            case .searchPlace:
                StoreSearchView()
                    .transition(.opacity)
            case .confirmInfo:
                if let selectedPlace = petPlace.selectedPlace {
                    PlaceConfirmationView(store: selectedPlace)
                        .transition(.opacity)
                } else {
                    Text("선택된 장소가 없습니다.")
                        .padding()
                }
            case .addPlace:
                SubmitPlaceView()
                    .transition(.opacity)
            }
        }
        .animation(.smooth, value: petPlace.searchState)
    }
}
#Preview {
    NavigationStack {
        AddPlaceView()
            .environment(PetPlacesStore())
    }
}
