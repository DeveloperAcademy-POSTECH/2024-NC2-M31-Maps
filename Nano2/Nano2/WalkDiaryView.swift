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
    
    @State var selectedWalk: WalkInput?
    
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
        VStack(alignment: .leading){
            Text("\(DateString(in: SelectDate)) 산책 기록")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color.customGray)
            
            
            if Walks.isEmpty {
                HStack{
                    Spacer()
                    Text("산책 기록 없음")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.customGray)
                    Spacer()
                }
                .frame(height: 300)
                
            }
            else{
                ScrollView{
                    ForEach(Array(zip(Walks.indices, Walks)), id: \.0) { index, walk in
                        NavigationLink(destination: ResultView(walking: $selectedWalk)
                            .navigationBarTitle("\(DateString(in: SelectDate)) \(index+1)번째 산책"), label: {
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
                                
                            })
                        .simultaneousGesture(TapGesture().onEnded{
                            selectedWalk = walk
                        })
                    }
                }
                .frame(height: 300)
                
            }
        }
    }
    
}

struct WalkDiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @State var SelectDate = Date()
    
    
    var body: some View {
        VStack{
            DatePicker("쉬도",selection: $SelectDate, displayedComponents: .date)
                .labelsHidden()
                .accentColor(.orange)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(width: .infinity)
            WalkList(SelectDate: SelectDate)
                .padding(.horizontal, 20)
//                .frame(height: 336)

        }
    }
}

#Preview {
    WalkDiaryView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)
    
}
