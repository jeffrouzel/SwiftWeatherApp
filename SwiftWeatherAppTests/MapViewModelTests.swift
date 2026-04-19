//
//  MapViewModelTests.swift
//  SwiftMapApplication
//
//  Created by training2 on 4/16/26.
//
// https://www.youtube.com/watch?v=YR3PgwKKraw

import XCTest
import CoreLocation
import MapKit
@testable import SwiftMapApplication

final class MapViewModelTests: XCTestCase {
    
    private var sut: MapViewModel!    // System Under Test = sut
    
    override func setUp() {
        super.setUp()
        sut = MapViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_region(){
        // Arrange
        let testLocCoord = CLLocationCoordinate2D(latitude: 37.33, longitude: -121.89)
        let testLoc = CLLocation(latitude: testLocCoord.latitude, longitude: testLocCoord.longitude)
        let locArray = [testLoc]
        let meters: Double = 100
        
        // Act
        sut.updateMeters(meter: meters)
        let testRegion = sut.region(for: locArray)
        // Assert
        XCTAssertNotNil(testRegion)
        XCTAssertEqual(testRegion?.center.latitude, testLocCoord.latitude)
        XCTAssertEqual(testRegion?.center.longitude, testLocCoord.longitude)
    }
    
    func test_region_withEmptyLocation(){
        // Arrange
        let emptyLocArray: [CLLocation] = []
        
        // Act
        let nilRegion = sut.region(for: emptyLocArray)
        
        // Assert
        XCTAssertNil(nilRegion)
    }
    
}
