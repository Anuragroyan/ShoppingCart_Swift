//
//  FavouriteView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var cartModel: CartModel
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            if cartModel.favoriteItems.isEmpty {
                EmptyFavoritesView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cartModel.favoriteItems, id: \.id) { product in
                            FavoriteCard(product: product)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("❤️ Favorites")
    }
}

struct FavoriteCard: View {
    let product: Product

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "bag.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue.opacity(0.8))
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "heart.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.gray)

            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap the heart icon on any product to save it to your favorites.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
    }
}


struct FavoriteBadgeModifier: ViewModifier {
    let showBadge: Bool
    let count: Int

    func body(content: Content) -> some View {
            if count == 1 {
                content.badge("") // Red dot
            } else if count > 1 {
                content.badge(count) // Numeric badge
            } else {
                content
            }
        }
    }
