//
//  MainView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var cartModel: CartModel
    @State private var selectedTab = 0


    var body: some View {
        TabView(selection: $selectedTab) {
            ProductListView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Products")
                }
                .tag(0)
            
            FavoritesView(selectedTab: $selectedTab)
                .environmentObject(cartModel)
                .tabItem {
                    Image(systemName: "suit.heart.fill")
                    Text("Checkout")
                }
                .tag(1)
                .modifier(FavoriteBadgeModifier(showBadge: true, count: cartModel.favoriteItems.count)) // 🔴 Red badge with count
        
            CartView(selectedTab: $selectedTab)
                .environmentObject(cartModel)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
                .badge(cartModel.cartItems.count) // ✅ Cart count badge
                .tag(2)
            
            CheckoutView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Checkout")    
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(4)
            
            OrderHistoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History")
                }
                .tag(5)
            
        }
    }
}

