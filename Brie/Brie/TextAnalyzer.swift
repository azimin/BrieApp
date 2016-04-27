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
  case Events
}

class TextAnalyzer {
    
  static let classifier = ParsimmonNaiveBayesClassifier()
    
  class func lemmatize(text: String) -> [AnyObject] {
    let lemmatizer = ParsimmonLemmatizer()
    let lemmatizedTokens = lemmatizer.lemmatizeWordsInText(text)
    return lemmatizedTokens
  }
    
  class func trainer() {
    // Train the classifier with some Uber examples.
    classifier.trainWithText("Meet friends", category: "uber")
    classifier.trainWithText("Visit friends", category: "uber")
    classifier.trainWithText("Meeting with friends", category: "uber")
    classifier.trainWithText("Cinema with Julia", category: "uber")
    classifier.trainWithText("Cinema with Masha", category: "uber")
    classifier.trainWithText("A date with Katy", category: "uber")
    classifier.trainWithText("Dating with Amy", category: "uber")
    classifier.trainWithText("Coffee with Liza", category: "food")
    
    // Train the classifier with some Food examples.
    classifier.trainWithText("Supper with Nika", category: "food")
    classifier.trainWithText("Lunch with friends", category: "food")
    classifier.trainWithText("Breakfast with mommy", category: "food")
    classifier.trainWithText("Dinner at home", category: "food")
    classifier.trainWithText("Dinner with friends", category: "food")
    classifier.trainWithText("Book a table", category: "food")
    classifier.trainWithText("Book a restaurant", category: "food")
    classifier.trainWithText("Order pizza", category: "food")
    classifier.trainWithText("Pizza with friends", category: "food")
    classifier.trainWithText("Get some sushi", category: "food")
    classifier.trainWithText("Order sushi", category: "food")
    classifier.trainWithText("Chinese food", category: "food")
    classifier.trainWithText("Meet for some wine", category: "food")
    
    // Train the classifier with some Fun examples
    classifier.trainWithText("Music festival", category: "fun")
    classifier.trainWithText("Conference from Apple", category: "fun")
    classifier.trainWithText("Having fun", category: "fun")
  }
}