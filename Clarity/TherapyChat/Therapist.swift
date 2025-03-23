//
//  Therapist.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/24/24.
//
import SwiftUI
import Foundation

struct Therapist: Identifiable, Equatable {
    let id = UUID() // Add a unique identifier
    let name: String
    let description: String
    let fileName: String
}
