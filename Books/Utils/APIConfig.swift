//
//  APIConfig.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import Foundation

class APIConfig {
    static let shared = APIConfig()
    
    let baseURL = "https://timetonic.com/live/api.php"
    let baseImageURL = "https://timetonic.com/live"
    
    func createRequestURL(parameters: [String: String]) -> URL?{
        var urlComponents = URLComponents(string: APIConfig.shared.baseURL)
        var queryParameters: [URLQueryItem] = []
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            queryParameters.append(queryItem)
        }
    
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }
    
    func createImageURL(image: String) -> URL? {
        let imageString = image.replacingOccurrences(of: "/dev", with: "")
        return URL(string: "\(baseImageURL)\(imageString)")
    }
}
