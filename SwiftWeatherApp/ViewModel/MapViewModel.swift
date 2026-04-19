//
//  MapViewModel.swift
//  SwiftMapApplication
//
//  Created by training2 on 4/16/26.
//
import Foundation
import CoreLocation
import MapKit

class MapViewModel{
    private var latMeters: Double = 500
    private var longMeters: Double = 500
    
    // For auto-detecting location
    func region(for locations: [CLLocation]) -> MKCoordinateRegion?{
        guard let location = locations.last else { return nil }
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: latMeters,
            longitudinalMeters: longMeters
        )
    }
    
    // For input detecting location
    func region(lat: Double, lon: Double) -> MKCoordinateRegion {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: latMeters,
            longitudinalMeters: longMeters
        )
    }
}
