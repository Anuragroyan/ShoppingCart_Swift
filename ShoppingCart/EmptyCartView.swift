//
//  EmptyCartView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "cart.badge.minus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.black.opacity(0.7))

            Text("Your cart is empty")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.black)

            Text("Browse items and add them to your cart to continue.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
    }
}
