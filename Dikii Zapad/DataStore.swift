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

struct UserOrder: Codable {
    let date: Date
    let number: String
    let text: String
    let allSum: String
    let adress: String?
    let sumDelyvery: String?
}

class DataStore {
    static let allowedSecondsInBackground: Double = 10 * 60.0
    var devMode: Bool = false //При включенном дев моде показываем черновики товаров
    
    var allCategories: [Category] = []
    var allProducts: [Product] = []
    var promotionURLs: [String] = []
    
    let secretToken = "0f2087abd0760c7faf0f67c0770d5a9081885394f7ad76c7cd0975e88d96fd41"
    
    var generalSettings: GeneralSettings?
    var searchCity: String? {
        get {
            generalSettings?.deliveryInfo.searchLocation
        }
    }
    
    var userDeliveryLocation: UserDeliveryLocationModel? {
        get {
            let addressUserDeliveryLocation = UserDefaults.standard.string(forKey: "addressUserDeliveryLocation")
            let hasSaleUserDeliveryLocation =  UserDefaults.standard.bool(forKey: "isUserNotWantedPushes")
            let priceDeliveryUserDeliveryLocation = UserDefaults.standard.integer(forKey: "priceDeliveryUserDeliveryLocation")
      
            if let address = addressUserDeliveryLocation {
                return UserDeliveryLocationModel(address: address,
                                                 hasSale: hasSaleUserDeliveryLocation,
                                                 priceDelivery: priceDeliveryUserDeliveryLocation)
            } else {
                return nil
            }
        }
        
        set {
            guard let model = newValue else { return }
            UserDefaults.standard.set(model.address, forKey: "addressUserDeliveryLocation")
            UserDefaults.standard.set(model.hasSale, forKey: "isUserNotWantedPushes")
            UserDefaults.standard.set(model.priceDelivery, forKey: "priceDeliveryUserDeliveryLocation")
        }
    }
    
    var name: String? {
        get {
          return UserDefaults.standard.string(forKey: "nameUserDataStore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nameUserDataStore")
        }
    }
    
    var phoneNumber: String? {
        get {
          return UserDefaults.standard.string(forKey: "phoneNumberUserDataStore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "phoneNumberUserDataStore")
        }
    }
    
    var outSideOrder: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "outSideOrderDataStore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "outSideOrderDataStore")
        }
    }
    
    var userOrders: [UserOrder] {
        get {
            if let data = UserDefaults.standard.data(forKey: "userOrdersDataStore") {
                let decodedArray = try? JSONDecoder().decode([UserOrder].self, from: data)
                return decodedArray ?? []
            } else {
                return []
            }
        }
        set {
            var orders: [UserOrder] = newValue
            
            // Удаляем последний элемент, если превышено максимальное количество
            if orders.count > 20 {
                orders.removeLast()
            }
            
            if let encoded = try? JSONEncoder().encode(orders) {
                UserDefaults.standard.set(encoded, forKey: "userOrdersDataStore")
            }
        }
    }
    
    var timeDelivery: (DayType, String)? = nil
    var cartViewModel: CartViewModel = CartViewModel()
    
    static let shared = DataStore()
    private init() {}
}
