//
//  AppView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var isShowingSignup = false

    var body: some View {
        Group {
            if userSession.userId == nil {
                NavigationStack {
                    if isShowingSignup {
                        SignupView(isShowingSignup: $isShowingSignup)
                    } else {
                        LoginView(isShowingSignup: $isShowingSignup)
                    }
                }
            } else {
                MainTabView()
            }
        }
    }
}
