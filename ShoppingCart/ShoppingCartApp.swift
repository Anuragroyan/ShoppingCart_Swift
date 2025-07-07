//
//  ShoppingCartApp.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct MyApp: App {
    @StateObject var cartModel = CartModel()
    @StateObject var userSession = UserSession()
    
    // code for badge color of tabview
    init() {
        FirebaseApp.configure() // firebase configure
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = UIColor.systemTeal
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = UIColor.systemOrange
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userSession)
                .environmentObject(cartModel)
                
        }
    }
}
