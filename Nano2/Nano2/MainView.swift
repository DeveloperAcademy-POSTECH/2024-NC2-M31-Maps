//
//  MainView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

import SwiftUI

struct MainView: View {
    

    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            WalkBtn
            ScrollView(.horizontal) {
                HStack{
                    DiaryBtn
                    StatisticsBtn
                }
            }
        }
        .padding(.leading, 20)
    }
    
    var WalkBtn: some View {
        NavigationLink(
            destination: LetsgoView().navigationBarTitleDisplayMode(.inline),
                       label: { Image("산책가자1") } )
        
    }
    
    var DiaryBtn: some View {
        NavigationLink(
            destination: WalkDiaryView()
                .navigationBarTitle("산책 기록")
                .navigationBarTitleDisplayMode(.inline),
            label: { Image("산책기록1") })
    }
    
    var StatisticsBtn: some View {
        NavigationLink(
            destination: 
                StatisticsView()
                .navigationBarTitle("산책 통계")
                .navigationBarTitleDisplayMode(.inline),
            label: { Image("산책통계1") })
    }
}

#Preview {
    MainView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)

}
