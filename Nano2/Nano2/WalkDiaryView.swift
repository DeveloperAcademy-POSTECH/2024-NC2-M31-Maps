//
//  WalkDiaryView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

import SwiftUI
import CoreLocation
import MapKit
import SwiftData


struct WalkDiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var Walks: [WalkInput]
    
    @State private var date = Date()
    
    var body: some View {
        //        var walk = walks.first!
        
        DatePicker("쉬도",selection: $date, displayedComponents: .date)
            .labelsHidden()
            .accentColor(.orange)
            .datePickerStyle(GraphicalDatePickerStyle())
        
        Text("6월 4일 산책 기록")
            .font(
                Font.custom("SF Pro", size: 15)
                    .weight(.semibold)
            )
            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.6))
            .frame(maxWidth: .infinity, alignment: .topLeading)
        
        //        resultview()
        
        Map(){
            
            ForEach(Walks) { walk in
                let cllocation = convertLocToCLLoc(Loc: walk.walkingRoute)
            
                
                MapPolyline(coordinates: cllocation)
                    .stroke(.blue, lineWidth: 5)
                
                ForEach(walk.marking) { result in
                    Annotation(result.name, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
                    {
                        Circle()
                            .fill(Color.yellow)
                            .stroke(Color.white, lineWidth: 2)
                        
                    }
                }
            }
        }
        .mapControls{
            MapUserLocationButton()
        }
        
    }
    
    func convertLocToCLLoc(Loc: [LocationInfo]) -> [CLLocationCoordinate2D] {
        var CLwalkingRoute: [CLLocationCoordinate2D] = []
        for Location in Loc {
            let CLLocation = CLLocationCoordinate2D(latitude: Location.latitude, longitude: Location.longitude)
            CLwalkingRoute.append(CLLocation)
            print(Location.latitude, Location.longitude)
            print(CLLocation)
        }
        print()
  
        return CLwalkingRoute
        
    }
    
    
}

#Preview {
    WalkDiaryView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)
    
}
