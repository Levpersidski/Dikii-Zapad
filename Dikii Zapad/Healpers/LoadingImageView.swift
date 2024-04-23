//
//  LoadingImageView.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 23.04.2024.
//


import Foundation
import UIKit

class LoadingImageView: UIImageView {
    
    private var currentUrlString: String? = nil
    
     init() {
        super.init(frame: .zero)
        URLCache.shared = URLCache.init(
            memoryCapacity: 150 * 1024 * 1024,
            diskCapacity: 150 * 1024 * 1024,
            diskPath: "discPath"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(imageURL: String?, completion: @escaping (() -> Void) = {}) {
        currentUrlString = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            completion()
            return
            
        }
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            
            if let image = UIImage(data: cachedResponse.data) {
                self.image = image
                print("DBG ImL изображение из кэша - \(url.absoluteString)")
                completion()
            } else {
                print("DBG ERROR! bad data из кэша - \(url.absoluteString)")
            }
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            print("DBG ImL start loading - \(url.absoluteString)")

            DispatchQueue.main.async {
                completion()
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response, request)
                } else {
                    print("DBG ImL ERROR! bad url \(url.absoluteString)")
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse, _ request: URLRequest) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        
        if request.url?.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
}
