//
//  ColorExtension.swift
//  Nano2
//
//  Created by 김은정 on 6/20/24.
//

import Foundation
import SwiftUI


extension Color{
    static let customLightGray = Color(hex: "747480")
    static let customGray = Color(hex: "3C3C43")
    static let customOrange = Color(hex: "FF9500")
    static let customDarGray = Color(hex: "C6C6C8")
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
