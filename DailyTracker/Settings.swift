//
//  Settings.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/25/25.
//

import SwiftUI

struct Settings: View {
    @State var dailyActivities: [DailyItem] = LoadPreferences()
    
    var body: some View {
        NavigationStack{
        
            VStack{
                if (dailyActivities.isEmpty){
                    Text("Add Your Daily Activities Here")
                        .padding(100)
                }else{
                    List($dailyActivities, editActions: .move){ $data in
                        HStack{
                            TextField("Rename Activity", text: $data.activity)
                            Toggle(isOn: $data.goal){Text("Has Goal")}
                            if ($data.goal.wrappedValue){
                                TextField("Value", value: $data.goalValue, formatter: NumberFormatter())
                                
                                TextField("Units", text: $data.goalUnits)
                            }
                        }.contextMenu{
                            Button(
                                action: {
                                    if let i = dailyActivities.firstIndex(of: data){
                                        dailyActivities.remove(at: i)
                                    }else{
                                        print("Something went wrong")
                                    }
                                }
                            )
                            {Text("Delete")}
                            
                        }//End of context menu
                        
                        
                    }
                        
                }
                
                Button("Save"){
                    SavePreferences(data: dailyActivities)
                    print("Write Data to JSON FILE!")
                }.padding(10)
            }
            
            
        }.toolbar{
            Button("+"){
                print("AAAA")
                dailyActivities.append(DailyItem(activity: "New Activity", goal: false))
            } .padding(10)
        

            
        }.onAppear{dailyActivities = LoadPreferences()}
    }
}





struct DailyItem: Identifiable, Codable, Equatable { //equitable means we can compare objects
    var id = UUID()
//  var icon: String //system icon
//https://github.com/alessiorubicini/SFSymbolsPickerForSwiftUI
    var activity: String
    var goal: Bool
    var goalValue: Int = 0
    var goalUnits: String = ""
    
    
    var complete: Bool = false
}

#Preview {
    Settings()
}
