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

extension WalkInput{
    static func predicate(
        searchDate: Date
    ) -> Predicate<WalkInput> {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: searchDate)
        let end = calendar.date(byAdding: .init(day: 1), to: start) ?? start
        
        return #Predicate<WalkInput> { walk in
            (walk.date > start && walk.date < end)
        }
    }
}


struct WalkList: View {
        @Environment(\.modelContext) private var modelContext

    @Query private var Walks: [WalkInput]

    var SelectDate: Date

    init(SelectDate: Date) {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: SelectDate)
        let end = calendar.date(byAdding: .init(day: 1), to: start) ?? start
        self._Walks = Query(filter: #Predicate<WalkInput> { walk in
            walk.date > start && walk.date < end
        } )
        self.SelectDate = SelectDate
    }
    
    
    var body: some View {
        
        List(Walks) { walk in
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
                        
                        Text(convertSecondsToTime(timeInSeconds: walk.time))
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
                        Text("\(walk.distance)")
                        
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
                        
                        Text("+\(walk.marking.count)")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.customOrange)
                    }
                    .frame(width: 70)
                }
            }
            
            
        }

    }
}

struct WalkDiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @State var SelectDate = Date()
    
    
    var body: some View {
        
        DatePicker("쉬도",selection: $SelectDate, displayedComponents: .date)
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
        
        
        WalkList(SelectDate: SelectDate)
        
        
        //        resultview()
        
        
        
        
//        Map(){
//            
//            ForEach(Walks) { walk in
//                let newArr = walk.walkingRoute.sorted(by: {$0.date < $1.date})
//
//                let cllocation = convertLocToCLLoc(Loc: newArr)
//            
//            
//                
//                MapPolyline(coordinates: cllocation)
//                    .stroke(.blue, lineWidth: 5)
//                
//                ForEach(walk.marking) { result in
//                    Annotation(result.name, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
//                    {
//                        Circle()
//                            .fill(Color.yellow)
//                            .stroke(Color.white, lineWidth: 2)
//                        
//                    }
//                }
//            }
//        }
//        .mapControls{
//            MapUserLocationButton()
//        }
        
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
