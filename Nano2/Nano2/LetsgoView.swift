//
//  LetsgoView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

//https://codewithchris.com/swiftui-corelocation/

// 코어모션

// /Users/ezzkim/Library/Developer/CoreSimulator/Devices/6B4514AB-35E6-4AA6-A475-63B6DEF16D7F/data/Containers/Data/Application/2FC3EEBB-F48A-49A8-8F8E-BD4820DF1A1C/Library/Application Support/


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
    
    @EnvironmentObject var locationViewModel: LocationViewModel

    
    @State private var startTime: Date?
    @State private var elapsedTime: Int = 0
    
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchResults: [MKMapItem] = []
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State var placeResult: [MapLocation] = []
    
    var body: some View {
        VStack(spacing: 24){
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)){
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
                        .annotationTitles(.hidden)
                    }
                    
                    ForEach(placeResult) { result in
                        Annotation(result.name, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
                        {
                            Circle()
                                .fill(Color.yellow)
                                .stroke(Color.white, lineWidth: 2)
                        }
                        .annotationTitles(.hidden)
                        
                    }
                }
                .mapControls{
                    MapUserLocationButton()
                }
                QuitBtn
                    . padding(20)
                    .onTapGesture {
                        let route = convertCLLocToLoc(CLLoc: locationViewModel.CLwalkingRoute)
                        let newWalk = WalkInput(walkingRoute: route, distance: Int(locationViewModel.totalDistance), time: elapsedTime, marking: placeResult)
                        
                        for l in route{
                            print(l.latitude, l.longitude)
                        }
                        
                        modelContext.insert(newWalk)

                        dismiss()
                    }
            }
            
            ZStack{
                Rectangle()
                    .fill(Color(red: 0.45, green: 0.45, blue: 0.5).opacity(0.08))
                    .frame(width: 353, height: 72)
                    .cornerRadius(12)
                
                
                HStack(alignment: .center, spacing: 20){
                    VStack(alignment: .leading, spacing: 8) {
                        Text("산책 시간")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customGray)
                        
                        Text(convertSecondsToTime(timeInSeconds: elapsedTime))
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customOrange)
                    }
                    .frame(width: 70)
                    Rectangle()
                        .fill(Color.customDarGray)
                        .frame(width: 1, height: 40)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("거리(km)")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customGray)
                        
//                        Text("\(locationViewModel.totalDistance/1000)")
                        Text(String(format: "%.2f", locationViewModel.totalDistance/1000))

                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customOrange)
                    }
                    .frame(width: 70)
                    
                    
                    Rectangle()
                        .fill(Color.customDarGray)
                        .frame(width: 1, height: 40)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("마킹 횟수")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customGray)
                        
                        Text("+\(placeResult.count)")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customOrange)
                    }
                    .frame(width: 70)
                }
            }
            
            
            
            MarkingBtn
                .onTapGesture {
                    let marking = MapLocation(
                        name:  "마킹_\(placeResult.count)",
                        latitude: locationViewModel.thisLocation?.coordinate.latitude ?? 0,
                        longitude: locationViewModel.thisLocation?.coordinate.longitude ?? 0)
                    
                    placeResult.append(marking)
                }
            
            
            
            
            
        }
        .onAppear {
            startTime = Date()
            startTimer()
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.thisLocation?.coordinate
    }
    
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes,seconds)
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
    
    var QuitBtn: some View {
        Text("􀛷 산책종료")
            .font(.system(size: 15))
            .foregroundColor(Color.customOrange)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(.white)
            .cornerRadius(40)
            .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 0)
    }
    
    var MarkingBtn: some View {
        Text("마킹하기")
            .font(.system(size: 17))
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(width: 353, alignment: .center)
            .background(Color.customOrange)
            .cornerRadius(12)
        
    }
    
}


//
#Preview {
    LetsgoView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)
    
}



