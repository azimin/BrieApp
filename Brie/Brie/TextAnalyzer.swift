//
//  TextAnalyzer.swift
//  Brie
//
//  Created by Vadim Drobinin on 31/10/15.
//  Copyright © 2015 700 km. All rights reserved.
//

import Parsimmon
import Foundation

class TextAnalyzer {
    class func lemmatize() {
        let lemmatizer = ParsimmonLemmatizer()
        let lemmatizedTokens = lemmatizer.lemmatizeWordsInText("Надо позвонить Саше и договориться встретиться в ресторане")
        print(lemmatizedTokens)
    }
}