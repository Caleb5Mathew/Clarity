//
//  AuthManager.swift
//  Clarity
//
//  Created by Caleb Matthews  on 12/27/24.
//

import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false // Default to not authenticated
}
