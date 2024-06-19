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
    static let home = CLLocationCoordinate2D(latitude: 38.33170, longitude: -122.030237)
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var thisLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.457105, longitude: -80.508361), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    
    var totalDistance: CLLocationDistance = 0
    var totalTime: Int = 0
//    var walkingRoute: [LocationInfo] = []
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
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
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
        
        //                fetchCountryAndCity(for: locations.first)
        
        if let previousLocation = self.previousLocation {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2D(latitude: previousLocation.coordinate.latitude, longitude: previousLocation.coordinate.longitude)
            let point2 = CLLocationCoordinate2D(latitude: thisLocation!.coordinate.latitude, longitude: thisLocation!.coordinate.longitude)
            points.append(point1)
            points.append(point2)
            
            let distance = thisLocation!.distance(from: previousLocation)
            
            CLwalkingRoute.append(point2)
            
            totalDistance += distance
            
            
            //
        }
        //                print("user motion is running or walking")
        //                print(activity)
        //                print(walkingCoordinates)
        previousLocation = thisLocation!
        //            }
        //
        //            else {
        //                locationManager.stopUpdatingLocation()
        //                print("user motion is not running or walking")
        //                print(activity)
        //            }
        //
        ////            1초마다.........
        //            totalTime = Int(Date().timeIntervalSince(startTime))
        //
        //        }
        
    }
    
    
    
    
    //    func fetchCountryAndCity(for location: CLLocation?) {
    //        guard let location = location else { return }
    //        let geocoder = CLGeocoder()
    //        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
    //            self.currentPlacemark = placemarks?.first
    //        }
    //    }
}
