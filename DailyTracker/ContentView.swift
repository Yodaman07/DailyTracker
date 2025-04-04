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
                NavigationLink("Today", destination: Daily())
                
                NavigationLink("Past", destination: Daily())
                Spacer()
                    .frame(height: 20)
                NavigationLink("Settings", destination: Settings())
                Spacer()
                    .frame(height: 180)
                
                
                    
                NavigationLink {
                    Daily()
                } label: {
                    Label("Account", systemImage: "person.circle")
                }

                    
            }
        } detail: {
            ContentUnavailableView("Please select a menu option", systemImage: "doc.text.image.fill")
        }
        
        
    }
}



#Preview {
    ContentView()
}
