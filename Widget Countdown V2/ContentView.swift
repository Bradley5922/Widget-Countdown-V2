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
    @Query(sort: \Event.timestamp) private var events: [Event]

    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    EventCard(event: event)
                        .listRowInsets(.init())
                        .listRowBackground(Color.clear)
                }
            }
            .listRowSpacing(16.0)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Add Button Clicked")
                        
                        let fake_event = Event.makeTestEvent()
                        modelContext.insert(fake_event)
                        
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Upcoming Events")
        }
    }
}

struct EventCard: View {
    
    var event: Event
    
    @State var displayRing: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.title2)
                    .bold()
                
                Text(event.timestamp.formatted(date: .long, time: .shortened))
            }
            
            Spacer()
            
            Group {
                if displayRing {
                    
                    ring(
                        for: .white,
                        progress: percentageBetweenDates(startDate: event.createdAt, endDate: event.timestamp)
                    )
                    .frame(width: 60, height: 60)
                    
                } else {
                    
                    counterDisplay()
                    
                }
            }
            .onTapGesture {
                withAnimation{ displayRing.toggle() }
            }
            .transition(.blurReplace)
            
        }
        .frame(minHeight: 80)
        .padding([.top, .bottom])
        .padding([.leading, .trailing], 20)
        .background(
            event.background.gradient
        )
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 16))
        .foregroundStyle(
            .white
        )
    }
    
    func ring(for color: Color, progress: Double) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 8))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .shadow(radius: 4)
            }
            .rotationEffect(.degrees(-90))
    }
    
    func counterDisplay()  -> some View {
        VStack(alignment: .center, spacing: -4) {
            
            let date_display_metadata = dateFormatterHomepage(date: event.timestamp)
            
            Text(String(format: "%03d", date_display_metadata.amount))
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text(date_display_metadata.type)
                .foregroundStyle(.secondary)
        }
    }
    
    func percentageBetweenDates(startDate: Date = .now, endDate: Date) -> Double {
        
        let totalDuration = endDate.timeIntervalSince(startDate)
        let timePassed = (Date.now).timeIntervalSince(startDate)

        guard totalDuration > 0 else { return 0 }
        
        let fraction = timePassed / totalDuration
        
        return min(max(fraction, 0), 1)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Event.self, inMemory: true)
}

