//
//  LandingView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//
import SwiftUI

struct LandingView: View {
    let therapist: Therapist

    @State private var isAnimating = false
    @State private var navigateToTherapy = false // State to control navigation to TherapyView

    var body: some View {
        NavigationView {
            ZStack {
                // Animated Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#000000"),
                        Color(hex: "#1A1A1A")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 40) {
                    // Header
                    VStack {
                        Text("Welcome to Your")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : -10)
                            .animation(.easeOut(duration: 0.8), value: isAnimating)

                        Text("Journey!")
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
                            .scaleEffect(isAnimating ? 1 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.5), value: isAnimating)

                    }
                    .padding(.top, 50)

                    // Therapist Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "#0074F7"),
                                                Color(hex: "#A26EFF")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color(hex: "#0074F7").opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding()

                        HStack(spacing: 20) {
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
                                        lineWidth: 5
                                    )
                                    .frame(width: 160, height: 160)
                                    .scaleEffect(isAnimating ? 1.1 : 1) // Slightly smaller scale for hover animation
                                    .opacity(isAnimating ? 0.8 : 0.5)
                                    .animation(
                                        Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )

                                Image(therapist.fileName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Hello, I'm \(therapist.name)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Text("Let's begin your personalized journey.")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding()
                    }

                    Spacer()

                    // Start Session Button
                    NavigationLink(destination: HomeView(therapist: therapist), isActive: $navigateToTherapy) {
                        EmptyView()
                    }

                    Button(action: {
                        navigateToTherapy = true
                    }) {
                        Text("Start Session")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "#0074F7"),
                                        Color(hex: "#A26EFF")
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(
                                        Color.white.opacity(0.2),
                                        lineWidth: 1
                                    )
                            )
                            .padding(.horizontal, 30)
                    }
                    .scaleEffect(isAnimating ? 1 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: isAnimating)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
