//
//  ContentView.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/21/24.
//
import SwiftUI

struct ContentView: View {
    let therapist: Therapist // Accepts a therapist object to pass into TherapyView

    var body: some View {
        TabView {
            // Therapy Tab
            TherapyView(therapist: therapist) // Pass the therapist object here
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Therapy")
                }

            // Journal Tab
            JournalView() // Your journal view implementation
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
        }
        .accentColor(Color(hex: "#1F5F4E")) // Customize the accent color
    }
}

// Preview with a default therapist for testing
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(therapist: Therapist(
            name: "Default Therapist",
            description: "A supportive and compassionate guide.",
            fileName: "default_therapist"
        ))
    }
}
