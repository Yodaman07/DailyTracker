//
//  Day.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 4/1/25.
//

import Foundation


struct Day: Codable, Identifiable, Equatable{ //identifiable means we can use a foreach loop and distinguish between different day objects,
    //codable means we can json encode the object
    var id = UUID()
    
    var date: String
    var activities: [DailyItem] = LoadPreferences() //Need to associate these with the day
    
    
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
