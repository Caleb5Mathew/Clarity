//
//  ProfileView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode // For navigation back

    var body: some View {
        NavigationView {
            ZStack {
                // Solid Blackish Background
                Color(hex: "#121212")
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Navigate back to HomeView
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#0074F7"),
                                            Color(hex: "#A26EFF")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        Spacer()

                        Text("Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        // Symmetry placeholder for alignment
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .opacity(0)
                    }
                    .padding()
                    .background(Color(hex: "#121212")) // Sleek and blending top bar
                    .cornerRadius(10)

                    // Profile Section
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#0074F7"),
                                            Color(hex: "#A26EFF")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 4
                                )
                                .frame(width: 110, height: 110)

                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .overlay(
                                    Button(action: {
                                        // Open photo picker or edit action
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                            .background(Color(hex: "#121212"))
                                            .clipShape(Circle())
                                            .offset(x: 30, y: 30)
                                    }
                                )
                        }

                        Text("User Name")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        Text("user@example.com")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 20)
                    .background(
                        Color(hex: "#121212") // Matches the background for seamless integration
                            .cornerRadius(15)
                    )
                    .padding(.horizontal)

                    // Options Section
                    VStack(spacing: 10) {
                        ProfileOptionRow(iconName: "gearshape.fill", title: "Account Settings")
                        Divider().background(Color.gray.opacity(0.3))
                        ProfileOptionRow(iconName: "bell.fill", title: "Notifications")
                        Divider().background(Color.gray.opacity(0.3))
                        ProfileOptionRow(iconName: "lock.fill", title: "Privacy Policy")
                        Divider().background(Color.gray.opacity(0.3))
                        ProfileOptionRow(iconName: "questionmark.circle.fill", title: "Help & Support")
                    }
                    .padding(.horizontal)

                    // Logout Button
                    Button(action: {
                        // Logout action
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                Color(hex: "#1A1A1A")
                                    .opacity(0.8)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.red.opacity(0.8), lineWidth: 1.5)
                                    )
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer()
                }
                .padding(.top, 10)
            }
        }
        .navigationBarHidden(true)
    }
}

// Profile Option Row Component
struct ProfileOptionRow: View {
    let iconName: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#0074F7"),
                            Color(hex: "#A26EFF")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 30, height: 30)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            Color(hex: "#121212").opacity(0.6)
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
