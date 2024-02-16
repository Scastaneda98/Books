//
//  LoginView.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import SwiftUI

struct LoginPageView: View {
    @State private var email = String()
    @State private var password = String()
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            if loginViewModel.auth == .Loading {
                ProgressView()
                    .scaleEffect(3.0)
            } else {
                VStack {
                    Text("BOOKS").bold().font(.largeTitle).padding(.top)
                    Spacer()
                    Text("Email").multilineTextAlignment(.leading).bold().font(.title)
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.emailAddress)
                    Text("Password").multilineTextAlignment(.center).bold().font(.title)
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button(action: {
                        loginViewModel.login(email: email, password: password)
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
            }
            
            
        }
    }
}
