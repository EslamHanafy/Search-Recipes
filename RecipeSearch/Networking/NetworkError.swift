//
//  NetworkError.swift
//  Newroz
//
//  Created by Eslam on 10/11/19.
//  Copyright © 2019 magdsoft. All rights reserved.
//

import Foundation

enum NetworkError: String, Error, LocalizedError {
    case unknownError
    case noConnection
    case serverError
    case unauthorized
    case forbidden
    case notFound
    
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No Internet connection"
        case .serverError:
            return "Server error"
        case .unauthorized:
            return "Couldn't authenticate with current credential"
        case .forbidden:
            return "You don't have permission to perform this request"
        case .notFound:
            return "Items not found"
        default:
            return "Something went wrong, please try again later"
        }
    }
    
    init?(with code: Int) {
        switch code {
        case 200...300:
            return nil
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        default:
            self = isConnectedToNetwork() ? .unknownError : .noConnection
        }
    }
}
