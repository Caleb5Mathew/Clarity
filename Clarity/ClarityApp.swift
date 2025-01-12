//
//  ClarityApp.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//

//
//  ClarityApp.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//

import SwiftUI

@main
struct ClarityApp: App {
    @StateObject private var authManager = AuthManager() // Authentication manager
    @State private var hasCompletedOnboarding = false // Tracks if onboarding is completed
    @State private var selectedTherapist: Therapist? = nil // Tracks the selected therapist

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                if let therapist = selectedTherapist {
                    HomeView(therapist: therapist) // Start with HomeView
                        .environmentObject(authManager) // Pass auth state to views
                } else {
                    Text("No therapist selected.") // Placeholder for missing therapist
                }
            } else {
                OnboardingView { therapist in
                    self.selectedTherapist = therapist
                    self.hasCompletedOnboarding = true
                }
            }
        }
    }
}
