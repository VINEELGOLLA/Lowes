//
//  Errors.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

enum MbError: Error{
    case networkError
    case urlError
    case jsonError
    case NoResult
    case EmptySearchBar
    
    var message: String {
        switch self {
        case .jsonError:
            return "Something went wrong while decoding result"
        case .networkError:
            return "Something went wrong while accessing api"
        case .urlError:
            return "Remove empty spaces"
        case .NoResult:
            return "No result Found"
        case .EmptySearchBar:
            return "Please Enter the Movie Name"
        }
    }
    
    var title: String {
        switch self {
        case .jsonError:
            return "JsonError"
        case .networkError:
            return "NetworkError"
        case .urlError:
            return "UrlError"
        case .NoResult:
            return "No Result"
        case .EmptySearchBar:
            return "SearchBar Empty"
        }
    }
}


