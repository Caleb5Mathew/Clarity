//
//  TherapistSelectionView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/23/24.
//
//
//  TherapistSelectionView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/23/24.
//


import SwiftUI

struct TherapistSelectionView: View {
    
    @State private var selectedGender: String = "Male"
    @State private var currentIndex: Int = 0
    @State private var maleTherapists: [Therapist] = [
        Therapist(name: "David Johnson", description: "Focused on practical problem-solving and actionable strategies to help you achieve your goals effectively.", fileName: "white_man"),
        Therapist(name: "Carlos Hernandez", description: "Provides a safe and welcoming space where you can feel heard and work toward emotional healing.", fileName: "hispanic_man"),
        Therapist(name: "Marcus Bennett", description: "Guides with wisdom and a calm approach to help you navigate complex challenges and find clarity.", fileName: "black_man"),
        Therapist(name: "Akira Sato", description: "Uses mindfulness techniques to help you build self-awareness and improve emotional balance.", fileName: "asian_man")
    ]
    @State private var femaleTherapists: [Therapist] = [
        Therapist(name: "Emily Davis", description: "Helps boost your confidence and supports you in making progress toward your personal growth.", fileName: "white_lady"),
        Therapist(name: "Maria Rodriguez", description: "Encourages mindfulness and reflection to help you gain clarity and emotional stability.", fileName: "hispanic_lady"),
        Therapist(name: "Sophia Jackson", description: "Offers empathetic and understanding care to help you explore your thoughts and feelings.", fileName: "black_lady"),
        Therapist(name: "Yumi Tanaka", description: "Focuses on practical tools and strategies to empower you and achieve meaningful change.", fileName: "asian_lady")
    ]

    var onComplete: (Therapist) -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1A1A1A"),
                    Color(hex: "#000000")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    Text("Pick your Therapist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 15)

                    Text("Who’s the best fit for you?")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                HStack {
                    Button(action: {
                        withAnimation {
                            selectedGender = "Male"
                            currentIndex = 0
                        }
                    }) {
                        Text("Male")
                            .font(.headline)
                            .fontWeight(selectedGender == "Male" ? .bold : .regular)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                selectedGender == "Male" ? Color(hex: "#0074F7") : Color.clear
                            )
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        withAnimation {
                            selectedGender = "Female"
                            currentIndex = 0
                        }
                    }) {
                        Text("Female")
                            .font(.headline)
                            .fontWeight(selectedGender == "Female" ? .bold : .regular)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                selectedGender == "Female" ? Color(hex: "#A26EFF") : Color.clear
                            )
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 20)

                TabView(selection: $currentIndex) {
                    ForEach(0..<currentTherapists.count, id: \.self) { index in
                        TherapistCardView(therapist: currentTherapists[index])
                            .padding(.top, -20) // Scooting the card elements up
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.top, 10) // Slightly reduced padding for better balance

                Spacer()

                Button(action: {
                    withAnimation(.easeOut(duration: 0.6)) {
                        onComplete(currentTherapists[currentIndex])
                    }
                }) {
                    Text("Talk to \(currentTherapists[currentIndex].name)")
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
                        .cornerRadius(20)
                        .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }

    private var currentTherapists: [Therapist] {
        selectedGender == "Male" ? maleTherapists : femaleTherapists
    }
}

struct TherapistCardView: View {
    let therapist: Therapist

    var body: some View {
        VStack(spacing: 10) { // Adjusted spacing for tighter layout
            Image(therapist.fileName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 140)
                .clipShape(Circle())
                .overlay(
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
                )
                .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)

            Text(therapist.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(therapist.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20) // Adjusted padding for consistency
                .padding(.top, 3)
        }
        .padding(.vertical, 8) // Reduced vertical padding for better balance
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10)
        .padding(.horizontal, 25)
    }
}

struct TherapistSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistSelectionView { _ in }
    }
}
