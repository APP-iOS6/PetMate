//
//  PetMapView.swift
//  PetMate
//
//  Created by 김정원 on 10/15/24.
//

import SwiftUI
import KakaoMapsSDK
import MapKit

struct PetMapView: View {

    @Environment(PetFriendlyPlacesStore.self) private var placeStore
    
    var body: some View {
        Map {
            ForEach(placeStore.places) { place in
                Annotation("\(place.title)", coordinate: placeStore.convertGeoPointToCoordinate(geoPoint: place.location)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.yellow)
                        Text("☕️")
                            .padding(5)
                    }
                }
            }
            
        }
    }
    
}

#Preview {
    PetMapView()
        .environment(PetFriendlyPlacesStore())
}
