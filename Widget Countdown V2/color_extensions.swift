//
//  color_extensions.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import SwiftUI

// For adaptive text & data conversion 

// adapted from:
// https://swiftandtips.com/adaptive-text-color-in-swiftui-based-on-background

extension Color {
//    func luminance() -> Double {
//        
//        let uiColor = UIColor(self)
//        
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
//        
//        // Compute luminance
//        // Based on: https://en.wikipedia.org/wiki/Relative_luminance
//        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
//    }
//    
//    func adaptedTextColor() -> Color {
//        return (luminance() > 0.7) ? Color.black : Color.white
//    }
    
    var components: (r: Double, g: Double, b: Double, a: Double) {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
        
        return (Double(r), Double(g), Double(b), Double(a))
    }
    
}

