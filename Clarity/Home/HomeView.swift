//
//  HomeView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//

//
//  HomeView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager // Access auth state
    @State private var selectedTherapist: Therapist? // Store the selected therapist
    @State private var navigateToTherapy = false // State to trigger navigation
    @State private var showLoginModal = false // State to show login modal
    @State private var navigateToProfile = false // State to navigate to ProfileView

    let therapist: Therapist?

    init(therapist: Therapist? = nil) {
        self.therapist = therapist
        _selectedTherapist = State(initialValue: therapist) // Initialize selectedTherapist
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#000000"), Color(hex: "#1A1A1A")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    // Header Section with Profile Icon
                    HStack {
                        Spacer()

                        // Profile Button
                        Button(action: {
                            if authManager.isAuthenticated {
                                navigateToProfile = true // Go to profile if authenticated
                            } else {
                                showLoginModal = true // Show login if not authenticated
                            }
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.gray.opacity(0.8), Color.white.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .background(
                            NavigationLink(
                                destination: ProfileView(),
                                isActive: $navigateToProfile,
                                label: { EmptyView() }
                            )
                        )
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 10)

                    // Welcome Section
                    VStack {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#0074F7"), Color(hex: "#A26EFF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10, x: 0, y: 5)

                        Text("How can we help you today?")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    // Therapist Selection Section
                    VStack(spacing: 20) {
                        Text("Choose Your Therapist")
                            .font(.headline)
                            .foregroundColor(.white)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(sampleTherapists) { therapist in
                                    TherapistCard(
                                        therapist: therapist,
                                        isSelected: selectedTherapist == therapist
                                    ) {
                                        selectedTherapist = therapist // Set the selected therapist
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer()

                    // Start Therapy Button
                    NavigationLink(
                        destination: TherapyView(therapist: selectedTherapist ?? sampleTherapists.first!),
                        isActive: $navigateToTherapy
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        if selectedTherapist != nil {
                            navigateToTherapy = true // Trigger navigation
                        }
                    }) {
                        Text(selectedTherapist == nil ? "Select a Therapist First" : "Start Therapy")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: selectedTherapist == nil
                                                       ? [Color.gray, Color.gray]
                                                       : [Color(hex: "#0074F7"), Color(hex: "#A26EFF")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .disabled(selectedTherapist == nil) // Disable button if no therapist selected
                }
                .padding(.top, 50)
            }
            .sheet(isPresented: $showLoginModal) {
                LoginView() // Display login modal if not authenticated
                    .environmentObject(authManager)
            }
        }
        .navigationBarHidden(true)
    }
}

// Therapist Card Component
struct TherapistCard: View {
    let therapist: Therapist
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        VStack {
            Image(therapist.fileName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            isSelected
                                ? LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#0074F7"), Color(hex: "#A26EFF")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                            lineWidth: 4
                        )
                )
                .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)

            Text(therapist.name)
                .font(.headline)
                .foregroundColor(.white)

            Button(action: onSelect) {
                Text(isSelected ? "Selected" : "Select")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(5)
                    .frame(width: 80)
                    .background(isSelected ? Color(hex: "#0074F7") : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 5)
        }
    }
}

// Sample Therapists
let sampleTherapists = [
    Therapist(name: "David Johnson", description: "Focuses on practical problem-solving.", fileName: "white_man"),
    Therapist(name: "Carlos Hernandez", description: "Provides a safe and welcoming space.", fileName: "hispanic_man"),
    Therapist(name: "Sophia Jackson", description: "Offers empathetic care for growth.", fileName: "black_lady"),
    Therapist(name: "Yumi Tanaka", description: "Empowers you with mindfulness techniques.", fileName: "asian_lady")
]

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthManager()) // Inject auth state for preview
    }
}
