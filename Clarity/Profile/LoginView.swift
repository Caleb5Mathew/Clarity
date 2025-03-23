//
//  LoginView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//


import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#1A1A1A"), Color(hex: "#000000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Welcome to Clarity")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Button(action: handleGoogleSignIn) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Sign in with Google")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    func handleGoogleSignIn() {
        // Load GIDClientID from credentials.plist instead of Info.plist
        guard let path = Bundle.main.path(forResource: "credentials", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let clientID = dict["GIDClientID"] as? String else {
            print("[ERROR] Failed to load GIDClientID from credentials.plist")
            return
        }

        // Use the loaded GIDClientID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.windows.first!.rootViewController!) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error)")
                return
            }

            guard let user = result?.user else {
                print("Google Sign-In: No user information found.")
                return
            }

            authManager.isAuthenticated = true
            print("Google Sign-In succeeded: \(user.profile?.name ?? "No Name")")

            if let error = error {
                print("Google Sign-In failed: \(error)")
            } else {
                authManager.isAuthenticated = true
                if let profile = user.profile {
                    print("Google Sign-In succeeded: \(profile.name ?? "No Name")")
                } else {
                    print("Google Sign-In succeeded, but no profile information found.")
                }
            }
        }
    }


}
