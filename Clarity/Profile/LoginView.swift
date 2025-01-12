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
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            print("Missing GIDClientID in Info.plist")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.shared.windows.first?.rootViewController!) { user, error in
            if let error = error {
                print("Google Sign-In failed: \(error)")
            } else {
                authManager.isAuthenticated = true
                print("Google Sign-In succeeded: \(user?.profile?.name ?? "No Name")")
            }
        }
    }
}
