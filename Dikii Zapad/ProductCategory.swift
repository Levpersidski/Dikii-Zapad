//
//  ProductCategory.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit

// Примеры продуктов
struct ProductCategory {
    //MARK: - Burgers
    static let burgers: [Product] = [
        Product(name: "Малыш Билли",
                price: 99,
                description: "Картофельная булочка, котлета из мраморной говядины 60 грамм,сыр чеддер,красный лук,соленый огурчик,кетчуп",
                image: UIImage(named: "bill")!),
        Product(name: "Гавайский разбойник",
                price: 269,
                description: "Булочка Бриошь , котлета из мраморной говядины 110гр, карамелизированный ананас, сыр чеддер, лист салата, помидор,красный лук,соус 1000 островов",
                image: UIImage(named: "Hawai")!),
        Product(name: "Черный барт",
                price: 279,
                description: "Черная булочка, котлета из мраморной говядины 110гр,жаренный бекон, ягодный джем, сыр чеддер,лист салата, помидор,красный лук,соус ''1000 островов''",
                image: UIImage(named: "blackbart")!),
        Product(name: "Дикий Билл",
                price: 289,
                description: "Булочка бриошь, котлета из мраморной говядины 150гр, лист салата, помидор, сыр чеддер, красный лук, фирменный соус",
                image: UIImage(named: "WildBill")!),
        Product(name: "Мексиканец 🌶️",
                price: 319,
                description: "Красная булочка ''Чили'', Котлета из мраморной говядины 150гр, острый перчик халапеньо, соус ''Сальса'', сыр чеддер, красный лук обжаренный на гриле, помидор, лист салата, соленые огурчики",
                image: UIImage(named: "Mexican")!),
        Product(name: "Помощник Шерифа 🐔",
                price: 229,
                description: "Булочка Бриошь, куриная котлета в панировке, жаренное яйцо, сыр чеддер, лист салата, помидор,красный лук, соус 1000 островов",
                image: UIImage(named: "HelperSherif")!),
        Product(name: "Шериф бургер",
                price: 229,
                description: "Булочка бриошь, котлета из мраморной говядины 150гр, жаренный бекон, сыр чеддер, жаренное яйцо, лист салата, красный лук, помидор,соус BBQ, хрустящий жареный лучок.",
                image: UIImage(named: "Sheriff")!),
        
        
        
        
    ]
    
    //MARK: - Burgers
    static let pizzas: [Product] = [
        Product(name: "Маргарита",
                price: 300,
                description: "Пицца с томатным соусом и моцареллой",
                image: UIImage(named: "pizza1")!),
        Product(name: "Пепперони",
                price: 350,
                description: "Пицца с пепперони и сыром",
                image: UIImage(named: "pizza2")!),
        Product(name: "Гавайская",
                price: 320,
                description: "Пицца с ветчиной и ананасами",
                image: UIImage(named: "pizza3")!)
    ]

    
    static let drinks: [Product] = [
        Product(name: "Кола",
                price: 100,
                description: "Газированный напиток",
                image: UIImage(named: "cola")!),
        Product(name: "Лимонад",
                price: 120,
                description: "Лимонный напиток",
                image: UIImage(named: "lemonade")!),
        Product(name: "Чай",
                price: 80,
                description: "Черный чай",
                image: UIImage(named: "tea")!)
    ]
}
