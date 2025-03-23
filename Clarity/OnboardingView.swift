//
//  OnboardingView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/22/24.
//

//
//  OnboardingView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/22/24.
//
//
//  OnboardingView.swift
//  Clarity
//
//  Created by Caleb Matthews on 12/22/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [String] = []
    @State private var multiSelectedAnswers: Set<String> = []
    @State private var progress: Double = 0.1
    @State private var showReligionFollowUp = false
    @State private var showTherapistSelection = false

    let questions = [
        "What gender do you identify with?",
        "What age group do you belong to?",
        "What is your relationship status?",
        "How important is religion in your life?",
        "Have you ever been in therapy before?",
        "How would you rate your sleeping habits?",
        "What are your expectations from a therapist?"
    ]

    let answers = [
        ["Male", "Female", "Non-binary", "I'd rather not share"],
        ["18-24", "25-34", "35-44", "45+"],
        ["Single", "In a relationship", "Married", "Divorced", "Widowed", "Other"],
        ["Very important", "Important", "Somewhat important", "Not important at all"],
        ["No", "Yes"],
        ["Good", "Fair", "Poor"],
        ["Listens", "Teaches me new skills", "Guides me to set goals", "Explores my past", "Challenges my beliefs", "I'm not sure", "Other (please specify)"]
    ]

    let religions = [
        "Christianity", "Islam", "Hinduism", "Buddhism", "Judaism", "Sikhism",
        "Atheism", "Agnosticism", "Other"
    ]

    var onComplete: (Therapist) -> Void

    var body: some View {
        if showTherapistSelection {
            TherapistSelectionView { therapist in
                onComplete(therapist)
                showTherapistSelection = false
            }
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#000000"),
                        Color(hex: "#0074F7"),
                        Color(hex: "#A26EFF")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Capsule()
                            .fill(Color(hex: "#00E0FF"))
                            .frame(width: CGFloat(progress * UIScreen.main.bounds.width), height: 4)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer()

                    if showReligionFollowUp {
                        religionFollowUpView()
                    } else {
                        questionView()
                    }

                    Spacer()

                    Button(action: {
                        onComplete(defaultTherapist)
                    }) {
                        HStack {
                            Spacer()
                            Text("Skip Personalization >")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
    }

    let defaultTherapist = Therapist(
        name: "Default Therapist",
        description: "A general therapist ready to assist you.",
        fileName: "default_therapist"
    )

    @ViewBuilder
    private func questionView() -> some View {
        VStack {
            Text(questions[currentQuestionIndex])
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()

            if currentQuestionIndex == 6 {
                ForEach(answers[currentQuestionIndex], id: \.self) { answer in
                    Button(action: {
                        toggleMultiSelect(answer)
                    }) {
                        HStack {
                            Text(answer)
                            Spacer()
                            if multiSelectedAnswers.contains(answer) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                        .background(
                            multiSelectedAnswers.contains(answer) ?
                            Color.white.opacity(0.2) : Color.white.opacity(0.1)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                    }
                }
                Spacer()
                Button(action: {
                    handleMultiSelectContinue()
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#0074F7"))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                }
            } else {
                ForEach(answers[currentQuestionIndex], id: \.self) { answer in
                    Button(action: {
                        handleAnswerSelection(answer)
                    }) {
                        Text(answer)
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func religionFollowUpView() -> some View {
        VStack {
            Text("Which religion do you follow?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            ForEach(religions, id: \.self) { religion in
                Button(action: {
                    handleReligionSelection(religion)
                }) {
                    Text(religion)
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                }
            }
        }
    }

    private func handleAnswerSelection(_ answer: String) {
        if currentQuestionIndex == 3 && (answer == "Very important" || answer == "Important") {
            showReligionFollowUp = true
        } else {
            selectedAnswers.append(answer)
            moveToNextQuestion()
        }
    }

    private func toggleMultiSelect(_ answer: String) {
        if multiSelectedAnswers.contains(answer) {
            multiSelectedAnswers.remove(answer)
        } else {
            multiSelectedAnswers.insert(answer)
        }
    }

    private func handleMultiSelectContinue() {
        selectedAnswers.append(contentsOf: multiSelectedAnswers)
        moveToNextQuestion()
    }

    private func handleReligionSelection(_ religion: String) {
        selectedAnswers.append(religion)
        showReligionFollowUp = false
        moveToNextQuestion()
    }

    private func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            progress += 1.0 / Double(questions.count)
        } else {
            showTherapistSelection = true
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
