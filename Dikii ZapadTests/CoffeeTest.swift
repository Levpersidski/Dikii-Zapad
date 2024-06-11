//
//  CoffeeTest.swift
//  Dikii ZapadTests
//
//  Created by Glushchenko on 11.06.2024.
//

import Foundation

enum TypesOfCoffee {
    case americano
    case cappuccino
}

final class CoffeeTest {
    var water = 0
    var milk = 0
    var groundCoffee = 0
    var sugar = 0
    var status = false
    
    
    // внутренний метод изготовления американо
    private func americano() {
        water += 1
        groundCoffee += 1
        status = true
    }
    
    // внутренний метод изготовления капучино
    private func cappuccino() {
        water += 1
        groundCoffee += 1
        milk += 1
        status = true
    }
    
    // метод запуска готовки выбранного варианта кофе с добавлением сахара (по желанию =))
    func makeCoffee(coffee: TypesOfCoffee, sugar: Int) {
        switch coffee {
        case .americano:
            americano()
        case .cappuccino:
            cappuccino()
        }
        
        self.sugar += sugar
    }
}
