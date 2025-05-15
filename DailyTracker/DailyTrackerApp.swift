//
//  DailyTrackerApp.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 3/24/25.
//

import SwiftUI
//import FirebaseCore
import Firebase
import AppKit


class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
    }
    
}



@main
struct DailyTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}




