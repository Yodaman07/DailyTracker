//
//  JsonHandling.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 4/1/25.
//

import Foundation

//The first 2 methods are used in the daily view, the other 2 are used in the settings view

func SaveData(data: Day){ //saving data from scratch

//    print(String(data: encodedData, encoding: .utf8)!)
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let jsonURL = documentsDirectory.appendingPathComponent("Data.json")
    var dataToEncode : [Day] = [data]
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Data.json")
    

    if FileManager.default.fileExists(atPath: jsonURL.path){
        //If the file exists, get all of its data, and add a new Day element
        dataToEncode = LoadData() // all data
        //Need to remove the old element with the same name
        if dayExists(days: dataToEncode, date: data.date){
            let index = getIndexToRemove(days: dataToEncode, date: data.date)
            print("Updating data at index " + String(index) )
            dataToEncode.remove(at: index)
            dataToEncode.insert(data, at: index) //add a new day
        }else{
            //Day doesn't exist
            print(Date.now)
            dataToEncode.append(data)
        }
    }
    print("SUCCESS")
    
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

func SavePreferences(data: [DailyItem]){
    let enc = JSONEncoder()
    enc.outputFormatting = .prettyPrinted
    let data = try! enc.encode(data)
    print(String(data: data, encoding: .utf8)!)
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Preferences.json")
    
    try! data.write(to: jsonURL)
}

func LoadPreferences() -> [DailyItem] {
    print("Loading Preferences")
    let dec = JSONDecoder()
    let jsonURL = URL.documentsDirectory.appendingPathComponent("Preferences.json")
    if FileManager.default.fileExists(atPath: jsonURL.path){
        
        let d = try! Data(contentsOf: jsonURL)
        return try! dec.decode(Array<DailyItem>.self, from: d)
    }else{
        let item = [DailyItem(activity: "New Activity", goal: false)]
        SavePreferences(data: item)
        return item
    }
}
