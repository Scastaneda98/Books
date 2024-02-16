//
//  BooksApp.swift
//  Books
//
//  Created by Santiago Castaneda on 15/02/24.
//

import SwiftUI

@main
struct BooksApp: App {
    var body: some Scene {
        let login = LoginViewModel()
        WindowGroup {
            ContentView().environmentObject(login)
        }
    }
}
