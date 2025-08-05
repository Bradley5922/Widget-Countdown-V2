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
    var createdAt: Date
    var name: String
    var background: Background
    
    init(
        timestamp: Date = .now,
        name: String,
        image: Data? = nil,
        gradient_colors: [Color],
        createdAt: Date = .now
    ) {
        
        self.timestamp = timestamp
        self.createdAt = createdAt
        self.name = name
        
        self.background = Background(
            image: image,
            gradient_colors: gradient_colors
        )
    }
    
    static func makeTestEvent() -> Event {
        // Generate timestamp: between 1 week and 5 months from now (5 months = ~150 days)
        let secondsInDay: TimeInterval = 24 * 60 * 60
        let oneWeek: TimeInterval = secondsInDay * 7
        let fiveMonths: TimeInterval = secondsInDay * 150
        let randomFutureInterval = TimeInterval.random(in: oneWeek...fiveMonths)
        let timestamp = Date().addingTimeInterval(randomFutureInterval)

        // Generate createdAt: between 1 week and 1 month ago
        let oneMonth: TimeInterval = secondsInDay * 30
        let randomPastInterval = TimeInterval.random(in: oneWeek...oneMonth)
        let createdAt = Date().addingTimeInterval(-randomPastInterval)

        // Generate two distinct random colours
        let presetColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .teal, .indigo]
        let randomColors = Array(presetColors.shuffled().prefix(2))

        return Event(timestamp: timestamp, name: "Event Name", image: nil, gradient_colors: randomColors, createdAt: createdAt)
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
    
    // Has to be computed values as not for it to assume it needs to be stored
    var colorA: Color {
        return Color(red: colorA_red, green: colorA_green, blue: colorA_blue)
    }
    var colorB: Color {
        return Color(red: colorB_red, green: colorB_green, blue: colorB_blue)
    }
    
    private var colorA_red: Double
    private var colorA_green: Double
    private var colorA_blue: Double
    
    private var colorB_red: Double
    private var colorB_green: Double
    private var colorB_blue: Double
    
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

