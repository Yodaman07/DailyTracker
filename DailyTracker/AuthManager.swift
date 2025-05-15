//
//  AuthManager.swift
//  DailyTracker
//
//  Created by Ayaan Irshad on 4/16/25.
//


import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user = ""

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }

    func signInWithGoogle() {
        //https://firebase.google.com/docs/auth/ios/google-signin?authuser=0&hl=en
        //Courtesy of firebase docs, chatgpt some stack overflow threads and me debugging
        //Make sure to have keychain sharing enabled and Incoming/Outgoing connections set to true in the capabilities section
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing client ID")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let presentingWindow = NSApplication.shared.windows.first else {
            print("No presenting window")
            return
        }


        GIDSignIn.sharedInstance.signIn(withPresenting: presentingWindow) { signInResult, error in
            guard error == nil else {
                print("Google Sign-In failed: \(error!.localizedDescription)")
                return
            }

            guard let user = signInResult?.user else {
                print("No user object from Google Sign-In")
                return
            }

            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    print("Firebase sign-in error: \(error!.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.user = self.getUserData()
                }
            }
            
        }
    }




    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
    
    func getUserData() -> String{
        var email = ""
        if Auth.auth().currentUser != nil{
            if let user = Auth.auth().currentUser{
                email = user.email!
            }
        }
        return email
    }
}
