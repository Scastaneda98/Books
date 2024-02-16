//
//  ContentView.swift
//  Books
//
//  Created by Santiago Castaneda on 15/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var login: LoginViewModel
    var body: some View {
        if login.auth == .Success {
            LandingPageView()
        } else {
            LoginPageView()
        }
    }
}


