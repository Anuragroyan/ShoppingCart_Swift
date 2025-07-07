//
//  UserSession.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserSession: ObservableObject {
    @Published var userId: String? = nil
    @Published var username: String? = nil
    @Published var email: String? = nil

    var isLoggedIn: Bool {
        userId != nil
    }

    // Automatically load session on app launch
    init() {
        loadUserSession()
    }

    // MARK: - Load user session if already signed in
    func loadUserSession() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            self.email = user.email
            self.username = user.displayName ?? nil // Optional fallback
            fetchUsernameFromFirestore(userId: user.uid)
        }
    }

    private func fetchUsernameFromFirestore(userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data(), let fetchedUsername = data["username"] as? String {
                DispatchQueue.main.async {
                    self.username = fetchedUsername
                }
            }
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                DispatchQueue.main.async {
                    self.userId = user.uid
                    self.email = user.email
                    self.username = user.displayName
                }
                self.fetchUsernameFromFirestore(userId: user.uid)
            }
            completion(error)
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { profileError in
                    // Save username to Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "username": username,
                        "email": email
                    ], merge: true)

                    DispatchQueue.main.async {
                        self.userId = user.uid
                        self.email = email
                        self.username = username
                    }

                    completion(profileError ?? error)
                }
            } else {
                completion(error)
            }
        }
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            userId = nil
            username = nil
            email = nil
        } catch {
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
}
