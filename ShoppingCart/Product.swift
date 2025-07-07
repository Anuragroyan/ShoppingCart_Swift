//
//  Product.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import SwiftUI

struct Product: Identifiable, Equatable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var price: Double
    var image: String
    var warranty: Double
    var manufacturer: String
    var quantity: Int = 1
    var isFavorite: Bool = false
    
    var totalPrice: Double {
            return price * Double(quantity)
        }
}
