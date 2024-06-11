//
//  Dikii_ZapadTests.swift
//  Dikii ZapadTests
//
//  Created by Glushchenko on 11.06.2024.
//

import XCTest
@testable import Dikii_Zapad

final class Dikii_ZapadTests: XCTestCase {
    var coffee: CoffeeTest!

    override func setUpWithError() throws {
        try super.setUpWithError()
        //В данном методе, который запускается перед началом тестов, инициируем объект в виде класа, что позволит нам обращаться к его свойствам и методам
        coffee = CoffeeTest()
    }

    override func tearDownWithError() throws {
        // убираем объект из памяти после окончания теста, освобождая память для запуска следующих тестов
        coffee = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        try testNewFunction()
    }
    
    func testNewFunction() throws {
        let sugar = 2
    // "готовим" две кружки кофе, американо и капучино, каждая имеет различный состав ингридиентов, которые прописаны в соответствующих методах класа Coffee
        
        coffee.makeCoffee(coffee: .cappuccino, sugar: sugar)
        coffee.makeCoffee(coffee: .americano, sugar: 0)
        
        // проверяем статус готовности. тест пройдёт если утверждение будет true
        XCTAssert(coffee.status, "статус приготовления кофе")
        
        // проверяем корректность использования ингридиентов для готовки двух кружек кофе
        // на примере молока, сравниваем использованное количество молока с тем, которое реально должно было израсходоваться
        XCTAssertEqual(coffee.milk, 1, "добавление молока")
        XCTAssertEqual(coffee.water, 2, "добавление воды")
        XCTAssertEqual(coffee.groundCoffee, 2, "добавление молотого кофе")
        XCTAssertEqual(coffee.sugar, 2, "добавление сахара")
    }

    ///Метод тестирования скорости выполнения определённого блока кода
    func testPerformanceExample() throws {
        let sugar = 2
        
        measure {
            coffee.makeCoffee(coffee: .cappuccino, sugar: sugar)
        }
    }

}


//XCTAssert - утверждает, что выражение истинно
//XCTAssertNil - утверждает, что выражение является nil
//XCTAssertNotNil - утверждает, что выражение не является nil
//XCTUnwrap - утверждает, что выражение не является Nil, и возвращает развернутое значение
//XCTAssertEqual - утверждает, что два значения равны
//XCTAssertNotEqual - утверждает, что два значения не равны
//XCTAssertIdentical - утверждает, что два значения идентичны
//XCTAssertNotIdentical - утверждает, что два значения не идентичны
//XCTAssertGreaterThan - утверждает, что значение первого выражения больше значения второго выражения
//XCTAssertGreaterThanOrEqual - утверждает, что значение первого выражения больше или равно значению второго выражения
//XCTAssertLessThanOrEqual - утверждает, что значение первого выражения меньше или равно значению второго выражения
//XCTAssertLessThan - утверждает, что значение первого выражения меньше значения второго выражения
//XCTAssertThrowsError - утверждает, что выражение вызывает ошибку
//XCTAssertNoThrow - утверждает, что выражение не вызывает ошибку
//XCTFail - генерация немедленной остановки
//XCTSkip - принудительный пропуск теста
