//
//  ProductCard.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI

struct ProductCard: View {
    @EnvironmentObject var cartModel: CartModel
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(product.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)

                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)

                    Text("by \(product.manufacturer)")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Text("Warranty: \(product.warranty, specifier: "%.1f") year\(product.warranty > 1 ? "s" : "")")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(String(format: "$%.2f", product.price))
                        .font(.headline)
                        .foregroundColor(.green)

                    Button(action: {
                        cartModel.addProduct(product)
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 2)
                }
            }

            Divider()

            HStack {
                Spacer()
                Button(action: {
                    cartModel.addProduct(product)
                }) {
                    HStack {
                        Image(systemName: "cart")
                        Text("Add to Cart")
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .blue.opacity(0.2), radius: 3, x: 0, y: 2)
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}
