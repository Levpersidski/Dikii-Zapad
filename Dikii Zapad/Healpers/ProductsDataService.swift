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
    private let urlProduct = "https://dikiyzapad-161.ru/wp-json/wc/v3/products"
    private let urlCategories = "https://dikiyzapad-161.ru/wp-json/wc/v3/products/categories"
    
    var products: [Product] = []
    var categories: [Category] = []
    
    func downloadProduct(completion: @escaping (_ hasData: Bool) -> Void) {
        products = []
        categories = []
        
        guard products.isEmpty && categories.isEmpty else {
            completion(true) //Если данные уже есть не загружаем по новой
            return
        }
        
        //Load products
        loadProdacts(numberPage: 1, urlProduct: urlProduct, groupLoading)
        
        download(urlCategories, groupLoading) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let categories: [Category] = result ?? []
                self.categories = categories
                
                print("DBG loaded \(categories.count) categories")
                LogsCollector.shared.addMessage("loaded \(categories.count) categories")
                self.groupLoading.leave()
            }
        }
        
        groupLoading.enter()
        loadPromotionsUrl { urls, error in
            DispatchQueue.main.async { [weak self] in
                print("DBG loaded \(urls == nil ? "error loadPromotions" : "has \(urls?.count ?? 0) promotions")")
                
                LogsCollector.shared.addMessage("loaded \(urls == nil ? "error loadPromotions" : "has \(urls?.count ?? 0) promotions")")

                DataStore.shared.promotionURLs = urls ?? []
                self?.groupLoading.leave()
            }
        }
        
        groupLoading.notify(queue: .main) { [weak self] in
            guard let self else { return }
            //Save in dataStore
            self.updateDataStore()
            let isEmptyCategories = self.categories.isEmpty
            let isEmptyProducts = self.products.isEmpty
            
            completion(!(isEmptyCategories) && !(isEmptyProducts) && DataStore.shared.generalSettings != nil)
        }
    }
    
    func updateDataStore() {
        DataStore.shared.allProducts = products.sorted(by: { $0.menu_order < $1.menu_order })
        DataStore.shared.allCategories = categories.sorted(by: { $0.menu_order ?? 0 < $1.menu_order ?? 0 })
    }
    
    func loadGeneralSettings(completion: @escaping (GeneralSettings?, Error?) -> Void) {
        let urlString = "https://dikiyzapad-161.ru/test/getGlobalSettings.php"
        let secretToken = DataStore.shared.secretToken
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(secretToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, DZError.badData)
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GeneralSettings.self, from: data)
                DataStore.shared.generalSettings = result
                
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, DZError.parce)
                }
            }
        }.resume()
    }
}

//Private
private extension ProductsDataService {
    func download<T: Codable>(params: [URLQueryItem] = [], _ urlString: String, _ group: DispatchGroup?, completion: @escaping (T?, Error?) -> Void) {
        group?.enter()
        let oAuthSwift = OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret)
        let baseURL = URL(string: urlString)!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        if !params.isEmpty {
            urlComponents?.queryItems = params
        }
        
        let finalURL = urlComponents?.url
        
        oAuthSwift.client.get(finalURL!) { result in
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
    
    func loadPromotionsUrl(completion: @escaping ([String]?, Error?) -> Void) {
        let urlString = "https://dikiyzapad-161.ru/test/getPromotions.php"
        let secretToken = DataStore.shared.secretToken
        
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
    
    func loadProdacts(numberPage: Int, urlProduct: String, _ groupLoading: DispatchGroup?) {
        var params = [
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "\(numberPage)")
        ]
        
        //При выключенном дев моде не отобразятся черновики товаров
        if !DataStore.shared.devMode {
            params.append(URLQueryItem(name: "status", value: "publish"))
        }
        
        download(params: params, urlProduct, groupLoading) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let products: [Product] = result ?? []
                self.products.append(contentsOf: products)
                
                
                let countProducts = products.count
                print("DBG loaded \(countProducts) products, page# \(numberPage)")
                LogsCollector.shared.addMessage("loaded \(countProducts) products, page# \(numberPage)")

                //Если элементов на первой странице больше 100 - загружаем вторую страницу
                if countProducts == 100 {
                    loadProdacts(numberPage: numberPage + 1, urlProduct: urlProduct, groupLoading)
                }
                
                self.groupLoading.leave()
            }
        }
    }
}

struct PromotionData: Codable {
    let imageUrls: [String]
}
