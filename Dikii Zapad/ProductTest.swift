//
//  File.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
//

import Foundation

struct ProductTest: Codable {
    let id: Int
    let date: String
    let modified: String
    let title: TextRender
    let content: TextRender
    let featured_media: Int
    let product_cat: [Int]
    
    var titleText: String {
        title.rendered
    }
    
    var descriptionText: String {
        content.rendered
    }
}

struct TextRender: Codable {
    let rendered: String
}
