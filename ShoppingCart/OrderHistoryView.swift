//
//  OrderHistoryView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var cartModel: CartModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(cartModel.orderHistory) { order in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "cart.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            Text("Order by \(order.username)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }

                        Divider()

                        ForEach(order.products) { product in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.subheadline)
                                        .bold()
                                    Text("\(product.quantity) \(product.unit)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text("₹\(product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }

                        Divider()

                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.orange)
                            Text(order.cardDetails)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(order.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Spacer()
                            Text("Total: ₹\(order.totalPrice, specifier: "%.2f")")
                                .bold()
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                }
            }
            .padding()
        }
        .navigationTitle("🧾 Order History")
        .background(Color(.systemGroupedBackground))
    }
}


