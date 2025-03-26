//
//  Settings.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/25/25.
//

import SwiftUI

struct Settings: View {
    @State var dailyActivities: [DailyItem] = []
    
    var body: some View {
        NavigationStack{
        
            VStack{
                if (dailyActivities.isEmpty){
                    Text("Add you Daily Routines Here")
                        .padding(100)
                }else{
                    List($dailyActivities){ $data in
                        TextField("Rename Activity", text: $data.activity)
                    }
                }
                
                Button("Save"){
                    print("Write Data to JSON FILE")
                }.padding(10)
            }
            
            
        }.toolbar{
            Button("+"){
                dailyActivities.append(DailyItem(activity: "New Activity"))
            } .padding(10)
            
        }
    }
}

struct DailyItem: Identifiable {
    var id = UUID()
//    var icon: String //system icon
    var activity: String
}

#Preview {
    Settings()
}
