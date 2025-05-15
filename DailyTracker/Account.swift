//
//  Account.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 4/16/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


struct Account: View {
    @StateObject var authManager = AuthManager()

    var body: some View {
        if authManager.isLoggedIn {
            VStack {
                Text("You're signed in!")
                Text("User: " + authManager.user)
                Button("Sign Out") {
                    authManager.signOut()
                }
            }
            .frame(width: 300)
        } else {
            VStack(spacing: 16) {
                Text("Sign in with Google")
                Button("Sign In with Google") {
                    authManager.signInWithGoogle()
                }
            }
            .padding()
            .frame(width: 300)
        }
    }
}


#Preview {
    Account()
}
