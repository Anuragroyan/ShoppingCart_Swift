//
//  CartView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartModel: CartModel
    @EnvironmentObject var userSession: UserSession // ✅ Add this
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 0) {
            Text("🛒 Your Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.horizontal)

            if cartModel.cartItems.isEmpty {
                EmptyCartMessage(selectedTab: $selectedTab)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    List {
                        ForEach(Array(cartModel.cartItems.enumerated()), id: \.element.id) { index, product in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(product.name)
                                            .font(.headline)
                                        Text(String(format: "$%.2f each", product.price))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Button(action: {
                                        cartModel.toggleFavorite(for: product)
                                        if let uid = userSession.userId {
                                            cartModel.saveFavoritesToFirebase(userId: uid) // ✅ Save with userId
                                        }
                                    }) {
                                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(product.isFavorite ? .red : .gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    Button(action: {
                                        cartModel.removeProduct(at: index)
                                        if let uid = userSession.userId {
                                            cartModel.saveCartToFirebase(userId: uid) // ✅ Save with userId
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }

                                Stepper("Quantity: \(product.quantity)",
                                        value: $cartModel.cartItems[index].quantity,
                                        in: 1...99,
                                        onEditingChanged: { _ in
                                            if let uid = userSession.userId {
                                                cartModel.saveCartToFirebase(userId: uid) // ✅ Save with userId
                                            }
                                        })
                                .font(.subheadline)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)

                    Divider()

                    HStack {
                        Text("Total")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Spacer()

                        Text(String(format: "$%.2f", cartModel.totalPrice))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let uid = userSession.userId {
                cartModel.loadCartFromFirebase(userId: uid)      // ✅ Load with userId
                cartModel.loadFavoritesFromFirebase(userId: uid) // ✅ Load with userId
            }
        }
    }
}
