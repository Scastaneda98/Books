//
//  APIConfig.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError {
    case communicationError
    case decodingError
    case unknownError
}

class APIConfig {
    static let shared = APIConfig()
    
    private let baseURL = "https://timetonic.com/live/api.php"
    private let baseImageURL = "https://timetonic.com/live"
    
    func fetchData(with parameters: [String: String], httpMethod: HTTPMethod, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = createRequestURL(parameters: parameters) else {
            print("Error creating request URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    private func createRequestURL(parameters: [String: String]) -> URL?{
        var urlComponents = URLComponents(string: baseURL)
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
