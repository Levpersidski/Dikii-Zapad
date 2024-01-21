//
//  File.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
//

import Foundation

struct ProductTest: Codable {
    let id: Int
    let name: String
    
    let date_created: String
    let description: String
    let price: String
    let regular_price: String
    let sale_price: String
    let categories: [Category]
    let images: [MediaData]
    let stock_status: String
    
    struct Category: Codable {
        let id: Int
        let name: String
        let slug: String
    }
    
    struct MediaData: Codable {
        let id: Int
        let src: String
    }
}

struct TextRender: Codable {
    let rendered: String
}
