//
//  MainView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

import SwiftUI

struct MainView: View {
    

    var body: some View {
//        ContentView()
        WalkBtn
        DiaryBtn
    }
    
    var WalkBtn: some View {
        NavigationLink(destination: LetsgoView(), label: {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 138, height: 150)
        })
    }
    
    var DiaryBtn: some View {
        NavigationLink(destination: WalkDiaryView(), label: {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 138, height: 150)
        })
    }
}

#Preview {
    MainView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)

}
