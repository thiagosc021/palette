//
//  UnsplashRoute.swift
//  Palette
//
//  Created by Cameron Stuart on 7/10/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation

enum UnsplashRoute {
    
    static let baseUrl = "https://api.unsplash.com/"
    static let clientId = "wt5au18ZAf9TzHlF5cm4VjC1anPoP0i9fypED5j2K2w"
    
    case random
    case featured
    case doubleRainbow
    
    var path: String {
        switch self {
        case .random:
            return "/photos/random"
        case .featured:
            return "/photos/"
        case .doubleRainbow:
            return "/search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [
            URLQueryItem(name: "client_id", value: UnsplashRoute.clientId),
            URLQueryItem(name: "count", value: "15")
        ]
        switch self {
        case .random, .featured:
            return items
        case .doubleRainbow:
            items.append(URLQueryItem(name: "query", value: "double rainbow"))
            return items
        }
    }
    
    var fullUrl: URL? {
        guard let url = URL(string: UnsplashRoute.baseUrl)?.appendingPathComponent(path) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
}
