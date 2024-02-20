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
                ProgressView("Loading")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0)
                    .foregroundColor(.blue)
            } else {
                VStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                        .padding(.bottom, 10)
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                    }
                    .padding(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                            .padding()
                    )
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                    }
                    .padding(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                            .padding()
                    )
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        loginViewModel.login(email: email, password: password)
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                }
                .padding()
                .alert(isPresented: $loginViewModel.isInvalidForm) {
                    Alert(
                        title: Text("Error"),
                        message: Text(loginViewModel.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}
