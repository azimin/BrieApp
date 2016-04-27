//
//  TextAnalyzer.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Parsimmon
import Foundation

enum Category {
    case Other
    case Uber
    case Food
}

class TextAnalyzer {
    class func checkText(originalText: String) -> Category {
        let text = originalText.lowercaseString
        let tokens = lemmatize(text)
        for token in tokens {
            if stopWords.contains(token as! String) {
                return .Other
            }
        }
        for word in stopWords {
            if text.rangeOfString(word) != nil {
                return .Other
            }
        }
        for word in uberWords {
            if text.rangeOfString(word) != nil {
                return .Uber
            }
        }
        for word in foodWords {
            if text.rangeOfString(word) != nil {
                return .Food
            }
        }
        return .Other
//        switch classifier.classify(text) {
//        case "uber":
//                return .Uber
//        default:
//                return .Food
//        }
    }
    
    static let uberWords = ["забрать", "встретить", "ехать", "поезд", "самолет", "вылет", "съездить", "выставка", "музей", "театр", "посетить"]
    static let foodWords = ["ужин", "завтрак", "обед", "ланч", "забронировать", "заказать"]
    static let stopWords = ["душ", "Душ", "велик", "Велосипед", "Бег", "бежать", "пробежка", "Пробежка", "велосипед", "сделать", "помедитировать", "Помедитировать", "Гулять", "Прогулка"]
    
    static let classifier = ParsimmonNaiveBayesClassifier()
    
    class func lemmatize(text: String) -> [AnyObject] {
        let lemmatizer = ParsimmonLemmatizer()
        let lemmatizedTokens = lemmatizer.lemmatizeWordsInText(text)
        return lemmatizedTokens
    }
    
    class func trainer() {
        // Train the classifier with some Uber examples.
        classifier.trainWithText("Забрать вещи", category: "uber")
        classifier.trainWithText("Встретиться с Валькой", category: "uber")
        classifier.trainWithText("Встреча в аэропорту", category: "uber")
        classifier.trainWithText("Доехать до дома", category: "uber")
        classifier.trainWithText("Выехать в Москву", category: "uber")
        classifier.trainWithText("Поезд в Питер", category: "uber")
        classifier.trainWithText("Съездить в Магадан", category: "uber")
        classifier.trainWithText("Переехать в Ленинград", category: "uber")
        classifier.trainWithText("Поехать домой", category: "uber")
        classifier.trainWithText("Выставка \"Алекс из свэг\"", category: "uber")
        classifier.trainWithText("выставка картин", category: "uber")
        
        classifier.trainWithText("Забрать пакеты", category: "uber")
        classifier.trainWithText("Встретить друга", category: "uber")
        classifier.trainWithText("Встреча на вокзале", category: "uber")
        classifier.trainWithText("Доехать до озера", category: "uber")
        classifier.trainWithText("Выехать из дома", category: "uber")
        classifier.trainWithText("Поезд в Магадан", category: "uber")
        classifier.trainWithText("Съездить в лес", category: "uber")
        classifier.trainWithText("Переехать из дома", category: "uber")
        classifier.trainWithText("Поехать на машине", category: "uber")
        
        // Train the classifier with some Food examples.
        classifier.trainWithText("Пообедать с друзьями", category: "food")
        classifier.trainWithText("Обед после вуза", category: "food")
        classifier.trainWithText("Ланч с мамой", category: "food")
        classifier.trainWithText("Пообедать с друзьями", category: "food")
        classifier.trainWithText("Ужин с Никой", category: "food")
        classifier.trainWithText("Кофе с Лизой", category: "food")
        classifier.trainWithText("Позавтракать с Аней", category: "food")
        classifier.trainWithText("Забронировать ресторан", category: "food")
        classifier.trainWithText("Заказать пиццу", category: "food")
        
        classifier.trainWithText("Пообедать после вуза", category: "food")
        classifier.trainWithText("Обед с друзьями", category: "food")
        classifier.trainWithText("Ланч летом", category: "food")
        classifier.trainWithText("Пообедать в баре", category: "food")
        classifier.trainWithText("Ужин с кошками", category: "food")
        classifier.trainWithText("Кофе на вынос", category: "food")
        classifier.trainWithText("Позавтракать пельменями", category: "food")
        classifier.trainWithText("Заказать вок", category: "food")
    }
}