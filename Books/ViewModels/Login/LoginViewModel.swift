//
//  LoginViewModel.swift
//  Books
//
//  Created by Santiago Castaneda on 15/02/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var auth: AuthStatus = .Invalid
    @Published var isInvalidForm = false
    @Published var errorMessage = "Please enter a valid email or password"
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty, validateEmail(email) else {
            isInvalidForm = true
            return
        }
        
        auth = .Loading
        fetchAppKey(email: email, password: password)
    }
    
    private func fetchAppKey(email: String, password: String) {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return }
        
        let parameters = ["req":RequireType.appkey.rawValue, "appname":appName]
        
        APIConfig.shared.fetchData(with: parameters, httpMethod: .post) { [self] data, response, error in
            if let error = error {
                handleRequestError(error: error, type: .communicationError)
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AppKeyModel.self, from: responseData)
                self.createOauthkey(email: email, password: password, appkey: response.appkey)
            } catch {
                handleRequestError(error: error, type: .decodingError)
                
            }
        }
    }
    
    private func createOauthkey(email: String, password: String, appkey: String) {
        let parameters = ["req": RequireType.authkey.rawValue, "login": email, "pwd": password, "appkey": appkey]

        APIConfig.shared.fetchData(with: parameters, httpMethod: .post) { [self] data, response, error in
            if let error = error {
                handleRequestError(error: error, type: .communicationError)
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthKeyModel.self, from: responseData)
                UserDefaults.standard.setValue(response.o_u, forKey: UserDefaults.userIdKey)
                self.createSessionkey(authkey: response.oauthkey)
            } catch {
                handleRequestError(error: error, type: .decodingError)
            }
        }
    }
    
    private func createSessionkey(authkey: String) {
        guard let userId = UserDefaults.standard.object(forKey: UserDefaults.userIdKey) as? String else { return }
        
        let parameters = ["req": RequireType.sessionKey.rawValue, "o_u": userId, "u_c": userId, "oauthkey": authkey]
        
        APIConfig.shared.fetchData(with: parameters, httpMethod: .post) { [self] data, response, error in
            if let error = error {
                handleRequestError(error: error, type: .communicationError)
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SessionKeyModel.self, from: responseData)
                if !response.sesskey.isEmpty {
                    DispatchQueue.main.async {
                        UserDefaults.standard.setValue(response.sesskey, forKey: UserDefaults.sessionKeyKey)
                        self.auth = .Success
                    }
                }
            } catch {
                handleRequestError(error: error, type: .decodingError)
            }
        }
    }
    
    private func validateEmail(_ email: String) -> Bool{
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func handleRequestError(error: Error, type: APIError) {
        switch type {
        case .communicationError:
            print("Communication error with the server: \(error)")
        case .decodingError:
            print("Error decoding JSON: \(error)")
        default:
            print("Unknown error: \(error)")
        }

        DispatchQueue.main.async {
            self.auth = .Error
            self.errorMessage = "Authentication failed. Please try again."
            self.isInvalidForm = true
        }
    }
}
