//
//  GeneralSettings.swift
//  Dikii Zapad
//
//  Created by mac on 11.03.2024.
//

import Foundation

struct GeneralSettings: Codable {
    let appStoreURL: String
    let minVersion: String
    let shopLocation: ShopLocation
    let contacts: Contacts
    let deliveryInfo: DeliveryInfo
    let technicalMessage: String?
    let displayCategory: [String]
    let vacancies: [Vacancy]?
}

struct Vacancy: Codable {
    var name: String = ""
    var description: String = ""
    var salary: String = ""
    var url: String = ""
    
    var hasContent: Bool {
        !self.name.isEmpty || !self.description.isEmpty || !self.salary.isEmpty
    }
}

struct ShopLocation: Codable {
    let title: String
    let subtitle: String
    let latitude: Double
    let longitude: Double
}

struct Contacts: Codable {
    let address: String
    let numberPhone: String
    let textSchedule: String
}

struct DeliveryInfo: Codable {
    let distances: [Distances]
    let saleInfo: SaleInfo
    let searchLocation: String
}

struct Distances: Codable {
    let maxDistance: Int
    let price: Int
    let hasSale: Bool
}

struct SaleInfo: Codable {
    let textSale: String
    let minPrice: Int
}
