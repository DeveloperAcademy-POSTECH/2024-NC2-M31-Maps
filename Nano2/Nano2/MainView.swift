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
        NavigationLink(destination: LetsgoView().toolbar(.hidden), label: {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 138, height: 150)
        })
        .toolbar(.hidden, for: .navigationBar)

    }
    
    var DiaryBtn: some View {
        NavigationLink(destination: WalkDiaryView().toolbar(.hidden), label: {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 138, height: 150)
        })
        .toolbar(.hidden, for: .navigationBar)


    }
}

#Preview {
    MainView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)

}
