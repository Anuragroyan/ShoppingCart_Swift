//
//  ShoppingCartApp.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import SwiftUI

@main

struct MyApp: App {
    
    // code for badge color of tabview 
    init() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = UIColor.systemTeal
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = UIColor.systemOrange
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    @StateObject var cartModel = CartModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(cartModel)
        }
    }
}
