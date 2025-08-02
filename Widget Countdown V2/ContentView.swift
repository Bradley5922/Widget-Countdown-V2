//
//  ContentView.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]

    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    Text(event.name)
                        .background(
                            event.background.gradient
                        )
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Add Button Clicked")
                        tempEventsCreation()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func tempEventsCreation() {
        let fake_event = Event(name: "Allison", gradient_colors: [.pink, .purple])
        
        modelContext.insert(fake_event)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(events[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Event.self, inMemory: true)
}
