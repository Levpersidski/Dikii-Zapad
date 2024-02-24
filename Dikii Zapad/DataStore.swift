//
//  DataStore.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit

struct AdditiveProduct {
    let name: String
    let price: Int
    var selected: Bool = false
}

class DataStore {
    var street: String = "" // to do userDefaults
    var numberHouse: String = "" // to do userDefaults
    var phoneNumber: String? = nil
    
    var timeDelivery: String? = nil
    var outSideOrder = true

    ///All category
    var allCategories: [Category] = []
    ///All products
    var allProducts: [Product] = []
    var cartViewModel: CartViewModel = CartViewModel()
    
    static let shared = DataStore()
    private init() {}
}
