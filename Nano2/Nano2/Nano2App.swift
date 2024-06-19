//
//  Nano2App.swift
//  Nano2
//
//  Created by 김은정 on 6/12/24.
//

import SwiftUI
import SwiftData

@main
struct Nano2App: App {
    
    var body: some Scene {
        WindowGroup {
            NaviView()

        }
        .modelContainer(for: [WalkInput.self, MapLocation.self, LocationInfo.self])
        
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false ))
        
    }

}
