//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class Network {
    let apiKey = "5885c445eab51c7004916b9c0313e2d3"
    
    func fetchDataWith(query: String, andPage page: String, onCompletion : @escaping (Result<MovieDataModel,Error>) -> Void) {
        
        let url =
        "https://api.themoviedb.org/3/search/movie?api_key=" + apiKey + "&language=en-US&query=" + query + "&page="+page+"&include_adult=false"
        
        guard let stringUrl = URL(string: url) else {
            onCompletion(.failure(MbError.urlError))
            return
            
        }
        
        URLSession.shared.dataTask(with: stringUrl, completionHandler: { data, urlResponse, error in
            if let _ = error {
                onCompletion(.failure(MbError.networkError))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MovieDataModel.self, from: data)
                        onCompletion(.success(response))
                    } catch _ {
                        onCompletion(.failure(MbError.jsonError))
                    }
                }
        }).resume()
    }
}
