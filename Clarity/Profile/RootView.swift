//
//  RootView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//

import SwiftUI
struct RootView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        if authManager.isAuthenticated {
            ContentView(therapist: Therapist(
                name: "Default Therapist",
                description: "A supportive and compassionate guide.",
                fileName: "default_therapist"
            ))
        } else {
            LoginView() // Show login if not authenticated
        }
    }
}
