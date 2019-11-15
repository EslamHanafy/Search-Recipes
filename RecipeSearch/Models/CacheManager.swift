//
//  CacheManager.swift
//  RecipeSearch
//
//  Created by Eslam on 11/15/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import Foundation

final class CacheManager {
    private let userDefaults = UserDefaults.standard
    private let key = "RecipeKeyword"
    
    var keywords: [String]
    
    var maxCount = 10
    
    
    static let shared = CacheManager()
    
    
    private init () {
        keywords = userDefaults.stringArray(forKey: key) ?? []
    }
    
    
    func add(_ keyword: String) {
        guard !keywords.contains(keyword) else { return }
        
        keywords.insert(keyword, at: 0)
        if keywords.count > maxCount {
            keywords = keywords.dropLast(keywords.count - maxCount)
        }
        
        userDefaults.set(keywords, forKey: key)
    }
}
