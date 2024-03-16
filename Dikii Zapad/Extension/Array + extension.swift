//
//  Array + extension.swift
//  Dikii Zapad
//
//  Created by mac on 16.03.2024.
//

import Foundation

extension Array where Element == Int {
    func closestElement(to number: Int) -> Int? {
        guard !self.isEmpty else {
            return nil
        }
        
        var closestElement = self[0]
        var minDifference = abs(number - self[0])
        
        for element in self {
            let difference = abs(number - element)
            if difference < minDifference {
                minDifference = difference
                closestElement = element
            } else if difference == 0 {
                return element
            }
        }
        
        return closestElement
    }
    
//    func closestIndex(to number: Int) -> Int? {
//        guard !self.isEmpty else {
//            return nil
//        }
//
//        var closestIndex = 0
//        var minDifference = abs(number - self[0])
//
//        for (index, element) in self.enumerated() {
//            let difference = abs(number - element)
//            if difference < minDifference {
//                minDifference = difference
//                closestIndex = index
//            } else if difference == 0 {
//                return index
//            }
//        }
//
//        return closestIndex
//    }
    
    func closestIndexGreaterOrEqual(to number: Int) -> Int? {
          guard !self.isEmpty else {
              return nil
          }
          
          var closestIndex = 0
          var minDifference = Int.max
          
          for (index, element) in self.enumerated() {
              if element >= number {
                  let difference = element - number
                  if difference < minDifference {
                      minDifference = difference
                      closestIndex = index
                  } else if difference == 0 {
                      return index
                  }
              }
          }
          
          return closestIndex
      }
  }
