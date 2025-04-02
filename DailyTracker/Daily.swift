//
//  Daily.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/26/25.
//

import SwiftUI

struct Daily: View {
    @State var day : Day =  Day(date: getFormattedDate(), activities: []) //just a temporary value
    var body: some View {
        //TODO Scrollable
        VStack{
            List($day.activities){ $data in
                HStack{
                    Text($data.activity.wrappedValue)
                        .font(.title3)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    
                    Spacer()
                    if ($data.goal.wrappedValue){
                        HStack{
                            Text("Goal: ")
                                .fontWeight(.bold)
                            Text(String($data.goalValue.wrappedValue) + " " + $data.goalUnits.wrappedValue)
                                .font(.callout)
                        }
                        Spacer()
                    }
                    
                    
                    Toggle(isOn: $data.complete){Text("Completed?")}
                        .padding(10)
                        .onChange(of: data.complete, initial: false){
                            SaveData(data: day)
                        }
                }
                    
                    
            }
        }.onAppear{
            let allDayData: [Day] = LoadData()

            let date = getFormattedDate()
            //Code to run if we have to add a new day
            if (!dayExists(days: allDayData, date: date)){
                let dayData = Day(date: date, activities: LoadPreferences())
                day = dayData //update view data
                SaveData(data: dayData) //update saved data
                
            }else{ //Code to run if we are just loading the day we already have
                day = getDay(days: allDayData, date: date) //update view data
            }
            
        } //load preferences every time view is loaded
    }
}

struct Day: Codable{
    var date: String
    var activities: [DailyItem] = LoadPreferences() //Need to associate these with the day
}


func SaveData(data: Day){ //saving data from scratch

//    print(String(data: encodedData, encoding: .utf8)!)
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let jsonURL = documentsDirectory.appendingPathComponent("Data.json")
    var dataToEncode : [Day] = [data]
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Data.json")

    if FileManager.default.fileExists(atPath: jsonURL.path){
        //If the file exists, get all of its data, and add a new Day element
        dataToEncode = LoadData()
        //Need to remove the old element with the same name
        if dayExists(days: dataToEncode, date: getFormattedDate()){
            let index = getIndexToRemove(days: dataToEncode, date: getFormattedDate())
            print("Updating data at index " + String(index) )
            dataToEncode.remove(at: index)
        }else{print(Date.now)}
            
        dataToEncode.append(data) //add a new day
    }
    
    //Regardless of if the file exists or not, we want to write either just the one val or the updated list to the file
    let enc = JSONEncoder()
    enc.outputFormatting = [.prettyPrinted, .sortedKeys]
    let encodedData = try! enc.encode(dataToEncode)
    try! encodedData.write(to: jsonURL)
}


func LoadData() -> [Day] {
    print("Loading Day Data")
    let dec = JSONDecoder()

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonURL = documentsDirectory.appendingPathComponent("Data.json")
    
    if FileManager.default.fileExists(atPath: jsonURL.path){
        //Regular loading
        let d = try! Data(contentsOf: jsonURL)
        return try! dec.decode(Array<Day>.self, from: d)
    }else {
        //If we try to load and the file doesn't exist, try to initialize data first
        print("Making File")
        let d : Day = Day(date: getFormattedDate(), activities: LoadPreferences())
        SaveData(data: d)
        return [d]
    }

}

func getDay(days: [Day], date: String) -> Day!{//gets the day object associate with a specific date
    for day in days{
        if day.date == date{
            return day
        }
    }
    return nil
}

//Check if the day already exists
func dayExists(days: [Day], date: String) -> Bool{
    for day in days{
        if day.date == date{
            return true
        }
    }
    return false
}

func getIndexToRemove(days: [Day], date: String) -> Int {
    var index = 0
    for day in days{
        if day.date == date{
            return index
        }
        index+=1
    }
    return index
}


func getFormattedDate() -> String{
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let date : String = df.string(from: Date.now) //format date
    
    //https://www.swiftyplace.com/blog/swift-date-formatting-10-steps-guide
    return date
}

#Preview {
    Daily()
}

