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

struct AdditiveProduct {
    let name: String
    let price: Int
    var selected: Bool = false
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
    
    
    var hotdogs: [Product] = [
    Product(name: "Классичесикй",
            price: 199,
            description: "Говяжья сосиска, соленые огурчики, жареный бекон, хрустящий жаренный лучок, соус барбекю, фирменный соус", 
            image: UIImage(named: "HotDogClassic")),
    Product(name: "Острый",
            price: 199,
            description: "Говяжья сосиска, соленые огурчики, красный лук,перчик халапеньо, фирменный соус",
            image: UIImage(named: "HotDogSpicy"))
    
    ]
    
    var snacks: [Product] = [
    Product(name: "Картофель Фри",
            price: 99,
            description: "Порция картофеля фри (110гр)",
            image: UIImage(named: "frenchFries")),
    
    Product(name: "картофельные дольки",
            price: 109,
            description: "Молодой картофель прямиком из деревни (110гр)",
            image: UIImage(named: "friedDolki")),
    
    Product(name: "Рифленный картофель",
            price: 109,
            description: "Благодаря рифлёной форме данный картофель является более хрустящим и прожаренным ",
            image: UIImage(named: "")),
    
    Product(name: "Наггетсы",
            price: 139,
            description: "Наггетсы (9шт)",
            image: UIImage(named: "naggets")),
    
    Product(name: "Крылышки в острой панировке",
            price: 249,
            description: "Крылышки в острой панировке",
            image: UIImage(named: "Friedwings")),
    
    Product(name: "сырные палочки 5шт.",
            price: 129,
            description: "Сыр гауда в хрустящей панировке",
            image: UIImage(named: "cheeseSticks")),
    
    Product(name: "сырные палочки 10шт.",
            price: 199,
            description: "Сыр гауда в хрустящей панировке",
            image: UIImage(named: "cheeseSticks")),
    
    Product(name: "Медальоны с халапеньо 5 шт.",
            price: 109,
            description: "Сыр моцарелла с кусочками острого перчика халапеньо (5шт.)",
            image: UIImage(named: "medalionsHot")),
    
    Product(name: "Куринные стрипсы 5шт.",
            price: 199,
            description: "Сочные ломтики куринного филе в панировке",
            image: UIImage(named: "strips")),
    
    Product(name: "Креветки в панировке 6шт.",
            price: 199,
            description: "Очищенные королевские креветки в хрустящей панировке",
            image: UIImage(named: "friedShrimps")),
    
    Product(name: "Фри по-техасски",
            price: 149,
            description: "Золотистые брусочки картофеля, кусочки обжаренного бекона, под нежным сырным соусом",
            image: UIImage(named: "FriesTexas")),
    
    Product(name: "Луковые колечки",
            price: 89,
            description: "Луковые колечки 5 шт",
            image: UIImage(named: "Onionrings")),
    
    Product(name: "Кольца кальмара 5 шт.",
            price: 189,
            description: "Жаренные кольца кальмара 5 шт",
            image: UIImage(named: "squadRings"))
    
            ]
    
    var milkshakes: [Product] = [
        Product(name: "Милкшейк 'Snickers'",
                price: 209,
                description: "Молочный коктейль с добавлением мягкого шоколада, карамели и арахиса",
                image: UIImage(named: "Snickers")),
        
        Product(name: "Милкшейк 'Oreo'",
                price: 209,
                description: "Молочный коктейль с добавлением печенья Oreo и мягкого шоколада",
                image: UIImage(named: "Oreo")),
        
        Product(name: "Милкшейк 'Bounty'",
                price: 209,
                description: "Молочный коктейль с добавлением кокоса и мягкого шоколада",
                image: UIImage(named: "Bounty")),
        
        Product(name: "Милкшейк малиновый",
                price: 199,
                description: "Молочный коктейль со вкусом малины",
                image: UIImage(named: "raspberry")),
        
        Product(name: "Милкшейк 'Попкорн'",
                price: 209,
                description: "Молочный коктейль со вкусом попкорна",
                image: UIImage(named: "popcorn")),
        
        Product(name: "Милкшейк клубничный",
                price: 199,
                description: "Молочный коктейль со вкусом клубники",
                image: UIImage(named: "strawberry")),
        
        Product(name: "Милкшейк ванильный",
                price: 199,
                description: "Молочный коктейль со вкусом ванили",
                image: UIImage(named: "vanilla")),
        
        Product(name: "Милкшейк 'Фисташка-Малина'",
                price: 209,
                description: "Молочный коктейль со вкусом фисташки и малины",
                image: UIImage(named: "pistachio")),
        
        
        Product(name: "Милкшейк 'Бабл Гам'",
                price: 199,
                description: "Молочный коктейль со вкусом жевачки",
                image: UIImage(named: "bublegum")),
        
        Product(name: "Милкшейк 'Банановый'",
                price: 199,
                description: "Молочный коктейль со вкусом банана",
                image: UIImage(named: "Banana")),
        
    ]
    
    var lemonades: [Product] = [
        
    Product(name: "Блю Кюрасао",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "blueCuracao")),
    
    Product(name: "Малиновый",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "malina")),
    
    Product(name: "Цитрусовый",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "citrus")),
    
    Product(name: "Ежевичный",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "ezhevika")),
    
    Product(name: "Тархун",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "Tarhun")),

    
    Product(name: "Тропический",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "blueCuracao")),
    
    Product(name: "Мохито",
            price: 159,
            description: "Освежающий лимонад с добавлением свежих фруктов и лимонного сока 450мл",
            image: UIImage(named: "blueCuracao"))
    ]
    
    
    var coffeeDrinks: [Product] = [
    Product(name: "Бамбл би (двойной)",
            price: 190,
            description: "Лёд, апельсиновый сок, двойная порция эспрессо, сироп",
            image: UIImage(named: "BumbleBee")),
    
    Product(name: "Кофе-Тоник (двойной)",
            price: 190,
            description: "Двойная порция эспрессо, тоник, лёд, ванильный сироп",
            image: UIImage(named: "tonic")),
    
    Product(name: "Бамбл би",
            price: 160,
            description: "Лёд, апельсиновый сок, двойная порция эспрессо, сироп",
            image: UIImage(named: "BumbleBee")),
    
    Product(name: "Кофе-Тоник",
            price: 160,
            description: "Двойная порция эспрессо, тоник, лёд, ванильный сироп",
            image: UIImage(named: "tonic")),
    
    Product(name: "Карамельный Айс Латте",
            price: 150,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "IceLatte")),
    
    Product(name: "Дабл Капучино",
            price: 159,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "doublecapuchino")),
    
    Product(name: "Эспрессо",
            price: 60,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "espresso")),
    
    Product(name: "Американо",
            price: 60,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "capuchino")),
    
    
    Product(name: "Капучино",
            price: 120,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "capuchino")),
    
    
    Product(name: "Флэт Уайт",
            price: 120,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "capuchino")),
    
    
    Product(name: "Латте Макиато",
            price: 130,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "capuchino")),
    
    Product(name: "Английский фраппучино",
            price: 130,
            description: "Лед, сироп,молоко 1,5% ,порция эспрессо",
            image: UIImage(named: "capuchino")),
    
    ]
    
    var desserts: [Product] = [
        Product(name: "Донат ягодный",
                price: 180,
                description: "донат",
                image: UIImage(named: "donutberry")),
        
        Product(name: "Донат кокосовый",
                price: 180,
                description: "донат",
                image: UIImage(named: "donutcoconut")),
        
        Product(name: "Донат шоколадный",
                price: 80,
                description: "донат",
                image: UIImage(named: "donutchocolate")),
        
        
        Product(name: "Донат карамельный",
                price: 80,
                description: "донат",
                image: UIImage(named: "donutcaramel")),
        
        Product(name: "Донат малиновый",
                price: 80,
                description: "донат",
                image: UIImage(named: "donutraspberry")),
        
        Product(name: "Донат клубничный",
                price: 80,
                description: "донат",
                image: UIImage(named: "DonatStrawberry")),
        
        Product(name: "Сырники",
                price: 80,
                description: "Сырники",
                image: UIImage(named: "sirniki")),
        
        Product(name: "Шоколадный маффин",
                price: 99,
                description: "Маффин",
                image: UIImage(named: "")),
        
        Product(name: "Чизкейк Нью-йорк",
                price: 120,
                description: "Чизкейк",
                image: UIImage(named: "cheesecake")),
        
        Product(name: "Чизкейк Сникерс",
                price: 130,
                description: "Чизкейк",
                image: UIImage(named: "cheesecakeSnik")),

        
        
        
        
        
        
    ]
    
        var drinks: [Product] = [
        Product(name: "Кола",
                price: 99,
                description: "Газированный напиток",
                image: UIImage(named: "cola")),
        
        Product(name: "Лимон-лайм",
                price: 99,
                description: "Лимонный напиток",
                image: UIImage(named: "sprite")),
        
        Product(name: "Апельсин",
                price: 99,
                description: "Лимонный напиток",
                image: UIImage(named: "fanta")),
        
        
        Product(name: "Чай “Rich” черный",
                price: 80,
                description: "Черный чай",
                image: UIImage(named: "blacktea")),
        
        Product(name: "Чай “Rich” зеленый",
                price: 80,
                description: "Зеленый чай",
                image: UIImage(named: "greentea")),
        
        Product(name: "Адреналин",
                price: 169,
                description: "Энергетик",
                image: UIImage(named: "adrenalin")),
        
        Product(name: "Vinut в асс.",
                price: 119,
                description: "винат в ассортименте",
                image: UIImage(named: "vinuts")),
        
        Product(name: "Chupa Chups",
                price: 139,
                description: "чупа чупс",
                image: UIImage(named: "chupa")),
        
        
        Product(name: "Швепс",
                price: 139,
                description: "Швепс в асс.",
                image: UIImage(named: "shewepes")),
        
        Product(name: "Coca-Cola (original)",
                price: 139,
                description: "Энергетик",
                image: UIImage(named: "colaoriginal")),
        
    ]
    
    
    var additiveBurger: [AdditiveProduct] = [
        AdditiveProduct(name: "Ломтик сыра чеддер", price: 25),
        AdditiveProduct(name: "Острый перчик халапеньо", price: 20),
        AdditiveProduct(name: "Котлета 150 грамм", price: 110),
        AdditiveProduct(name: "Картофельный дранник", price: 30),
        AdditiveProduct(name: "Ломтик сыра чеддер", price: 25),
        AdditiveProduct(name: "Острый перчик халапеньо", price: 20),
        AdditiveProduct(name: "Котлета 150 грамм", price: 110),
        AdditiveProduct(name: "Картофельный дранник", price: 30)
    ]
    
    var additivePizza: [AdditiveProduct] = [
        AdditiveProduct(name: "Еще больше сыра", price: 500),
        AdditiveProduct(name: "Острый перчик халапеньо", price: 20),
        AdditiveProduct(name: "Ананас", price: 30)
    ]
    
    var cartViewModel: [CartViewModel] = []
    
    
    
    
    static let shared = DataStore()
    private init() {}
}
