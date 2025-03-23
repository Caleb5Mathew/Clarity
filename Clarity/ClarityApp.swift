import SwiftUI

@main
struct ClarityApp: App {
    // AppDelegate for Google Sign-In integration
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthManager() // Authentication manager

    // Onboarding and Therapist State
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") // Persistent onboarding state
    @State private var selectedTherapist: Therapist? = nil // Tracks the selected therapist

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                // Show Onboarding if not completed
                if !hasCompletedOnboarding {
                    OnboardingView { therapist in
                        self.selectedTherapist = therapist
                        self.hasCompletedOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding") // Persist onboarding completion
                    }
                }
                // Show HomeView if therapist is selected
                else if let therapist = selectedTherapist {
                    HomePageView()
                        .environmentObject(authManager) // Pass auth state to views
                }
                // Placeholder if no therapist is selected yet
                else {
                    Text("No therapist selected.")
                        .foregroundColor(.gray)
                }
            } else {
                // Show Google Sign-In first if not authenticated
                HomePageView()
//                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
