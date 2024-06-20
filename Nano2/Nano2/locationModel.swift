//
//  MarkingModel.swift
//  Nano2
//
//  Created by 김은정 on 6/18/24.
//

import Foundation
import CoreLocation
import SwiftData


func convertSecondsToTime(timeInSeconds: Int) -> String {
    let minutes = timeInSeconds / 60
    let seconds = timeInSeconds % 60
    return String(format: "%02i:%02i", minutes,seconds)
}

func DateString(in date: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 dd일"
    return formatter.string(from: date ?? Date())
}

struct Move {
    var latitude: Double
    var longitude: Double
}


@Model
class LocationInfo {
    @Attribute(.unique) var date = Date()

    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}


@Model
class MapLocation : Identifiable {
    @Attribute(.unique) var date = Date()

    var name: String
    
    var latitude: Double
    var longitude: Double
    
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
    
    init(date: Date = Date(), name: String, latitude: Double, longitude: Double) {
        self.date = date
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
    var distance: String
    var time: Int
    
    @Relationship var marking: [MapLocation]

    init(date: Date = Date(), walkingRoute: [LocationInfo], distance: String, time: Int, marking: [MapLocation]) {
        self.date = date
        self.walkingRoute = walkingRoute
        self.distance = distance
        self.time = time
        self.marking = marking
    }
}
