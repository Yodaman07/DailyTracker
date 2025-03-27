//
//  Daily.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/26/25.
//

import SwiftUI

struct Daily: View {
    @State var pref : [DailyItem] = LoadPreferences();
    @State var test : Bool = false
    var body: some View {
        //TODO Scrollable
        VStack{
            List($pref){ $data in
                HStack{
                    Text($data.activity.wrappedValue)
                        .font(.title3)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    
                    Spacer()
                    
                    Toggle(isOn: $test){Text("Completed?")}
                        .padding(10)
                }
                    
                    
            }
        }.onAppear{
            print(Date.now)
            pref = LoadPreferences()
        } //load preferences every time view is loaded
    }
}

struct Day: Codable{
    var date: Date
    var activities: [DailyItem] = LoadPreferences() //Need to associate these with the day
}

#Preview {
    Daily()
}

