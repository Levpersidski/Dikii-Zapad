//
//  File.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
//

import Foundation


struct Category: Codable {
    let id: Int
    let name: String
    let slug: String
    let menu_order: Int?
}

struct Attribute: Codable {
    let options: [String]
}

struct Product: Codable {
    let id: Int
    let name: String
    
    let date_created: String
    let description: String
    let price: String
//    let date_modified: String
    let regular_price: String
    let sale_price: String
    let menu_order: Int
    let categories: [Category]
    let images: [MediaData]
    let stock_status: String
    
    let attributes: [Attribute]
//    var dateUpdated: Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        return dateFormatter.date(from: date_modified) ?? Date()
//    }
    
    ///Если не удалось распарсить статус - состояние = .inStock
    var stockStatusType: StockStatusType {
        StockStatusType(rawValue: stock_status) ?? .inStock
    }
    
    var imageURL: URL? {
        if let urlString = images.first?.src {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
    struct MediaData: Codable {
        let id: Int
        let src: String
    }
    
    enum StockStatusType: String {
        case inStock = "instock"          //В наличии
        case outOfStock = "outofstock"    //Нет в наличии
        case onBackOrder = "onbackorder"  //Предзаказ
    }
}
