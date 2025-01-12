//
//  JournalView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//


import SwiftUI

struct JournalView: View {
    @State private var isRecording = false

    var body: some View {
        VStack {
            Text("Record Your Daily Journal")
                .font(.title)
                .foregroundColor(Color("#D4DDE1"))
            Button(action: {
                isRecording.toggle()
                provideHapticFeedback()
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .font(.headline)
                    .padding()
                    .background(Color("#F8C471"))
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .background(Color("#0B1E30").ignoresSafeArea())
    }

    private func provideHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(isRecording ? .success : .warning)
    }
}
