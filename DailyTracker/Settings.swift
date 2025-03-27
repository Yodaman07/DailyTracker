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
                    List($dailyActivities, editActions: .delete){ $data in
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
                dailyActivities.append(DailyItem(activity: "New Activity", goal: false))
            } .padding(10)
        

            
        }.onAppear{dailyActivities = LoadPreferences()}
    }
}



func SavePreferences(data: [DailyItem]){
    let enc = JSONEncoder()
    enc.outputFormatting = .prettyPrinted
    let data = try! enc.encode(data)
    print(String(data: data, encoding: .utf8)!)
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Preferences.json")
    
    try! data.write(to: jsonURL)
}

func LoadPreferences() -> [DailyItem] {
    let dec = JSONDecoder()
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Preferences.json")
    let d = try! Data(contentsOf: jsonURL)
    print("Loading")
    return try! dec.decode(Array<DailyItem>.self, from: d)
}

struct DailyItem: Identifiable, Codable, Equatable {
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
