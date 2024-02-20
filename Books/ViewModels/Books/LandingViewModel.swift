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
        guard let sessKey = UserDefaults.standard.object(forKey: UserDefaults.sessionKeyKey) as? String, let userId = UserDefaults.standard.object(forKey: UserDefaults.userIdKey) as? String else { return }
        let parameters = ["req":RequireType.getAllBooks.rawValue, "sesskey":sessKey, "o_u": userId, "u_c": userId]
        APIConfig.shared.fetchData(with: parameters, httpMethod: .post) { data, response, error in
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(BooksModel.self, from: data)
                DispatchQueue.main.async {
                    self.books = json.allBooks.books
                }
            } catch let error as NSError {
                print("Error:", error.localizedDescription)
            }
        }
    }
}
