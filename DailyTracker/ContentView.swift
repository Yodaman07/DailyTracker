//
//  ContentView.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/24/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationSplitView {
            List{
                NavigationLink("Today", destination: Daily(day: Day(date: getFormattedDate(), activities: [])))
                
                NavigationLink("Past", destination: HistoryView())
                Spacer()
                    .frame(height: 20)
                NavigationLink("Settings", destination: Settings())
                Spacer()
                    .frame(height: 180)
                
                
                    
                NavigationLink {
//                    ContentUnavailableView("Oops, this page isn't done yet, but it is being worked on for future updates :)\n\nDaily Tracker v.0.1 beta - Ayaan Irshad", systemImage: "clock.badge.xmark.fill")
                    Account()
                } label: {
                    Label("Account", systemImage: "person.circle")
                }

                    
            }
        }
        detail: {
            ContentUnavailableView("Please select a menu option", systemImage: "doc.text.image.fill")
        }
        
        
    }
}



#Preview {
    ContentView()
}
