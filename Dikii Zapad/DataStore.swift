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
    var allCategories: [Category] = []
    var allProducts: [Product] = []
    
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
    
    var timeDelivery: (DayType, String)? = nil
    var cartViewModel: CartViewModel = CartViewModel()
    
    static let shared = DataStore()
    private init() {}
}
