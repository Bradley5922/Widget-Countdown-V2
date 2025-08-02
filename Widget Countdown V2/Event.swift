//
//  Item.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit


@Model
class Event {
    
    var timestamp: Date
    var name: String
    var background: Background
    
    init(
        timestamp: Date = .now,
        name: String,
        image: Data? = nil,
        gradient_colors: [Color]
    ) {
        
        self.timestamp = timestamp
        self.name = name
        
        self.background = Background(
            image: image,
            gradient_colors: gradient_colors
        )
    }
    
}

@Model
class Background {
    
    // MARK: Image stuff
    
    @Attribute(.externalStorage) var image: Data?
    
    func data_to_image() -> Image? {
        if let imageData = self.image, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo")
    }
    
    func UIImage_to_data(image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 1)!
    }
    
    // MARK: Gradient Stuff
    
    var colorA_red: Double
    var colorA_green: Double
    var colorA_blue: Double
    
    var colorB_red: Double
    var colorB_green: Double
    var colorB_blue: Double
    
    var gradient: LinearGradient {
        let colorA = Color(red: colorA_red, green: colorA_green, blue: colorA_blue)
        let colorB = Color(red: colorB_red, green: colorB_green, blue: colorB_blue)
        
        let gradient = Gradient(colors: [colorA, colorB])
        
        return LinearGradient(
            gradient: gradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    init(
        image: Data?,
        gradient_colors: [Color]
    ) {
        self.image = image
        
        let colorA = gradient_colors[0]
        let colorB = gradient_colors[1]
        
        let colorA_components = colorA.components
        let colorB_components = colorB.components
        
        self.colorA_red = colorA_components.r
        self.colorA_green = colorA_components.g
        self.colorA_blue = colorA_components.b
        
        self.colorB_red = colorB_components.r
        self.colorB_green = colorB_components.g
        self.colorB_blue = colorB_components.b
    }
}

extension Color {

    var components: (r: Double, g: Double, b: Double, a: Double) {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
        
        return (Double(r), Double(g), Double(b), Double(a))
    }
}

