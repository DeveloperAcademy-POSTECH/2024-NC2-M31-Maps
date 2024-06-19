//
//  MarkingModel.swift
//  Nano2
//
//  Created by 김은정 on 6/18/24.
//

import Foundation
import CoreLocation
import SwiftData



struct Move {
    var latitude: Double
    var longitude: Double
}


@Model
class LocationInfo {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


@Model
class MapLocation {
    @Attribute(.unique) var id: UUID = UUID()

    var name: String
    
    var latitude: Double
    var longitude: Double
    
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

}



@Model
class WalkInput {
    @Attribute(.unique) var id: UUID = UUID()
    var date = Date()
    
    @Relationship var walkingRoute: [LocationInfo]
    var distance: Int
    var time: Int
    
    @Relationship var marking: [MapLocation]

    init(date: Date = Date(), walkingRoute: [LocationInfo], distance: Int, time: Int, marking: [MapLocation]) {
        self.date = date
        self.walkingRoute = walkingRoute
        self.distance = distance
        self.time = time
        self.marking = marking
    }
}