//
//  ProductListView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var cartModel: CartModel
    @State private var searchText: String = ""

    let sampleProducts = [
        Product(name: "Macbook Air m2", price: 1999.99, image: "Macm2air", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Macbook pro m3", price: 1999.99,  image: "Macm3pro" ,warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "iphone 16", price: 999.99, image: "Iphone14" ,warranty: 1, manufacturer: "Make in India"),
        Product(name: "iphone 15", price: 999.99, image: "Iphone14" ,warranty: 1.5, manufacturer: "Make in India"),
        Product(name: "Airpod pro", price: 999.99,image: "Airpodpro3" ,warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Ipad pro 13", price: 699.99, image: "Ipadpro3" ,warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Asus Zephyrus g14", price: 3999.99,image: "AsusZephyrus"  ,warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Asus TUF Gaming A15", price: 1999.99, image: "AsusTuF" ,warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "OnePlus 7", price: 699.99, image: "Oneplus7" ,warranty: 1.4, manufacturer: "Make in India"),
    ]

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return sampleProducts
        } else {
            return sampleProducts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search products...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding([.top, .horizontal])

            // Product List
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(filteredProducts) { product in
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

                    if filteredProducts.isEmpty {
                        Text("No matching products found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top)

            }
        }
    }
}
