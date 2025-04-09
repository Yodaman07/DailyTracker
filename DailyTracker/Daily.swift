//
//  Daily.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/26/25.
//

import SwiftUI

struct Daily: View {
    @State var day : Day
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var showAlert = false;
    var body: some View {
        //TODO Scrollable
        
        VStack{
            
            Text(day.date)
                .bold(true)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
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
        }.onAppear() {
//            print("REFRESHED")
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
        .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
        .toolbar{
            Button("RELOAD"){
                showAlert = true

                
            }.alert(isPresented: $showAlert){
                Alert(title: Text("You are about to reload your activities. This may overwrite your current progress"),
                      primaryButton: .default(Text("Continue")){
                                let allDayData: [Day] = LoadData()
                                let date = getFormattedDate()
                                day = Day(date: date, activities: LoadPreferences()) //update view data
                                SaveData(data: day)
                    
                                },
                      secondaryButton: .cancel())
            }
        }
    
    }
    
}

struct HistoryView: View { //shows a collection of previous views
    @State var d : [Day] = LoadData()
    @State var date = Date()
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var df = DateFormatter()
    @State var currentDay: Day =  Day(date: "0000-00-00", activities: []); //fake day
//    @Environment(\.refresh) private var refresh
    var body: some View {
                NavigationSplitView{
                    VStack{
                        List(d){ dataaa in
                            if (dataaa.date != getFormattedDate()){
                                Button(dataaa.date){
                                    print(dataaa.date)
                                    currentDay = dataaa
                                }.buttonStyle(.plain)
                            }
                        }
                    }

                }detail: {
                    if (currentDay.date == "0000-00-00"){
                        ContentUnavailableView("Please select a previous day to see its data", systemImage: "calendar")
                    }else{
                        
                        //Basically copied from Daily
                        VStack{
                            Text(currentDay.date)
                                .bold(true)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            
                                List($currentDay.activities){ $data in
                                    
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
                                    }
                                }
                            
                        }.background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                        
                    }
                }
    }
}



func getFormattedDate() -> String{
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let date : String = df.string(from: Date.now) //format date
//    return "2025-04-07"
    //https://www.swiftyplace.com/blog/swift-date-formatting-10-steps-guide
    return date
}

#Preview {
//    HistoryView()
    Daily(day:  Day(date: getFormattedDate(), activities: []))
}

