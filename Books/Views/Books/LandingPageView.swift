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
            ProgressView("Loading Books")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0)
                .foregroundColor(.blue)
        } else {
            List(landingViewModel.books, id: \.sbid) { book in
                HStack {
                    AsyncImage(url: APIConfig.shared.createImageURL(image: book.ownerPrefs.oCoverImg)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    } placeholder: {
                        Image(systemName: "book.pages")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 60, height: 60)
                    .clipped()
                    .clipShape(Circle())
                    
                    Text(book.ownerPrefs.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                )
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    LandingPageView()
}
