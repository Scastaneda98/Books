//
//  LandingPageView.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject var landingViewModel = LandingViewModel()
    var body: some View {
        if landingViewModel.books.isEmpty {
            ProgressView()
                .scaleEffect(3.0)
        } else {
            List(landingViewModel.books, id: \.sbid) { book in
                HStack {
                    AsyncImage(url: APIConfig.shared.createImageURL(image: book.ownerPrefs.oCoverImg)) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "book.pages")
                            .frame(width: 80, height: 80)
                            .clipped()
                            .clipShape(Circle())
                    }
                    .frame(width: 80, height: 80)
                    .clipped()
                    .clipShape(Circle())
                    
                    Text(book.ownerPrefs.title)
                        .font(.subheadline)
                        .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    LandingPageView()
}
