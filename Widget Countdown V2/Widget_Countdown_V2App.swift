//
//  Widget_Countdown_V2App.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import SwiftUI
import SwiftData
import Logging

let logger = Logger(label: "Widget Countdown (V2)")

@main
struct Widget_Countdown_V2App: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Event.self)
    }
}
