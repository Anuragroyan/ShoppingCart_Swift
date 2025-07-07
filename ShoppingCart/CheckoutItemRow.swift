//
//  CheckoutItemRow.swift
//  ShoppingCart
//
//  Created by Dungeon_master on 04/07/25.
//

import SwiftUI

struct CheckoutItemRow: View {
    let product: Product

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.body)
                    .fontWeight(.medium)

                Text("\(product.quantity) × $\(String(format: "%.2f", product.price))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("$\(String(format: "%.2f", product.totalPrice))")
                .font(.body)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}
