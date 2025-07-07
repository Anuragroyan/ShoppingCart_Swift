//
//  CartModel.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import Foundation
import Combine

class CartModel: ObservableObject {
    @Published var cartItems: [Product] = []
    @Published var favoriteItems: [Product] = [] // All items (not just in cart)
    @Published var orderHistory: [Order] = [] // all item for order
    
    
    init() {
          loadDummyOrderHistory()
      }
    
    func loadDummyOrderHistory() {
        let sampleProducts1 = [
            Products(id: UUID().uuidString, name: "Macbook Air m2", price: 3999, quantity: 2, unit: "kg"),
            Products(id: UUID().uuidString, name: "Macbook Air m3", price: 4999, quantity: 4, unit: "Kg")
        ]
        
        let sampleProducts2 = [
            Products(id: UUID().uuidString, name: "Iphone 16e", price: 299, quantity: 3, unit: "grams"),
            Products(id: UUID().uuidString, name: "Iphone 16 pro", price: 499, quantity: 2, unit: "grams")
        ]
        
        let dummyOrders = [
            Order(
                id: UUID().uuidString,
                username: "Anurag Roy",
                products: sampleProducts1,
                cardDetails: "**** **** **** 1234",
                totalPrice: 110,
                date: Date()
            ),
            Order(
                id: UUID().uuidString,
                username: "Anurag Roy",
                products: sampleProducts2,
                cardDetails: "**** **** **** 5678",
                totalPrice: 85,
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            )
        ]
        self.orderHistory = dummyOrders
    }
    
    func addProduct(_ product: Product) {
        // If item already in cart, increase quantity
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(product)
        }
    }
    
    func removeProduct(at index: Int) {
        guard index < cartItems.count else { return }
        cartItems.remove(at: index)
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    func toggleFavorite(for product: Product) {
        // Update in cart
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[index].isFavorite.toggle()
        }
        
        // Add or remove from favorites
        if let favIndex = favoriteItems.firstIndex(where: { $0.id == product.id }) {
            favoriteItems.remove(at: favIndex)
        } else {
            var favProduct = product
            favProduct.isFavorite = true
            favoriteItems.append(favProduct)
        }
    }
    
    func clearFavorites() {
        for index in favoriteItems.indices {
            favoriteItems[index].isFavorite = false
        }
        favoriteItems.removeAll()
    }
    
    func fetchOrderHistory(for userId: String) {
        let sampleProducts1 = [
            Products(id: UUID().uuidString, name: "Macbook Air m2", price: 3999, quantity: 2, unit: "kg"),
            Products(id: UUID().uuidString, name: "Macbook Air m3", price: 4999, quantity: 4, unit: "Kg")
        ]
        
        let sampleProducts2 = [
            Products(id: UUID().uuidString, name: "Iphone 16e", price: 299, quantity: 3, unit: "grams"),
            Products(id: UUID().uuidString, name: "Iphone 16 pro", price: 499, quantity: 2, unit: "grams")
        ]
        
        let dummyOrders = [
            Order(
                id: UUID().uuidString,
                username: "Anurag Roy",
                products: sampleProducts1,
                cardDetails: "**** **** **** 1234",
                totalPrice: 110,
                date: Date()
            ),
            Order(
                id: UUID().uuidString,
                username: "Anurag Roy",
                products: sampleProducts2,
                cardDetails: "**** **** **** 5678",
                totalPrice: 85,
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            )
        ]
        self.orderHistory = dummyOrders
        self.orderHistory = dummyOrders
    }

    
}
