//
//  ProductsDataService.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
//

import Foundation
import OAuthSwift

enum DZError: Error {
    case parce
    case badData
}
    
class ProductsDataService {
    static let shared = ProductsDataService()
    private init() {}
    
    private let groupLoading = DispatchGroup()
    private let consumerKey = "ck_ef9051614f2e789ad9b0de46d7a2c1a13ac02573"
    private let consumerSecret = "cs_413015e37ab0d3b03e8f7164d0bfa3a18f8930a6"
    
    ///Ссылка для продуктов
    private let urlProduct = "http://dikiyzapad-161.ru/wp-json/wc/v3/products"
    private let urlCategories = "http://dikiyzapad-161.ru/wp-json/wc/v3/products/categories"
    
    var products: [Product]? = []
    var categories: [Category]? = []
    
    func downloadProduct(completion: @escaping (_ hasData: Bool) -> Void) {
        guard let products = products, let categories = categories else {
            completion(false) // Доп защита по сути экземпляры всегда инициализированы
            return
        }
        
        guard products.isEmpty && categories.isEmpty else {
            completion(true) //Если данные уже есть не загружаем по новой
            return
        }
        
        //Load products
        download(urlProduct, groupLoading) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                self?.products = result
                print("DBG loaded \(self?.products?.count ?? 0) products")
                self?.groupLoading.leave()
            }
        }
        
        download(urlCategories, groupLoading) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                self?.categories = result
                print("DBG loaded \(self?.categories?.count ?? 0) categories")
                self?.groupLoading.leave()
            }
        }
        
        groupLoading.notify(queue: .main) { [weak self] in
            guard let self else { return }
            //Save in dataStore
            self.updateDataStore()
            let isEmptyCategories = self.categories?.isEmpty ?? true
            let isEmptyProducts = self.products?.isEmpty ?? true
            
            completion(!(isEmptyCategories) && !(isEmptyProducts))
        }
    }
    
    func updateDataStore() {
        let products = products ?? []
        let categories = categories ?? []

        DataStore.shared.allProducts = products //.filter({ $0.categories.first?.id == 18 })
        
        DataStore.shared.allCategories = categories
    }
}

//Private
private extension ProductsDataService {
    
    func download<T: Codable>(_ urlString: String, _ group: DispatchGroup?, completion: @escaping (T?, Error?) -> Void) {
        group?.enter()
        let oAuthSwift = OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        oAuthSwift.client.get(urlString) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(T.self, from: response.data)
                    completion(result, nil)
                } catch {
                    completion(nil, DZError.parce)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
