//
//  RequestManager+Endpoints.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation
typealias HTTPHeader = [String: String]
enum Endpoints {
    private static let baseUrl = "https://pixabay.com/api/?key="
    private static let apiKey = "16587825-26a8a4f1c49a86a9cd438c341"
    private static let path = "&image_type=photo"
    
    case getImages
    func getImagesWithQuery(query: String) -> URLRequest? {
        switch self {
        case .getImages:
            let queryWithSpace = query.replacingOccurrences(of: " ", with: "%20")
            let urlString = Endpoints.baseUrl + Endpoints.apiKey + "&q=\(queryWithSpace)" + Endpoints.path
            guard let url = URL(string: urlString) else { return nil }
            return URLRequest(url: url)
        }
    }
}
