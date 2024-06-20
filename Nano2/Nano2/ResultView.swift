//
//  ResultView.swift
//  Nano2
//
//  Created by 김은정 on 6/20/24.
//

import SwiftUI
import MapKit

struct ResultView: View {
    @Binding var walking: WalkInput?
    
    
    var body: some View {
        if let walk = walking {
            let newArr = walk.walkingRoute.sorted(by: {$0.date < $1.date})
            
            let cllocation = convertLocToCLLoc(Loc: newArr)
            
            VStack(spacing: 24){
                Map(){
                    Annotation("집", coordinate: .home)
                    {
                        Image(systemName: "house")
                            .padding(4)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                    Annotation("출발", coordinate: cllocation.first!)
                    {
                        Circle()
                            .fill(Color.red)
                            .stroke(Color.white, lineWidth: 2)
                    }
                    Annotation("도착", coordinate: cllocation.last!)
                    {
                        Circle()
                            .fill(Color.blue)
                            .stroke(Color.white, lineWidth: 2)
                    }
//                    .annotationTitles(.hidden)
                    
                    MapPolyline(coordinates: cllocation)
                        .stroke(Color.customOrange, lineWidth: 5)
                    
                    ForEach(walk.marking) { result in
                        Annotation(result.name, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
                        {
                            Image("MarkingPin")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .annotationTitles(.hidden)

                    }
                }
                .frame(height: 586)
                
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
                
                Spacer()
            }
        }
    }
    
    
    func convertLocToCLLoc(Loc: [LocationInfo]) -> [CLLocationCoordinate2D] {
        var CLwalkingRoute: [CLLocationCoordinate2D] = []
        for Location in Loc {
            let CLLocation = CLLocationCoordinate2D(latitude: Location.latitude, longitude: Location.longitude)
            CLwalkingRoute.append(CLLocation)
        }
        
        return CLwalkingRoute
    }
    
}

//#Preview {
////    ResultView()
//}


