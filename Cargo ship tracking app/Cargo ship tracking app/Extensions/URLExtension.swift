//
//  URLExtension.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 09/11/21.
//

import Foundation

extension URL {
      func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}
