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
        products = []
        categories = []
        
        guard products?.isEmpty ?? true && categories?.isEmpty ?? true else {
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
        
        groupLoading.enter()
        loadGeneralSettings { settings, error in
            DispatchQueue.main.async { [weak self] in
                DataStore.shared.generalSettings = settings
                print("DBG loaded \(settings == nil ? "error general settings" : "has general settings") categories")
                self?.groupLoading.leave()
            }
        }
        
        groupLoading.enter()
        loadPromotionsUrl { urls, error in
            DispatchQueue.main.async { [weak self] in
                print("DBG loaded \(urls == nil ? "error loadPromotions" : "has \(urls?.count ?? 0) promotions")")
                DataStore.shared.promotionURLs = urls ?? []
                self?.groupLoading.leave()
            }
        }
        
        groupLoading.notify(queue: .main) { [weak self] in
            guard let self else { return }
            //Save in dataStore
            self.updateDataStore()
            let isEmptyCategories = self.categories?.isEmpty ?? true
            let isEmptyProducts = self.products?.isEmpty ?? true
            
            completion(!(isEmptyCategories) && !(isEmptyProducts) && DataStore.shared.generalSettings != nil)
        }
    }
    
    func updateDataStore() {
        let products = products ?? []
        let categories = categories ?? []

        DataStore.shared.allProducts = products
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
    
    func loadGeneralSettings(completion: @escaping (GeneralSettings?, Error?) -> Void) {
        let urlString = "http://dikiyzapad-161.ru/test/getGlobalSettings.php"
        let secretToken = "0f2087abd0760c7faf0f67c0770d5a9081885394f7ad76c7cd0975e88d96fd41"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(secretToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, DZError.badData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GeneralSettings.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, DZError.parce)
            }
        }.resume()
    }
    
    func loadPromotionsUrl(completion: @escaping ([String]?, Error?) -> Void) {
        let urlString = "http://dikiyzapad-161.ru/test/getPromotions.php"
        let secretToken = "0f2087abd0760c7faf0f67c0770d5a9081885394f7ad76c7cd0975e88d96fd41"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(secretToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, DZError.badData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PromotionData.self, from: data)
                completion(result.imageUrls, nil)
            } catch {
                completion(nil, DZError.parce)
            }
        }.resume()
    }
}

struct PromotionData: Codable {
    let imageUrls: [String]
}
