//
//  LocationViewModel.swift
//  Nano2
//
//  Created by 김은정 on 6/20/24.
//

import Foundation
import CoreLocation
import MapKit
import CoreMotion


extension CLLocationCoordinate2D{
    static let home = CLLocationCoordinate2D(latitude: 36.014008452398, longitude: 129.3258174744)
}


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var thisLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    @Published var mapRegion = MKCoordinateRegion(center: .home, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    
    var totalDistance: CLLocationDistance = 0
    var totalTime: Int = 0
    var CLwalkingRoute: [CLLocationCoordinate2D] = []
    private var previousLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    
    private let motionManager: CMMotionActivityManager
    
    override init() {
        motionManager = CMMotionActivityManager()
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true 
    }
    
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stopUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //        motionManager.startActivityUpdates(to: .main) { [self] activity in
        //            guard let activity = activity else {
        //                return
        //            }
        //            if activity.running == true || activity.walking == true {
        print("아오")

        thisLocation = locations.first
        mapRegion = MKCoordinateRegion(center: thisLocation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        
        if let previousLocation = self.previousLocation {
            let distance = thisLocation!.distance(from: previousLocation)
            
            CLwalkingRoute.append(CLLocationCoordinate2D(latitude: thisLocation!.coordinate.latitude, longitude: thisLocation!.coordinate.longitude))
            totalDistance += distance
            
        }
        previousLocation = thisLocation!
        
        //                print("user motion is running or walking")
        //                print(activity)
        //                print(walkingCoordinates)
        //            }
        //
        //            else {
        //                locationManager.stopUpdatingLocation()
        //                print("user motion is not running or walking")
        //                print(activity)
        //            }
        //        }
        
    }
    
    
    
    
}
