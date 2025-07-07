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
        VStack {
            if cartModel.orderHistory.isEmpty {
                Spacer()
                Text("You have no past orders.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(cartModel.orderHistory) { order in
                        Section(
                            header: VStack(alignment: .leading, spacing: 4) {
                                Text(order.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.headline)

                                if let username = order.username {
                                    Text("Ordered by: \(username)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                if let method = order.paymentMethod {
                                    Text("Payment: \(method)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }

                                if let card = order.cardType, let masked = order.cardNumber {
                                    Text("\(card) •••• \(masked.suffix(4))")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                        ) {
                            ForEach(order.items) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .fontWeight(.medium)
                                        Text("Qty: \(item.quantity)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(String(format: "$%.2f", item.totalPrice))
                                }
                            }

                            HStack {
                                Spacer()
                                Text("Total: \(String(format: "$%.2f", order.total))")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("🧾 Order History")
        .onAppear {
            cartModel.fetchOrderHistory()
        }
    }
}
