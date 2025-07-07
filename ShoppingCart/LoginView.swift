//
//  LoginView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var cartModel: CartModel
    @Binding var isShowingSignup: Bool // ✅ From parent view

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggingIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Welcome Back 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Please sign in to continue.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

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

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: loginUser) {
                    if isLoggingIn {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Login")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .disabled(isLoggingIn)

                // 🔁 Signup toggle button
                Button("Don't have an account? Sign Up") {
                    isShowingSignup = true // ✅ this updates the parent
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
    }

    private func loginUser() {
        errorMessage = ""
        isLoggingIn = true

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoggingIn = false
                if let err = error as NSError? {
                    if err.code == AuthErrorCode.userNotFound.rawValue {
                        // ✅ Toggle to signup screen
                        isShowingSignup = true
                    } else {
                        errorMessage = err.localizedDescription
                    }
                } else if let uid = result?.user.uid {
                    userSession.userId = uid
                    cartModel.userId = uid
                    cartModel.loadCartFromFirebase(userId: uid)
                    cartModel.loadFavoritesFromFirebase(userId: uid)
                }
            }
        }
    }
}
