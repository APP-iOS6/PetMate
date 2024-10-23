//
//  AddPlaceView.swift
//  PetMate
//
//  Created by 김정원 on 10/21/24.
//

import SwiftUI

struct AddPlaceView: View {
    @Environment(PetPlacesStore.self) private var placeStore
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("\(placeStore.searchState.setTitle(title: placeStore.selectedPlace?.place_name ?? ""))")
                        .font(.title3)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        goBack()
                    } label: {
                        placeStore.searchState.buttonImage
                            .font(.title3)
                    }
                    .padding()
                }
                .padding(.horizontal)
                ProgressView(value: placeStore.searchState.progressValue , total: 1.0)
                    .progressViewStyle(.linear)
                    .padding()
                    .animation(.easeInOut(duration: 0.1), value: placeStore.searchState.progressValue)
            }
            switch placeStore.searchState {
            case .searchPlace:
                StoreSearchView()
                    .transition(.opacity)
            case .confirmInfo:
                if let selectedPlace = placeStore.selectedPlace {
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
        .animation(.smooth, value: placeStore.searchState)
    }
    
    private func goBack() {
        switch placeStore.searchState {
        case .searchPlace:
            dismiss()
        case .confirmInfo:
            placeStore.searchState = .searchPlace
        case .addPlace:
            placeStore.searchState = .confirmInfo
        }
    }
}
#Preview {
    NavigationStack {
        AddPlaceView()
            .environment(PetPlacesStore())
    }
}
