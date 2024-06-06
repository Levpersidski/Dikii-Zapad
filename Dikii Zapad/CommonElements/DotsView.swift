//
//  DotsView.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 03.06.2024.
//

import UIKit

class DotsView: UIView {
    enum DotType {
        case oval
        case rect
    }

    var dotColor: UIColor = UIColor.gray
    var dotSpacing: CGFloat = 10
    var dotSize: CGSize = CGSize(width: 7, height: 1.5)
    var type: DotType = .oval
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        dotColor.set()
        
        let points = createDots()
        for point in points {
            let dot: UIBezierPath
            switch type {
            case .oval:
                dot = UIBezierPath(ovalIn: CGRect(origin: point, size: dotSize))
            case .rect:
                dot = UIBezierPath(rect: CGRect(origin: point, size: dotSize))
            }
            dot.fill()
        }
    }
    
    func createDots() -> [CGPoint] {
        var dots: [CGPoint] = []
        var originX: CGFloat = 0.0
        
        while originX < self.frame.size.width {
            let dot = CGPoint(x: originX, y: 0)
            dots.append(dot)
            
            originX += dotSpacing
        }
        
        return dots
    }

}
