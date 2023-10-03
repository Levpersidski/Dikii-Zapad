//
//  DataStore.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit

struct Product {
    let name: String
    let price: Int
    let description: String
    let image: UIImage?
}

class DataStore {
    var burgers: [Product]? = [
        Product(name: "Малыш Билли",
                price: 99,
                description: "Картофельная булочка, котлета из мраморной говядины 60 грамм,сыр чеддер,красный лук,соленый огурчик,кетчуп",
                image: UIImage(named: "bill")),
        Product(name: "Гавайский разбойник",
                price: 269,
                description: "Булочка Бриошь , котлета из мраморной говядины 110гр, карамелизированный ананас, сыр чеддер, лист салата, помидор,красный лук,соус 1000 островов",
                image: UIImage(named: "Hawai")),
        Product(name: "Черный барт",
                price: 279,
                description: """
                Состав:
                Черная булочка, котлета из мраморной говядины 110гр, жаренный бекон, ягодный джем, сыр чеддер, лист салата, помидор,красный лук, соус ''1000 островов''
                """,
                image: UIImage(named: "blackbart")),
        Product(name: "Дикий Билл",
                price: 289,
                description: "Булочка бриошь, котлета из мраморной говядины 150гр, лист салата, помидор, сыр чеддер, красный лук, фирменный соус",
                image: UIImage(named: "WildBill")),
        Product(name: "Мексиканец 🌶️",
                price: 319,
                description: "Красная булочка ''Чили'', Котлета из мраморной говядины 150гр, острый перчик халапеньо, соус ''Сальса'', сыр чеддер, красный лук обжаренный на гриле, помидор, лист салата, соленые огурчики",
                image: UIImage(named: "Mexican")),
        Product(name: "Помощник Шерифа 🐔",
                price: 229,
                description: "Булочка Бриошь, куриная котлета в панировке, жаренное яйцо, сыр чеддер, лист салата, помидор,красный лук, соус 1000 островов",
                image: UIImage(named: "HelperSherif")),
        Product(name: "Шериф бургер",
                price: 329,
                description: "Булочка бриошь, котлета из мраморной говядины 150гр, жаренный бекон, сыр чеддер, жаренное яйцо, лист салата, красный лук, помидор,соус BBQ, хрустящий жареный лучок.",
                image: UIImage(named: "Sheriff")),
        Product(name: "Гранд Каньон",
                price: 495,
                description: "Черная булочка, две котлеты из мраморной говядины 150гр,жареный бекон, сыр чеддер, сыр моцарелла, помидор, лист салата, красный лук, соленые огурчики, соус BBQ, фирменный соус",
                image: UIImage(named: "Grand")),
        Product(name: "сырный Луи",
                price: 349,
                description: "Белая булочка, котлета из мраморной говядины 150гр, сыр Гауда, сыр Чеддер, сыр Моцарелла, помидор, лист салата, соус Блю Чиз.",
                image: UIImage(named: "Lui")),
        Product(name: "Грибник Джо",
                price: 329,
                description: "Белая булочка, котлета из мраморной говядины 150гр, сыр моцарелла, шампиньоны, лист салата, помидор, солёные огурчики, соус Блю Чиз.",
                image: UIImage(named: "JOE")),
        Product(name: "ЧизиЧикен",
                price: 329,
                description: "Белая булочка, куриная котлета , хрустящие сырные палочки, сыр Моцарелла, сыр Гауда, сыр Чеддер, соус Блю Чиз.",
                image: UIImage(named: "CheesyChiken")),
        Product(name: "Фермерский",
                price: 339,
                description: "Белая булочка, котлета из мраморной говядины 150г, сыр чеддер, картофельный драник, ветчина, лист салата, красный лук, помидор, фирменный соус",
                image: UIImage(named: "farmburger")),
        Product(name: "Цезарь",
                price: 259,
                description: "Булочка бриошь, куриное филе на гриле, помидор, лист салата, красный лук, соус цезарь",
                image: UIImage(named: "caesar")),
        Product(name: "Бургер с горгонзолой и грушей",
                price: 359,
                description: "Белая булочка, котлета из мраморной говядины 150гр, карамелизированная груша, сыр горгонзола, сыр моцарелла, лист салата",
                image: UIImage(named: "gorgonzola")),
        
        
    
    
    ]
    
    
    var pizzas: [Product]? = [
        Product(name: "Итальянская",
                price: 469,
                description: "Сыр моцарелла, пикантная пепперони, шампиньоны,маслины, томатный соус, итальянские травы",
                image: UIImage(named: "ItalianPizza")),
        Product(name: "Цыпленок Ранч",
                price: 489,
                description: "Сыр моцарелла, цыплёнок, ветчина,томаты, соус ранч, томатный соус",
                image: UIImage(named: "ranchpizza")),
        Product(name: "Цыпленок BBQ",
                price: 479,
                description: "Томатный соус, сыр моцарелла, красный лук, цыплёнок, бекон, соус BBQ",
                image: UIImage(named: "BBQpizza")),
        Product(name: "Супермясная",
                price: 529,
                description: "Сыр моцарелла, цыпленок, бекон, ветчина, пикантная пепперони, красный лук, томатный соус",
                image: UIImage(named: "Supermeat")),
        Product(name: "Мексиканская",
                price: 479,
                description: "Сыр моцарелла, цыпленок, острый халапеньо,спелые томаты,красный лук, зеленый перец, острый соус Сальса, томатный соус",
                image: UIImage(named: "MexicanPizza")),
        Product(name: "Кантри Чикен",
                price: 479,
                description: "Сыр моцарелла, цыпленок, пикантная пепперони, кисло-сладкий соус, томатный соус",
                image: UIImage(named: "Сountrychiken")),
        Product(name: "Сырная",
                price: 489,
                description: "Сыр Моцарелла, сыр чеддер, итальянские травы,томатный соус",
                image: UIImage(named: "Cheesepizza")),
        Product(name: "Чоризо",
                price: 489,
                description: "Сыр моцарелла, острые колбаски чоризо ,спелые томаты, соус чипотле, томатный соус",
                image: UIImage(named: "Chorizo")),
        Product(name: "Ветчина-грибы",
                price: 459,
                description: "Сыр моцарелла, шампиньоны, ветчина, томатный соус",
                image: UIImage(named: "HumAndMushroom")),
        Product(name: "Гавайская",
                price: 439,
                description: "Сыр моцарелла, куриное филе, ананас, томатный соус",
                image: UIImage(named: "HawaiPizza")),
        Product(name: "Кисло-сладкий цыпленок",
                price: 459,
                description: "Сыр моцарелла, цыплёнок, кисло-сладкий соус, томатный соус.",
                image: UIImage(named: "SourAndSweet")),
        Product(name: "Пепперони",
                price: 449,
                description: "Сыр моцарелла, пикантная пепперони, томатный соус",
                image: UIImage(named: "Pepperoni")),
        Product(name: "Курица-грибы",
                price: 459,
                description: "Сыр моцарелла, жаренный цыплёнок, шампиньоны, томатный соус",
                image: UIImage(named: "chickenAndMushroom")),
        Product(name: "Маргарита",
                price: 389,
                description: "Сыр моцарелла, спелые томаты, итальянские травы, томатный соус",
                image: UIImage(named: "Margarita")),
        Product(name: "Пепперони с томатами",
                price: 469,
                description: "Сыр моцарелла, пикантная пепперони, спелые томаты, томатный соус",
                image: UIImage(named: "PepperoniTomato")),
        Product(name: "Томаты-грибы",
                price: 429,
                description: "Сыр моцарелла, шампиньоны, спелые томаты, итальянские травы",
                image: UIImage(named: "TomatoMushrooms")),
        Product(name: "Чизбургер-пицца",
                price: 489,
                description: "Сыр моцарелла, говяжий фарш, соус гамбургер, красный лук, спелые томаты, соленые огурчики.",
                image: UIImage(named: "cheeseburgerPizza")),
        Product(name: "Техас",
                price: 529,
                description: "Сладкая кукуруза, цыпленок, спелые томаты, сыр моцарелла, сыр Гауда, соус Пармеджано.",
                image: UIImage(named: "Texas")),
        Product(name: "Груша-горгонзола",
                price: 539,
                description: "Сыр горгонзола, карамелизированная груша, сыр моцарелла, фирменный соус.",
                image: UIImage(named: "NoPizza")),
    ]
    
        var drinks: [Product] = [
        Product(name: "Кола",
                price: 100,
                description: "Газированный напиток",
                image: UIImage(named: "cola")),
        Product(name: "Лимонад",
                price: 120,
                description: "Лимонный напиток",
                image: UIImage(named: "lemonade")),
        Product(name: "Чай",
                price: 80,
                description: "Черный чай",
                image: UIImage(named: "tea"))
    ]
    
    static let shared = DataStore()
    private init() {}
}
