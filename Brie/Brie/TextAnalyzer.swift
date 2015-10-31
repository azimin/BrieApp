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
    class func lemmatize(text: String) {
        let lemmatizer = ParsimmonLemmatizer()
        let lemmatizedTokens = lemmatizer.lemmatizeWordsInText(text)
        print(lemmatizedTokens)
    }
}