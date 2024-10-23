//
//  Location+Extension.swift
//  PetMate
//
//  Created by 김정원 on 10/22/24.
//

import Foundation
import CoreLocation
import MapKit
import FirebaseFirestore

extension CLLocationCoordinate2D {
    static let seoul: Self = .init(
        latitude: 37.56100278,
        longitude: 126.9996417
    )
    
    static func convertUserLocationToCoordinate(x: Double?, y: Double?) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: x ?? 37.56100278, longitude: y ?? 126.9996417)
    }
    
    static func convertGeoPointToCoordinate(_ geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}

extension MKMapRect {
    
    static func convertUserLocationRect(x: String, y: String) -> MKMapRect {
        return MKMapRect(origin: MKMapPoint(CLLocationCoordinate2D(latitude: Double(x) ?? 37.56100278, longitude: Double(y) ?? 126.9996417)), size: MKMapSize(width: 0.5, height: 0.5))
    }
    
}
let rect = MKMapRect(
    origin: MKMapPoint(.seoul),
    size: MKMapSize(width: 0.5, height: 0.5)
)
