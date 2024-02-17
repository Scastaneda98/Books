//
//  BookModel.swift
//  Books
//
//  Created by Santiago Castaneda on 16/02/24.
//

import Foundation

struct BookModel: Decodable {
    let sbid: Int
    let ownerPrefs: BookInfoModel
}
