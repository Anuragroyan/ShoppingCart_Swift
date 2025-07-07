//
//  EmptyCartMessage.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct EmptyCartMessage: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "cart.badge.minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }

            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Looks like you haven’t added anything yet.\nStart exploring and add items to your cart.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)

            Button(action: {
                selectedTab = 0 // Navigate to Home tab
            }) {
                Text("Start Shopping")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: 240)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }
}
