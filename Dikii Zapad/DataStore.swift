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
    var userDeliveryLocation: UserDeliveryLocationModel? = nil
    var name: String? = nil
    var phoneNumber: String? = nil
    
    var timeDelivery: String? = nil
    var outSideOrder = false
    
    var searchCity: String? = "Новошахтинск "

    ///All category
    var allCategories: [Category] = []
    ///All products
    var allProducts: [Product] = []
    var cartViewModel: CartViewModel = CartViewModel()
    
    static let shared = DataStore()
    private init() {}
}
