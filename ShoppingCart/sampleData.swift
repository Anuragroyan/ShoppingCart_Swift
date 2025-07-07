//
//  sampleData.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import SwiftUI
import Foundation

struct Order: Identifiable, Codable {
    var id: String
    var username: String
    var products: [Products]
    var cardDetails: String
    var totalPrice: Double
    var date: Date
}

struct Products: Identifiable, Codable {
    var id: String
    var name: String
    var price: Double
    var quantity: Int
    var unit: String
}
