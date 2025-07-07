//
//  CartModel.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine

class CartModel: ObservableObject {
    @Published var cartItems: [Product] = []
    @Published var favoriteItems: [Product] = []
    @Published var username: String?
    @Published var userId: String?
    @Published var orderHistory: [Order] = []
    
    private let db = Firestore.firestore()
    
    // MARK: - Init
    init() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            self.username = user.displayName ?? user.email?.components(separatedBy: "@").first ?? "Guest"
        }
    }
    
    // MARK: - Cart Operations
    
    func addProduct(_ product: Product) {
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
    
    // MARK: - Favorite Operations
    
    func toggleFavorite(for product: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[index].isFavorite.toggle()
        }
        
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
    
    // MARK: - Firebase Save
    
    func saveCartToFirebase(userId: String) {
        do {
            let cartData = try cartItems.map { try Firestore.Encoder().encode($0) }
            db.collection("users").document(userId).setData(["cart": cartData], merge: true)
        } catch {
            print("Error encoding cart: \(error)")
        }
    }
    
    func saveFavoritesToFirebase(userId: String) {
        do {
            let favoritesData = try favoriteItems.map { try Firestore.Encoder().encode($0) }
            db.collection("users").document(userId).setData(["favorites": favoritesData], merge: true)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
    
    // MARK: - Firebase Load
    
    func loadCartFromFirebase(userId: String) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error loading cart: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(),
                  let cartArray = data["cart"] as? [[String: Any]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: cartArray, options: [])
                let decoded = try JSONDecoder().decode([Product].self, from: jsonData)
                DispatchQueue.main.async {
                    self.cartItems = decoded
                }
            } catch {
                print("Cart decoding error: \(error)")
            }
        }
    }
    
    func loadFavoritesFromFirebase(userId: String) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error loading favorites: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(),
                  let favArray = data["favorites"] as? [[String: Any]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: favArray, options: [])
                let decoded = try JSONDecoder().decode([Product].self, from: jsonData)
                DispatchQueue.main.async {
                    self.favoriteItems = decoded
                }
            } catch {
                print("Favorites decoding error: \(error)")
            }
        }
    }
    
    // MARK: - Save Order
    
    func saveCartToFirebase() {
        guard let userId = userId else {
            print("❌ No user ID available.")
            return
        }
        
        let itemsData: [[String: Any]] = cartItems.map { item in
            return [
                "id": item.id,
                "name": item.name,
                "price": item.price,
                "quantity": item.quantity,
                "image": item.image,
                "warranty": item.warranty,
                "manufacturer": item.manufacturer,
                "isFavorite": item.isFavorite
            ]
        }
        
        print("📦 Saving cart items: \(itemsData)")
        
        db.collection("users")
            .document(userId)
            .setData(["cart": itemsData], merge: true) { error in
                if let error = error {
                    print("❌ Failed to save cart: \(error.localizedDescription)")
                } else {
                    print("✅ Cart saved successfully.")
                }
            }
    }
    
    
    func saveOrderToFirebase(paymentMethod: String, cardType: String?, maskedCardNumber: String?) {
        guard let userId = userId else {
            print("❌ No user ID available.")
            return
        }
        
        guard !cartItems.isEmpty else {
            print("❌ Cart is empty. Nothing to save.")
            return
        }
        
        let itemsData: [[String: Any]] = cartItems.map { item in
            return [
                "id": item.id,
                "name": item.name,
                "price": item.price,
                "quantity": item.quantity,
                "image": item.image,
                "warranty": item.warranty,
                "manufacturer": item.manufacturer,
                "isFavorite": item.isFavorite
            ]
        }
        
        var order: [String: Any] = [
            "items": itemsData,
            "total": totalPrice,
            "date": Timestamp(date: Date()),
            "username": username ?? "Guest",
            "paymentMethod": paymentMethod
        ]
        
        if let cardType = cardType {
            order["cardType"] = cardType
        }
        
        if let masked = maskedCardNumber {
            order["cardNumber"] = masked
        }
        
        print("📝 Saving order: \(order)")
        
        db.collection("users")
            .document(userId)
            .collection("orders")
            .addDocument(data: order) { error in
                if let error = error {
                    print("❌ Failed to save order: \(error.localizedDescription)")
                } else {
                    print("✅ Order saved successfully.")
                }
            }
    }
    
    
    // MARK: - Fetch Orders
    func fetchOrderHistory() {
        guard let userId = userId else {
            print("❌ No user ID available.")
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("orders")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching orders: \(error.localizedDescription)")
                    self.orderHistory = []
                    return
                }
                
                guard let docs = snapshot?.documents else {
                    print("⚠️ No order documents found.")
                    self.orderHistory = []
                    return
                }
                
                self.orderHistory = docs.compactMap { doc in
                    try? doc.data(as: Order.self)
                }
                
                print("📖 Loaded \(self.orderHistory.count) orders.")
            }
    }
}

