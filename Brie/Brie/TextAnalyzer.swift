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
  case Fun
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
    for word in funWords {
      if text.rangeOfString(word) != nil {
        return .Fun
      }
    }
    for word in foodWords {
      if text.rangeOfString(word) != nil {
        return .Food
      }
    }
    return .Other
  }
    
  static let uberWords = ["airport", "flight", "train", "trip", "journey", "date", "meeting", "meet", "friends", "friend", "taxi"]
  static let foodWords = ["food", "order", "pizza", "lunch", "breakfast", "dinner", "meal", "supper", "book a table"]
  static let funWords = ["theater", "theatre", "cinema", "film", "museum", "event", "buy", "book"]
  static let stopWords = ["walk", "bike", "cycle", "cycling", "swimming", "test", "run", "running"]
  
  static let classifier = ParsimmonNaiveBayesClassifier()

  class func lemmatize(text: String) -> [AnyObject] {
    let lemmatizer = ParsimmonLemmatizer()
    let lemmatizedTokens = lemmatizer.lemmatizeWordsInText(text)
    return lemmatizedTokens
  }
  
}