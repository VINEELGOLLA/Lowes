//
//  String+Extension.swift
//  MovieBrowser
//
//  Created by naga vineel golla on 4/23/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

extension String {
    func removeWhiteSpaces(query: String) -> String? {
        var searchText = ""
        searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        searchText = searchText.replacingOccurrences(of: " ", with: "%20")
        
        if searchText.isEmpty {
            return nil
        }
        
        return searchText
    }
}
