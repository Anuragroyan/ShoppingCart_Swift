//
//  ProductListView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 03/07/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProductListView: View {
    @EnvironmentObject var cartModel: CartModel
    @State private var searchText: String = ""
    @State private var products: [Product] = []
    @State private var isLoading = true

    // Sample fallback products
    let sampleProducts = [
        Product(name: "Macbook Air m2", price: 1999.99, image: "Macm2air", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Macbook Pro m3", price: 1999.99, image: "Macm3pro", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "iPhone 16", price: 999.99, image: "Iphone14", warranty: 1, manufacturer: "Make in India"),
        Product(name: "iPhone 15", price: 999.99, image: "Iphone14", warranty: 1.5, manufacturer: "Make in India"),
        Product(name: "AirPods Pro", price: 999.99, image: "Airpodpro3", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "iPad Pro 13", price: 699.99, image: "Ipadpro3", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Asus Zephyrus G14", price: 3999.99, image: "AsusZephyrus", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "Asus TUF A15", price: 1999.99, image: "AsusTuF", warranty: 2.5, manufacturer: "Make in India"),
        Product(name: "OnePlus 7", price: 699.99, image: "Oneplus7", warranty: 1.4, manufacturer: "Make in India"),
    ]

    var filteredProducts: [Product] {
        let list = products.isEmpty ? sampleProducts : products
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 Search Bar
                searchBar

                if isLoading {
                    ProgressView("Loading products...")
                        .padding()
                } else {
                    productList
                }
            }
            .navigationTitle("🛍️ Products")
            .onAppear(perform: loadProductsFromFirebase)
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search products...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }

    // MARK: - Product List
    private var productList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(filteredProducts) { product in
                    ProductCard(product: product)
                        .environmentObject(cartModel)
                }

                if filteredProducts.isEmpty {
                    Text("No matching products found.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.top)
        }
    }

    // MARK: - Firebase Loader
    private func loadProductsFromFirebase() {
        let db = Firestore.firestore()
        db.collection("products").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let documents = snapshot?.documents {
                    self.products = documents.compactMap {
                        try? $0.data(as: Product.self)
                    }
                }
                self.isLoading = false
            }
        }
    }
}
