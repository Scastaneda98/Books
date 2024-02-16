//
//  LoginViewModel.swift
//  Books
//
//  Created by Santiago Castaneda on 15/02/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var auth: AuthStatus = .Invalid
    
    func login(email: String, password: String) {
        auth = .Loading
        createAppKey(email: email, password: password)
    }
    
    private func createAppKey(email: String, password: String) {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return }
        
        let parameters = ["req":RequireType.appkey.rawValue, "appname":appName]
        guard let apiURL = APIConfig.shared.createRequestURL(parameters: parameters) else { return }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) {data,response,error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.auth = .Error
                }
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AppKeyModel.self, from: responseData)
                self.createOauthkey(email: email, password: password, appkey: response.appkey)
            } catch {
                print("Error JSON decoding: \(error)")
                DispatchQueue.main.async {
                    self.auth = .Error
                }
            }
        }.resume()
    }
    
    private func createOauthkey(email: String, password: String, appkey: String) {
        let parameters = ["req": RequireType.authkey.rawValue, "login": email, "pwd": password, "appkey": appkey]
        guard let apiURL = APIConfig.shared.createRequestURL(parameters: parameters) else { return }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) {data,response,error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.auth = .Error
                }
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthKeyModel.self, from: responseData)
                UserDefaults.standard.setValue(response.o_u, forKey: "userId")
                self.createSessionkey(authkey: response.oauthkey)
            } catch {
                print("Error JSON decoding: \(error)")
                DispatchQueue.main.async {
                    self.auth = .Error
                }
            }
        }.resume()
    }
    
    private func createSessionkey(authkey: String) {
        if let userId = UserDefaults.standard.object(forKey: "userId") as? String {
            let parameters = ["req": RequireType.sessionKey.rawValue, "o_u": userId, "u_c": userId, "oauthkey": authkey]
            guard let apiURL = APIConfig.shared.createRequestURL(parameters: parameters) else { return }
            
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) {data,response,error in
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.auth = .Error
                    }
                }
                
                guard let responseData = data else {
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(SessionKeyModel.self, from: responseData)
                    if !response.sesskey.isEmpty {
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(response.sesskey, forKey: "sessKey")
                            self.auth = .Success
                        }
                    }
                    
                } catch {
                    print("Error JSON decoding: \(error)")
                    DispatchQueue.main.async {
                        self.auth = .Error
                    }
                }
            }.resume()
        }
        
        
    }
}
