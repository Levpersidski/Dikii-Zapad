//
//  GestureRecognizerHealpers.swift
//  Dikii Zapad
//
//  Created by mac on 27.01.2024.
//

import UIKit

final class ClosureTapGestureRecognizer: UITapGestureRecognizer {
    private var action: (UIGestureRecognizer.State) -> ()

    init(action: @escaping (UIGestureRecognizer.State) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action(self.state)
    }
}

final class ClosureLongPressGestureRecognizer: UILongPressGestureRecognizer {
    private var action: (UILongPressGestureRecognizer) -> ()

    init(action: @escaping (UILongPressGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action(self)
    }
}
