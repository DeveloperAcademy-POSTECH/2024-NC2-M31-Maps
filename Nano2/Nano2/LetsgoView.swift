//
//  LetsgoView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

//https://codewithchris.com/swiftui-corelocation/

// 코어모션

import SwiftUI

import CoreLocation
import MapKit
import CoreMotion
import SwiftData




struct LetsgoView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var locationViewModel = LocationViewModel()
    //    @Binding var walks: [Walk]
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TrackingView()
                .environmentObject(locationViewModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                print("allowing perms")
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}





struct TrackingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    
    
    @State private var startTime: Date?
    @State private var elapsedTime: Int = 0
    
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var searchResults: [MKMapItem] = []
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    @State var placeResult: [MapLocation] = []
    
    var body: some View {
        Map(position: $position){
            MapPolyline(coordinates: locationViewModel.CLwalkingRoute)
                .stroke(.blue, lineWidth: 5)
            
            if let location = locationViewModel.thisLocation {
                Annotation("내위치", coordinate: location.coordinate){
                    Image("pin")
                        .resizable()
                        .frame(width: 74, height: 89)
                        .offset(y:-25)
                }
            }
            
            ForEach(placeResult) { result in
                Annotation(result.name, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
                {
                    Circle()
                        .fill(Color.yellow)
                        .stroke(Color.white, lineWidth: 2)
                }
            }
        }
        .mapControls{
            MapUserLocationButton()
        }
        .onAppear {
            startTime = Date()
            startTimer()
        }
        
        Rectangle()
            .fill(Color(red: 0.45, green: 0.45, blue: 0.5).opacity(0.08))
            .frame(width: 353, height: 72)
            .cornerRadius(12)
        
        
        VStack {
            VStack {
                HStack{
                    Text( String(coordinate?.latitude ?? 0))
                    Text( String(coordinate?.longitude ?? 0))
                    
                }
                HStack{
                    Text("Distance")
                    Text(String(locationViewModel.totalDistance))
                }
                
                HStack{
                    Text("Time")
                    Text(convertSecondsToTime(timeInSeconds: elapsedTime))
                }
                HStack{                           
                    Text("마킹 횟수")
                    Text(String(placeResult.count))
                }
                
            }
            .padding()
        }
        
        
        Text("마킹하기")
            .onTapGesture {
                let marking = MapLocation(
                    name:  "마킹_\(placeResult.count)",
                    latitude: locationViewModel.thisLocation?.coordinate.latitude ?? 0,
                    longitude: locationViewModel.thisLocation?.coordinate.longitude ?? 0)
                
                //                let moneyInput = WalkInput(walk: marking)
                
                placeResult.append(marking)
            }
        
        Text("종료하기")
            .onTapGesture {
                
                let loc = convertCLLocToLoc(CLLoc: locationViewModel.CLwalkingRoute)
                let newWalk = WalkInput(walkingRoute: loc, distance: Int(locationViewModel.totalDistance), time: elapsedTime, marking: placeResult)
                
                for l in loc{
                    print(l.latitude, l.longitude)
                }
                
                modelContext.insert(newWalk)
                
                
                dismiss()
                
            }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.thisLocation?.coordinate
    }
    
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds - hours*3600) / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    
    func convertCLLocToLoc(CLLoc: [CLLocationCoordinate2D]) -> [LocationInfo] {
        var walkingRoute: [LocationInfo] = []
        
        print(CLLoc)
        print()
        for CLLocation in CLLoc {
            let Location = LocationInfo(latitude: CLLocation.latitude, longitude: CLLocation.longitude)
            walkingRoute.append(Location)
            print(Location.latitude, Location.longitude)
        }
        return walkingRoute
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Int(Date().timeIntervalSince(startTime ?? Date()))
        }
    }
    
}


//
#Preview {
    LetsgoView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)
    
}



