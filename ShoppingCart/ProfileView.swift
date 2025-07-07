//
//  ProfileView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI

struct ProfileView: View {


    var body: some View {
        VStack(spacing: 30) {
            // Header Image & Greeting
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)

                Text("Hello, Shopper 👋")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("🎉 Welcome to your favorite cart companion! 🛒💫")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }

            // User Details Card
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                    Text("Username:")
                    Spacer()
                    Text("Guest User")
                        .foregroundColor(.secondary)
                }

                Divider()

                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                    Text("Email:")
                    Spacer()
                    Text("guest@gmail.com")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)

            Spacer()

            // 💬 Thank You Note
            VStack(spacing: 10) {
                Text("🙏 Thank you for shopping with us!")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("We’re glad to have you as part of our shopping family. 🛍️❤️")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Logout Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "arrow.backward.circle.fill")
                    Text("Logout")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Profile")
    }
}
