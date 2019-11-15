//
//  APIManager.swift
//  RecipeSearch
//
//  Created by Eslam on 11/14/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias SearchResult = (recipes: [Recipe], error: NetworkError?)

class APIManager {
    private let appKey = "90d6dd39c97b4f2f0276e33fdae1a912"
    private let appId = "d8c63cb6"
    private let apiUrl = "https://api.edamam.com/search"
    private let itemsPerPage = 20
    
    private var dataCount: Int = 0
    private var canLoadMoreData: Bool = false
    
    
    func getResipes(with keyword: String, at page: Int = 0, withLoader loader: Bool = false, onComplete: @escaping (_ result: SearchResult) -> ()) {
        if loader {
            LoaderView.show(withTitle: "Search for recipes..")
        }
        let parameters = self.parameters(for: keyword, at: page)
        ESLog("Reqest with: ", parameters)
        let request = Alamofire.request(apiUrl, method: .get,
                          parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { [weak self] (response) in
                if loader { LoaderView.hide() }
                
                guard let self = self else { return }
                
                if let error = NetworkError(with: response.response?.statusCode ?? 0) {
                    return onComplete(([], error))
                }
                
                mainQueue {
                    onComplete(self.handleApi(response))
                }
            }
        
        if loader {
            LoaderView.onCancel = {
                request.cancel()
            }
        }
    }
}

//MARK: - Helpers
private extension APIManager {
    func handleApi(_ response: DataResponse<Any>) -> (SearchResult) {
        let json = JSON(response.value ?? [])
        self.dataCount = json["count"].intValue
        self.canLoadMoreData = json["more"].boolValue
        let recipes: [Recipe] = json["hits"].arrayValue
            .map({ $0["recipe"] }).map({ Recipe($0) })
        return(recipes, nil)
    }
    
    func parameters(for keyword: String, at page: Int) -> Parameters {
        let from = page * itemsPerPage
        let to = dataCount > 0 ? min(from + itemsPerPage, dataCount) : itemsPerPage
        
        return [
            "q": keyword,
            "app_id": appId,
            "app_key": appKey,
            "from": from,
            "to": to
        ]
    }
}
