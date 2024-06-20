//
//  NaviView.swift
//  Nano2
//
//  Created by 김은정 on 6/17/24.
//

import SwiftUI

struct NaviView: View {
    
    var body: some View {
        NavigationStack{
            MainView()
        }
        .tint(Color.customOrange)
    }
}

struct BackButton: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .font(.title)
            .foregroundColor(Color.customOrange)

    }
}


#Preview {
    NaviView()
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self], inMemory: true)
    
}
