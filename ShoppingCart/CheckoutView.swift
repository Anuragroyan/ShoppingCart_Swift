//
//  CheckoutView.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartModel: CartModel

    @State private var selectedPaymentMethod = "Credit Card"
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var additionalNote = ""
    @State private var showConfirmation = false

    @State private var isCardValid = false
    @State private var cardType: String? = nil

    let paymentMethods = ["Credit Card", "Debit Card", "UPI", "Cash on Delivery"]

    var body: some View {
        VStack(spacing: 0) {
            Text("🛒 Checkout")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGroupedBackground))

            ScrollView {
                VStack(spacing: 20) {
                    if cartModel.cartItems.isEmpty {
                        EmptyCartView()
                    } else {
                        cartItemsCard
                        paymentMethodCard
                        if selectedPaymentMethod.contains("Card") {
                            cardEntryCard
                        }
                        notesCard
                        totalCard
                        Spacer(minLength: 100)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .overlay(
            VStack {
                Spacer()
                if !cartModel.cartItems.isEmpty {
                    confirmButton
                        .padding()
                        .background(Color(.systemGroupedBackground))
                }
            }, alignment: .bottom
        )
        .alert("✅ Order Placed!", isPresented: $showConfirmation) {
            Button("Awesome!", role: .cancel) { }
        } message: {
            Text("""
            Your order has been placed with **\(selectedPaymentMethod)**.

            We appreciate your business 💙
            """)
        }

    }

    // MARK: - Cards
    private var cartItemsCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Items in Cart").font(.headline)
                ForEach(cartModel.cartItems, id: \.id) { product in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name).fontWeight(.semibold)
                            Text("\(product.quantity) × $\(String(format: "%.2f", product.price))")
                                .font(.caption).foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(String(format: "%.2f", product.totalPrice))").fontWeight(.medium)
                    }
                }
            }
        }
    }

    private var paymentMethodCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Payment Method").font(.headline)
                Picker("Payment Method", selection: $selectedPaymentMethod) {
                    ForEach(paymentMethods, id: \.self) { method in
                        Text(method)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }

    private var cardEntryCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Card Details").font(.headline)

                HStack {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: cardNumber) {
                            cardNumber = formatCardNumber(cardNumber)
                            validateCardNumber(cardNumber)
                        }

                    if let type = cardType {
                        Text(type)
                            .font(.caption)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                HStack(spacing: 16) {
                    TextField("MM/YY", text: $expiryDate)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(.roundedBorder)

                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 4) {
                    if !isCardValid && !cardNumber.isEmpty {
                        Text("❌ Invalid card number").font(.caption).foregroundColor(.red)
                    }
                    if !isExpiryValid(expiryDate) && !expiryDate.isEmpty {
                        Text("❌ Invalid expiry date").font(.caption).foregroundColor(.red)
                    }
                    if !isCVVValid(cvv) && !cvv.isEmpty {
                        Text("❌ Invalid CVV").font(.caption).foregroundColor(.red)
                    }
                }
            }
        }
    }

    private var notesCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Additional Notes").font(.headline)
                TextEditor(text: $additionalNote)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
        }
    }

    private var totalCard: some View {
        CardView {
            HStack {
                Text("Total").font(.title3).fontWeight(.semibold)
                Spacer()
                Text("$\(String(format: "%.2f", cartModel.totalPrice))")
                    .font(.title3)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
    }

    // ✅ Merged Confirm Button with Clear Favorites
    private var confirmButton: some View {
        Button(action: {
            showConfirmation = true
            cartModel.clearCart()
            cartModel.clearFavorites() // ✅ Clear favorites on checkout
            cardNumber = ""
            expiryDate = ""
            cvv = ""
        }) {
            Text("Confirm Order")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isCardEntryValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 4)
        }
        .disabled(!isCardEntryValid)
        .padding(.top)
    }

    // MARK: - Validation Logic
    private func validateCardNumber(_ number: String) {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        let patterns: [String: String] = [
            "Visa": #"^4[0-9]{12}(?:[0-9]{3})?$"#,
            "MasterCard": #"^5[1-5][0-9]{14}$"#,
            "American Express": #"^3[47][0-9]{13}$"#,
            "Discover": #"^6(?:011|5[0-9]{2})[0-9]{12}$"#
        ]
        for (issuer, pattern) in patterns {
            if cleaned.range(of: pattern, options: .regularExpression) != nil {
                isCardValid = true
                cardType = issuer
                return
            }
        }
        isCardValid = false
        cardType = nil
    }

    private func isExpiryValid(_ expiry: String) -> Bool {
        let components = expiry.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]), month >= 1, month <= 12,
              let year = Int(components[1]) else { return false }

        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date()) % 100
        let currentMonth = calendar.component(.month, from: Date())

        return (year > currentYear) || (year == currentYear && month >= currentMonth)
    }

    private func isCVVValid(_ cvv: String) -> Bool {
        let length = cvv.count
        switch cardType {
        case "American Express": return length == 4
        case "Visa", "MasterCard", "Discover": return length == 3
        default: return false
        }
    }

    private func formatCardNumber(_ number: String) -> String {
        let digits = number.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let groups = stride(from: 0, to: digits.count, by: 4).map {
            Array(digits)[$0..<min($0 + 4, digits.count)]
        }
        return groups.map { String($0) }.joined(separator: " ")
    }

    private var isCardEntryValid: Bool {
        if selectedPaymentMethod.contains("Card") {
            return isCardValid && isExpiryValid(expiryDate) && isCVVValid(cvv)
        }
        return true
    }
}

// MARK: - Card Wrapper
struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    NavigationView {
        CheckoutView()
            .environmentObject(CartModel())
    }
}
