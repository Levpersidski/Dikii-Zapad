//
//  TelegramManager.swift
//  Dikii Zapad
//
//  Created by mac on 23.02.2024.
//

import Foundation

final class TelegramManager {
    private let url = URL(string: "http://dikiyzapad-161.ru/test/index.php")!
    private let secretToken = "0f2087abd0760c7faf0f67c0770d5a9081885394f7ad76c7cd0975e88d96fd41"
    
    private init() {}
    
    static let shared = TelegramManager()
    
    func sendMessage(_ text: String, completion: @escaping (Result<String, ErrorDZ>) -> Void) {
        let keyMessage = "text"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(secretToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = (keyMessage + "=" + text).data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(ErrorDZ.badData))
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    completion(.failure(ErrorDZ.badAuthorisations))
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("Response data = \(responseString ?? "No response")")
                completion(.success("Заказ успешно отправлен"))
            }
        }
        task.resume()
    }
}
