//
//  Recipe.swift
//  RecipeSearch
//
//  Created by Eslam on 11/14/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe {
    var id: String = ""
    var title: String = ""
    var image: String = ""
    var source: String = ""
    var url: String = ""
    var ingredients: String = ""
    var healthLabels: String = ""
    
    
    init() {
        
    }
    
    init(_ json: JSON) {
        self.id = json["uri"].stringValue
        self.title = json["label"].stringValue
        self.image = json["image"].stringValue
        self.source = json["source"].stringValue
        self.url = json["url"].stringValue
        
        self.ingredients = json["ingredientLines"].arrayValue
            .map({ $0.stringValue }).joined(separator: "\n")
        
        self.healthLabels = json["healthLabels"].arrayValue
            .map({ $0.stringValue }).joined(separator: ", ")
    }
}
