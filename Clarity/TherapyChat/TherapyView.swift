//
//  TherapyView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//


import SwiftUI

struct TherapyView: View {
    let therapist: Therapist // The selected therapist

    @State private var userMessage: String = "" // User's input
    @State private var chatMessages: [ChatMessage] = [] // Chat messages
    @Environment(\.presentationMode) var presentationMode // Environment variable to handle navigation back

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#000000"),
                    Color(hex: "#1A1A1A")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    // Clarity Logo
                    Text("Clarity")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#0074F7"), Color(hex: "#A26EFF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.bottom, 10)

                    // Therapist Header with Back Button
                    HStack(spacing: 15) {
                        Button(action: {
                            // Go back to HomeView
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }

                        Spacer()

                        Image(therapist.fileName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(therapist.name)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Your Personal Therapist")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                }
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#1A1A1A").opacity(0.9))
                        .shadow(color: Color(hex: "#0074F7").opacity(0.4), radius: 10)
                )
                .padding(.horizontal)

                // Chat Area
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(chatMessages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal)
                .shadow(color: Color(hex: "#0074F7").opacity(0.3), radius: 10)

                // Input Area
                HStack {
                    TextField("Type your message...", text: $userMessage)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#0074F7"))
                            .clipShape(Circle())
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)
                    }

                    Button(action: {
                        // Voice input action
                    }) {
                        Image(systemName: "mic.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#0074F7"))
                            .clipShape(Circle())
                            .shadow(color: Color(hex: "#0074F7").opacity(0.6), radius: 10)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#1A1A1A").opacity(0.9))
                        .shadow(color: Color(hex: "#0074F7").opacity(0.4), radius: 10)
                )
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the default navigation bar back button
        .navigationBarHidden(true) // Hides the entire navigation bar
    }

    // Simulates sending a message
    private func sendMessage() {
        guard !userMessage.isEmpty else { return }

        // Add user message
        let newMessage = ChatMessage(text: userMessage, isFromUser: true)
        chatMessages.append(newMessage)
        userMessage = ""

        // Add therapist response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = therapistResponse()
            let therapistMessage = ChatMessage(text: response, isFromUser: false)
            chatMessages.append(therapistMessage)
        }
    }

    // Generate a response from the therapist
    private func therapistResponse() -> String {
        let responses = [
            "That sounds like a lot to deal with. Let’s break it down together.",
            "I hear you. Can you tell me more about that?",
            "Let’s work through this step by step. What’s on your mind?",
            "That’s a great insight! How do you feel about it?",
            "Thank you for sharing. Let’s explore that further."
        ]
        return responses.randomElement() ?? "I’m here to listen. Please continue."
    }
}

// Chat Bubble View
struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }

            Text(message.text)
                .padding()
                .foregroundColor(message.isFromUser ? .white : .black)
                .background(message.isFromUser ? Color(hex: "#0074F7") : Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)

            if !message.isFromUser {
                Spacer()
            }
        }
        .padding(message.isFromUser ? .leading : .trailing, 60)
    }
}

// Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}

// Preview
struct TherapyView_Previews: PreviewProvider {
    static var previews: some View {
        TherapyView(therapist: Therapist(
            name: "Carlos Hernandez",
            description: "A compassionate listener who creates a safe space to help you feel heard, understood, and supported.",
            fileName: "hispanic_man"
        ))
    }
}
