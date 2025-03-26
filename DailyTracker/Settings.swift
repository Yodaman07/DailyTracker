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
                        HStack{
                            TextField("Rename Activity", text: $data.activity)
                            Toggle(isOn: $data.goal){Text("Has Goal")}
                            if ($data.goal.wrappedValue){
                                TextField("Value", value: $data.goalValue, formatter: NumberFormatter())
                                
                                TextField("Units", text: $data.goalUnits)
                            }
                        }
                    }
                }
                
                Button("Save"){
                    print("Write Data to JSON FILE")
                }.padding(10)
            }
            
            
        }.toolbar{
            Button("+"){
                dailyActivities.append(DailyItem(activity: "New Activity", goal: false))
            } .padding(10)
            
        }
    }
}

struct DailyItem: Identifiable {
    var id = UUID()
//    var icon: String //system icon
//https://github.com/alessiorubicini/SFSymbolsPickerForSwiftUI
    var activity: String
    var goal: Bool
    var goalValue: Int = 0
    var goalUnits: String = ""
}

#Preview {
    Settings()
}
