//
//  Order.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 05/07/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var items: [Product]
    var total: Double
    var date: Date
    var username: String?
    var paymentMethod: String?
    var cardType: String?
    var cardNumber: String? // Masked, like **** **** **** 1234
}

