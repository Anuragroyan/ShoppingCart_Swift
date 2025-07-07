//
//  SignupView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var cartModel: CartModel
    @Binding var isShowingSignup: Bool
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isSigningUp = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account 👤")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Sign up to get started.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Form fields
                    Group {
                        TextField("Username", text: $username)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Sign Up button
                    Button(action: signUpUser) {
                        Group {
                            if isSigningUp {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSigningUp ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isSigningUp)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Sign Up")
        }
    }

    private func signUpUser() {
        errorMessage = ""
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isSigningUp = true

        userSession.signUp(email: email, password: password, username: username) { error in
            DispatchQueue.main.async {
                isSigningUp = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    // Success — dismiss signup view
                    isShowingSignup = false
                }
            }
        }
    }
}
