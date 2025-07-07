//
//  MainView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var cartModel: CartModel
    @State private var selectedTab = 0
    @State private var isShowingSignup = false

    var body: some View {
        Group {
            contentView // 👈 use computed view with consistent return type
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if userSession.isLoggedIn {
            TabView(selection: $selectedTab) {
                ProductListView()
                    .tabItem {
                        Label("Products", systemImage: "bag")
                    }
                    .tag(0)

                FavoritesView(selectedTab: $selectedTab)
                    .environmentObject(cartModel)
                    .tabItem {
                        Label("Favorites", systemImage: "suit.heart.fill")
                    }
                    .tag(1)
                    .modifier(FavoriteBadgeModifier(
                        showBadge: cartModel.favoriteItems.count > 0,
                        count: cartModel.favoriteItems.count
                    ))

                CartView(selectedTab: $selectedTab)
                    .environmentObject(cartModel)
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
                    .badge(cartModel.cartItems.count)
                    .tag(2)

                CheckoutView()
                    .tabItem {
                        Label("Checkout", systemImage: "creditcard")
                    }
                    .tag(3)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                    .tag(4)
                
                OrderHistoryView()
                    .tabItem {
                        Label("Order History", systemImage: "list.bullet")
                    }
                    .tag(5)
            }
            .onAppear {
                if let uid = userSession.userId {
                    cartModel.userId = uid
                    cartModel.username = userSession.username // ✅ this line ensures username is passed
                    cartModel.loadCartFromFirebase(userId: uid)
                    cartModel.loadFavoritesFromFirebase(userId: uid)
                }
            }
        } else {
            NavigationStack {
                if isShowingSignup {
                    SignupView(isShowingSignup: $isShowingSignup)
                        .environmentObject(cartModel)
                        .environmentObject(userSession)
                } else {
                    LoginView(isShowingSignup: $isShowingSignup)
                        .environmentObject(cartModel)
                        .environmentObject(userSession)
                }
            }
        }
    }
}
