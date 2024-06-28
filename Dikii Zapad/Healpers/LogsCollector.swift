//
//  LogsCollector.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 11.06.2024.
//

import Foundation

final class LogsCollector {
    static let newLogEntryNotification = Notification.Name("newLogEntryNotification")
    
    static var shared = LogsCollector()
    var logs: [LogoModel] = []
    
    private init() {}
    
    func addMessage(_ text: String) {
        let date = Date().string(format: "HH:mm:ss") ?? ""
        let log = LogoModel(uuid: UUID(), text: text, date: date, isToken: false)
        logs.append(log)
        
        NotificationCenter.default.post(name: LogsCollector.newLogEntryNotification, object: nil)
    }
    
    func addToken(_ text: String) {
        let date = Date().string(format: "HH:mm:ss") ?? ""
        let log = LogoModel(uuid: UUID(), text: text, date: date, isToken: true)
        logs.append(log)
    }
}
