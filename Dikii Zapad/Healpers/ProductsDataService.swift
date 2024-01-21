//
//  ProductsDataService.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
//

import Foundation

enum DZError: Error {
    case parce
    case badData
}

struct CategoryProduct: Codable {
    let id: Int
    
    //Сount может быть и не нужен
    let count: Int
    let name: String
    let slug: String
}

struct MediaDataElement: Codable {
    let id: Int
    let guid: TextRender
}
    
class ProductsDataService {
    static let shared = ProductsDataService()
    private init() {}
    
    ///Ссылка для продуктов
    private let urlProduct = URL(string: "http://dikiyzapad-161.ru/wp-json/wp/v2/product")!
    ///Категории продуктов
    private let urlProductCat = URL(string: "http://dikiyzapad-161.ru/wp-json/wp/v2/product_cat")!
    ///МедиаДата
    private let urlMedia = URL(string: "http://dikiyzapad-161.ru/wp-json/wp/v2/media")!
    
    var products: [ProductTest]? = []
    var categoriesProduct: [CategoryProduct]? = []
    var mediaDatas: [MediaDataElement]? = []
    
    let groupLoading = DispatchGroup()
    
    func downloadProduct(completion: @escaping () -> Void) {
        groupLoading.enter()
        groupLoading.enter()
        groupLoading.enter()
        
        //Load categoryProduct
        download(urlProductCat) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                self?.categoriesProduct = result
                print("=--= загрузил categoriesProduct = \(self?.categoriesProduct?.count ?? 0)")
                self?.groupLoading.leave()
            }
        }
        
        //Load products
        download(urlProduct) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                self?.products = result
                print("=--= загрузил products = \(self?.products?.count ?? 0)")
                self?.groupLoading.leave()

            }
        }
        
        //Load mediaDatas
        download(urlMedia) { [weak self] result, error in
            DispatchQueue.main.async { [weak self] in
                self?.mediaDatas = result
                print("=--= загрузил mediaDatas = \(self?.mediaDatas?.count ?? 0)")
                self?.groupLoading.leave()

            }
        }
        
        groupLoading.notify(queue: .main) { [weak self] in
            //Запишем в дата стор
            self?.updateDataStore()
            completion()
        }
    }
}

//Private
private extension ProductsDataService {
    
   func updateDataStore() {
       let categories = categoriesProduct ?? []
       let products = products ?? []
       let mediaDatas = mediaDatas ?? []

       categories.forEach { category in
           switch category.id {
           case 18:
               let filteredProducts = products.filter { $0.product_cat.contains(18) }
               
               let burgers = filteredProducts.map { burger in
                   let stringURL = mediaDatas.first(where: { $0.id == burger.featured_media })?.guid.rendered
                   
                   return Product(name: burger.titleText,
                                  price: 3,
                                  description: burger.descriptionText,
                                  image: nil,
                                  imageURL: URL(string: stringURL ?? ""))
               }
            
               
               DataStore.shared.burgers = burgers
               print(18)
           default:
               break
           }
           
       }
        
    }
    
    func download<T: Codable>(_ url: URL, completion: @escaping (T?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            //            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(statusCode) else {
            //                completion(.failure(NSError(domain: "", code: 0)))
            //                return
            //            }
            
            guard let data = data else {
                completion(nil, DZError.badData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, DZError.parce)
            }
        }
        task.resume()
    }
}
