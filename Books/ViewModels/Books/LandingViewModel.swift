//
//  LandingViewModel.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import Foundation

class LandingViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    
    init() {
        getAllBooks()
    }
    
    private func getAllBooks() {
        if let sessKey = UserDefaults.standard.object(forKey: "sessKey") as? String, let userId = UserDefaults.standard.object(forKey: "userId") as? String {
            let parameters = ["req":RequireType.getAllBooks.rawValue, "sesskey":sessKey, "o_u": userId, "u_c": userId]
            guard let apiURL = APIConfig.shared.createRequestURL(parameters: parameters) else { return }

            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                
                do {
                    let json = try JSONDecoder().decode(BooksModel.self, from: data)
                    DispatchQueue.main.async {
                        self.books = json.allBooks.books
                    }
                } catch let error as NSError {
                    print("Error:", error.localizedDescription)
                }
            }.resume()
        }
        
    }
}
